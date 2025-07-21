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
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TripToJson(_Trip instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'durationDays': instance.durationDays,
      'ownerId': instance.ownerId,
      'collaboratorIds': instance.collaboratorIds,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
