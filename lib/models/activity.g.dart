// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      place: json['place'] as String,
      activityType: json['activityType'] as String,
      price: json['price'] as String?,
      notes: json['notes'] as String?,
      assignedDay: json['assignedDay'] as String?,
      dayOrder: (json['dayOrder'] as num?)?.toInt(),
      timeSlot: json['timeSlot'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      brainstormIdeas: (json['brainstormIdeas'] as List<dynamic>?)
              ?.map((e) => BrainstormIdea.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ActivityImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'place': instance.place,
      'activityType': instance.activityType,
      'price': instance.price,
      'notes': instance.notes,
      'assignedDay': instance.assignedDay,
      'dayOrder': instance.dayOrder,
      'timeSlot': instance.timeSlot,
      'createdBy': instance.createdBy,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'brainstormIdeas': instance.brainstormIdeas,
      'images': instance.images,
    };
