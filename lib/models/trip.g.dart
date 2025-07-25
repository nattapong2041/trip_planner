// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Trip _$TripFromJson(Map<String, dynamic> json) => _Trip(
      id: json['id'] as String,
      name: json['name'] as String,
      durationDays: (json['durationDays'] as num).toInt(),
      ownerId: json['ownerId'] as String,
      collaboratorIds: (json['collaboratorIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$TripToJson(_Trip instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'durationDays': instance.durationDays,
      'ownerId': instance.ownerId,
      'collaboratorIds': instance.collaboratorIds,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
