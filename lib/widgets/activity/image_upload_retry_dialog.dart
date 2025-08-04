import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/activity_image_provider.dart';

/// Dialog shown when image upload fails, offering retry options
class ImageUploadRetryDialog extends ConsumerWidget {
  final String activityId;
  final ImageSource source;
  final String errorMessage;
  final VoidCallback? onCancel;

  const ImageUploadRetryDialog({
    super.key,
    required this.activityId,
    required this.source,
    required this.errorMessage,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 24,
          ),
          const SizedBox(width: 8),
          const Text('Upload Failed'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The image upload failed with the following error:',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              errorMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Would you like to try uploading the image again?',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: () => _retryUpload(context, ref),
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Retry'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Future<void> _retryUpload(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pop();
    
    try {
      final notifier = ref.read(activityImageNotifierProvider(activityId).notifier);
      await notifier.addImage(source);
    } catch (error) {
      // Error will be handled by the provider and shown globally
    }
  }

  /// Static method to show the retry dialog
  static Future<void> show(
    BuildContext context, {
    required String activityId,
    required ImageSource source,
    required String errorMessage,
    VoidCallback? onCancel,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ImageUploadRetryDialog(
        activityId: activityId,
        source: source,
        errorMessage: errorMessage,
        onCancel: onCancel,
      ),
    );
  }
}

/// Widget that shows a retry button for failed uploads
class ImageUploadRetryButton extends ConsumerWidget {
  final String activityId;
  final ImageSource source;
  final String errorMessage;
  final VoidCallback? onCancel;

  const ImageUploadRetryButton({
    super.key,
    required this.activityId,
    required this.source,
    required this.errorMessage,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Upload Failed',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _retryUpload(ref),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _retryUpload(WidgetRef ref) async {
    try {
      final notifier = ref.read(activityImageNotifierProvider(activityId).notifier);
      await notifier.addImage(source);
    } catch (error) {
      // Error will be handled by the provider and shown globally
    }
  }
}