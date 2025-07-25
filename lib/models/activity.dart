import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'brainstorm_idea.dart';

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
  }) = _Activity;
  
  const Activity._();
  
  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
  
  /// Convert to JSON with proper serialization for Firestore
  Map<String, dynamic> toFirestoreJson() {
    final json = _$ActivityToJson(this as _Activity);
    // Convert DateTime to Timestamp for Firestore
    json['createdAt'] = Timestamp.fromDate(createdAt);
    // Ensure brainstormIdeas are properly serialized as JSON objects
    json['brainstormIdeas'] = brainstormIdeas.map((idea) => idea.toJson()).toList();
    return json;
  }
}

