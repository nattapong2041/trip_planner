import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'brainstorm_idea.freezed.dart';
part 'brainstorm_idea.g.dart';

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
abstract class BrainstormIdea with _$BrainstormIdea {
  const factory BrainstormIdea({
    required String id,
    required String description,
    required String createdBy,
    @TimestampConverter() required DateTime createdAt,
    @Default(0) int order, // for reordering brainstorm ideas
  }) = _BrainstormIdea;
  
  const BrainstormIdea._();
  
  factory BrainstormIdea.fromJson(Map<String, dynamic> json) => _$BrainstormIdeaFromJson(json);
  
  /// Convert to JSON with proper serialization for Firestore
  Map<String, dynamic> toFirestoreJson() {
    final json = _$BrainstormIdeaToJson(this as _BrainstormIdea);
    // Convert DateTime to Timestamp for Firestore
    json['createdAt'] = Timestamp.fromDate(createdAt);
    return json;
  }
}