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
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BrainstormIdeaToJson(_BrainstormIdea instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
    };
