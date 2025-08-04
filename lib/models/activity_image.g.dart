// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityImage _$ActivityImageFromJson(Map<String, dynamic> json) =>
    _ActivityImage(
      id: json['id'] as String,
      url: json['url'] as String,
      storagePath: json['storagePath'] as String,
      uploadedBy: json['uploadedBy'] as String,
      uploadedAt: const TimestampConverter().fromJson(json['uploadedAt']),
      originalFileName: json['originalFileName'] as String,
      fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
      order: (json['order'] as num?)?.toInt(),
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$ActivityImageToJson(_ActivityImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'storagePath': instance.storagePath,
      'uploadedBy': instance.uploadedBy,
      'uploadedAt': const TimestampConverter().toJson(instance.uploadedAt),
      'originalFileName': instance.originalFileName,
      'fileSizeBytes': instance.fileSizeBytes,
      'order': instance.order,
      'caption': instance.caption,
    };
