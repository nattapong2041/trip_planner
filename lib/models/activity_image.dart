import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'activity_image.freezed.dart';
part 'activity_image.g.dart';

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
abstract class ActivityImage with _$ActivityImage {
  const factory ActivityImage({
    required String id,
    required String url, // Firebase Storage download URL
    required String storagePath, // Firebase Storage path for deletion
    required String uploadedBy,
    @TimestampConverter() required DateTime uploadedAt,
    required String originalFileName,
    required int fileSizeBytes,
    int? order, // For custom ordering
    String? caption, // Optional user caption
  }) = _ActivityImage;
  
  const ActivityImage._();
  
  factory ActivityImage.fromJson(Map<String, dynamic> json) => _$ActivityImageFromJson(json);
  
  /// Get file size in human readable format
  String get fileSizeFormatted {
    if (fileSizeBytes < 1024) return '${fileSizeBytes}B';
    if (fileSizeBytes < 1024 * 1024) return '${(fileSizeBytes / 1024).toStringAsFixed(1)}KB';
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
  
  /// Get relative time since upload
  String get uploadedTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(uploadedAt);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${(difference.inDays / 7).floor()}w ago';
  }
  
  /// Convert to JSON with proper serialization for Firestore
  Map<String, dynamic> toFirestoreJson() {
    final json = _$ActivityImageToJson(this as _ActivityImage);
    // Convert DateTime to Timestamp for Firestore
    json['uploadedAt'] = Timestamp.fromDate(uploadedAt);
    return json;
  }
}