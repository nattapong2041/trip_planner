// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brainstorm_idea.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BrainstormIdea _$BrainstormIdeaFromJson(Map<String, dynamic> json) =>
    _BrainstormIdea(
      id: json['id'] as String,
      description: json['description'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BrainstormIdeaToJson(_BrainstormIdea instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'order': instance.order,
    };
