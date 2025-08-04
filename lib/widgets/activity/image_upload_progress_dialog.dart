import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

/// States for image upload process
enum ImageUploadState {
  optimizing,
  uploading,
  completed,
  error,
  cancelled,
}

/// Data class for upload progress information
class ImageUploadProgress {
  const ImageUploadProgress({
    required this.state,
    this.progress = 0.0,
    this.fileName,
    this.error,
  });

  final ImageUploadState state;
  final double progress; // 0.0 to 1.0
  final String? fileName;
  final String? error;

  ImageUploadProgress copyWith({
    ImageUploadState? state,
    double? progress,
    String? fileName,
    String? error,
  }) {
    return ImageUploadProgress(
      state: state ?? this.state,
      progress: progress ?? this.progress,
      fileName: fileName ?? this.fileName,
      error: error ?? this.error,
    );
  }
}

/// Dialog widget for showing image upload progress with cancellation support
class ImageUploadProgressDialog extends StatelessWidget {
  const ImageUploadProgressDialog({
    super.key,
    required this.progress,
    this.onCancel,
    this.onRetry,
    this.onDismiss,
  });

  final ImageUploadProgress progress;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          Responsive.getSpacing(context, baseSpacing: 24.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon and title based on state
            _buildHeader(context),
            
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 16.0)),
            
            // Progress indicator or error message
            _buildContent(context),
            
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
            
            // Action buttons
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    IconData icon;
    Color iconColor;
    String title;
    
    switch (progress.state) {
      case ImageUploadState.optimizing:
        icon = Icons.tune;
        iconColor = colorScheme.primary;
        title = 'Optimizing Image';
        break;
      case ImageUploadState.uploading:
        icon = Icons.cloud_upload_outlined;
        iconColor = colorScheme.primary;
        title = 'Uploading Image';
        break;
      case ImageUploadState.completed:
        icon = Icons.check_circle_outline;
        iconColor = colorScheme.primary;
        title = 'Upload Complete';
        break;
      case ImageUploadState.error:
        icon = Icons.error_outline;
        iconColor = colorScheme.error;
        title = 'Upload Failed';
        break;
      case ImageUploadState.cancelled:
        icon = Icons.cancel_outlined;
        iconColor = colorScheme.onSurfaceVariant;
        title = 'Upload Cancelled';
        break;
    }
    
    return Column(
      children: [
        Icon(
          icon,
          size: Responsive.getIconSize(context, baseSize: 48),
          color: iconColor,
        ),
        SizedBox(height: Responsive.getSpacing(context, baseSpacing: 12.0)),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    switch (progress.state) {
      case ImageUploadState.optimizing:
        return Column(
          children: [
            LinearProgressIndicator(
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 12.0)),
            Text(
              'Compressing image for optimal upload...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (progress.fileName != null) ...[
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Text(
                progress.fileName!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        );
        
      case ImageUploadState.uploading:
        final percentage = (progress.progress * 100).toInt();
        return Column(
          children: [
            LinearProgressIndicator(
              value: progress.progress,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 12.0)),
            Text(
              'Uploading... $percentage%',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (progress.fileName != null) ...[
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Text(
                progress.fileName!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        );
        
      case ImageUploadState.completed:
        return Column(
          children: [
            Icon(
              Icons.check_circle,
              size: Responsive.getIconSize(context, baseSize: 32),
              color: colorScheme.primary,
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
            Text(
              'Image uploaded successfully!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
        
      case ImageUploadState.error:
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(
                Responsive.getSpacing(context, baseSpacing: 16.0),
              ),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.error.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: colorScheme.error,
                    size: Responsive.getIconSize(context, baseSize: 20),
                  ),
                  SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                  Expanded(
                    child: Text(
                      progress.error ?? 'An error occurred during upload',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        
      case ImageUploadState.cancelled:
        return Text(
          'Upload was cancelled by user',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        );
    }
  }

  Widget _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    switch (progress.state) {
      case ImageUploadState.optimizing:
      case ImageUploadState.uploading:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onCancel,
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        );
        
      case ImageUploadState.completed:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onDismiss ?? () => Navigator.of(context).pop(),
              child: Text(
                'Done',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        );
        
      case ImageUploadState.error:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onDismiss ?? () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text('Retry'),
            ),
          ],
        );
        
      case ImageUploadState.cancelled:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onDismiss ?? () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        );
    }
  }

  /// Show the upload progress dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required ImageUploadProgress progress,
    VoidCallback? onCancel,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
    bool barrierDismissible = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => ImageUploadProgressDialog(
        progress: progress,
        onCancel: onCancel,
        onRetry: onRetry,
        onDismiss: onDismiss,
      ),
    );
  }
}

/// Controller for managing image upload progress dialog
class ImageUploadProgressController {
  ImageUploadProgressController({
    required this.context,
    this.onCancel,
    this.onRetry,
  });

  final BuildContext context;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  
  bool _isShowing = false;
  ImageUploadProgress _currentProgress = const ImageUploadProgress(
    state: ImageUploadState.optimizing,
  );

  /// Show the progress dialog
  void show({String? fileName}) {
    if (_isShowing) return;
    
    _isShowing = true;
    _currentProgress = ImageUploadProgress(
      state: ImageUploadState.optimizing,
      fileName: fileName,
    );
    
    ImageUploadProgressDialog.show(
      context: context,
      progress: _currentProgress,
      onCancel: () {
        _isShowing = false;
        Navigator.of(context).pop();
        onCancel?.call();
      },
      onRetry: () {
        _isShowing = false;
        Navigator.of(context).pop();
        onRetry?.call();
      },
      onDismiss: () {
        _isShowing = false;
        Navigator.of(context).pop();
      },
    );
  }

  /// Update progress to uploading state
  void updateUploading(double progress) {
    if (!_isShowing) return;
    
    _currentProgress = _currentProgress.copyWith(
      state: ImageUploadState.uploading,
      progress: progress,
    );
    
    // Update the dialog by popping and showing again
    Navigator.of(context).pop();
    ImageUploadProgressDialog.show(
      context: context,
      progress: _currentProgress,
      onCancel: () {
        _isShowing = false;
        Navigator.of(context).pop();
        onCancel?.call();
      },
      onRetry: () {
        _isShowing = false;
        Navigator.of(context).pop();
        onRetry?.call();
      },
      onDismiss: () {
        _isShowing = false;
        Navigator.of(context).pop();
      },
    );
  }

  /// Update progress to completed state
  void updateCompleted() {
    if (!_isShowing) return;
    
    _currentProgress = _currentProgress.copyWith(
      state: ImageUploadState.completed,
      progress: 1.0,
    );
    
    Navigator.of(context).pop();
    ImageUploadProgressDialog.show(
      context: context,
      progress: _currentProgress,
      onDismiss: () {
        _isShowing = false;
        Navigator.of(context).pop();
      },
    );
  }

  /// Update progress to error state
  void updateError(String error) {
    if (!_isShowing) return;
    
    _currentProgress = _currentProgress.copyWith(
      state: ImageUploadState.error,
      error: error,
    );
    
    Navigator.of(context).pop();
    ImageUploadProgressDialog.show(
      context: context,
      progress: _currentProgress,
      onRetry: () {
        _isShowing = false;
        Navigator.of(context).pop();
        onRetry?.call();
      },
      onDismiss: () {
        _isShowing = false;
        Navigator.of(context).pop();
      },
    );
  }

  /// Hide the dialog
  void hide() {
    if (!_isShowing) return;
    
    _isShowing = false;
    Navigator.of(context).pop();
  }

  /// Check if dialog is currently showing
  bool get isShowing => _isShowing;
}