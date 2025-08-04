import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'brainstorm_idea.dart';
import 'activity_image.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// Custom converter for Firestore Timestamps
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.parse(json);
    } else if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    throw ArgumentError('Cannot convert $json to DateTime');
  }

  @override
  dynamic toJson(DateTime dateTime) => dateTime.toIso8601String();
}

@freezed
abstract class Activity with _$Activity {
  const factory Activity({
    required String id,
    required String tripId,
    required String place,
    required String activityType,
    String? price,
    String? notes,
    String? assignedDay, // null if in activity pool
    int? dayOrder,
    String? timeSlot, // e.g., "09:00", "14:30" - time for the activity
    required String createdBy,
    @TimestampConverter() required DateTime createdAt,
    @Default([]) List<BrainstormIdea> brainstormIdeas,
    @Default([]) List<ActivityImage> images,
  }) = _Activity;
  
  const Activity._();
  
  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
  
  /// Check if activity can accept more images (max 5)
  bool get canAddMoreImages => images.length < 5;
  
  /// Get images count display text
  String get imagesCountText => '${images.length} of 5 images';
  
  /// Get the number of images in this activity
  int get imageCount => images.length;
  
  /// Check if activity has reached maximum image capacity
  bool get isAtImageCapacity => images.length >= 5;
  
  /// Convert to JSON with proper serialization for Firestore
  Map<String, dynamic> toFirestoreJson() {
    final json = _$ActivityToJson(this as _Activity);
    // Convert DateTime to Timestamp for Firestore
    json['createdAt'] = Timestamp.fromDate(createdAt);
    // Ensure brainstormIdeas are properly serialized as JSON objects
    json['brainstormIdeas'] = brainstormIdeas.map((idea) => idea.toJson()).toList();
    // Ensure images are properly serialized as JSON objects
    json['images'] = images.map((image) => image.toFirestoreJson()).toList();
    return json;
  }
}

