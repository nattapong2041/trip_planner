import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

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
abstract class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String name,
    required int durationDays,
    required String ownerId,
    required List<String> collaboratorIds,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _Trip;
  
  const Trip._();
  
  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
  
  /// Convert to JSON with proper serialization for Firestore
  Map<String, dynamic> toFirestoreJson() {
    final json = _$TripToJson(this as _Trip);
    // Convert DateTime to Timestamp for Firestore
    json['createdAt'] = Timestamp.fromDate(createdAt);
    json['updatedAt'] = Timestamp.fromDate(updatedAt);
    return json;
  }
}