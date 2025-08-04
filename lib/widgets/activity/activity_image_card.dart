import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/activity_image.dart';

/// A card widget that displays an individual activity image with metadata
class ActivityImageCard extends ConsumerWidget {
  final ActivityImage image;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showMetadata;
  final double? width;
  final double? height;

  const ActivityImageCard({
    super.key,
    required this.image,
    this.onTap,
    this.onLongPress,
    this.showMetadata = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: SizedBox(
          width: width ?? 200,
          height: height ?? 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image display area
              Expanded(
                child: _buildImageDisplay(context),
              ),
              
              // Metadata area
              if (showMetadata) _buildMetadataArea(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageDisplay(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Main image
        CachedNetworkImage(
          imageUrl: image.url,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildLoadingPlaceholder(),
          errorWidget: (context, url, error) => _buildErrorPlaceholder(context),
          fadeInDuration: const Duration(milliseconds: 300),
          fadeOutDuration: const Duration(milliseconds: 100),
        ),
        
        // Caption overlay (if caption exists)
        if (image.caption != null && image.caption!.isNotEmpty)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCaptionOverlay(context),
          ),
      ],
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text(
              'Loading image...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () {
              // Trigger a rebuild to retry loading
              // This will cause CachedNetworkImage to retry
            },
            child: const Text(
              'Retry',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptionOverlay(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        image.caption!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMetadataArea(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Uploader and timestamp row
          Row(
            children: [
              // User avatar placeholder (will be enhanced later with actual user data)
              CircleAvatar(
                radius: 8,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  image.uploadedBy.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              
              // Uploader and time info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Added by ${_getUploaderDisplayName()}',
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      image.uploadedTimeAgo,
                      style: TextStyle(
                        fontSize: 9,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          // File info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // File size
              Text(
                image.fileSizeFormatted,
                style: TextStyle(
                  fontSize: 9,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              
              // File name (truncated)
              Expanded(
                child: Text(
                  image.originalFileName,
                  style: TextStyle(
                    fontSize: 9,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getUploaderDisplayName() {
    // For now, return a truncated version of the user ID
    // This will be enhanced later when we have access to user data
    if (image.uploadedBy.length > 8) {
      return '${image.uploadedBy.substring(0, 8)}...';
    }
    return image.uploadedBy;
  }
}

/// A specialized version of ActivityImageCard for use in galleries
class ActivityImageGalleryCard extends ConsumerWidget {
  final ActivityImage image;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isSelected;

  const ActivityImageGalleryCard({
    super.key,
    required this.image,
    this.onTap,
    this.onDelete,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      onLongPress: onDelete != null ? () => _showDeleteDialog(context) : null,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              CachedNetworkImage(
                imageUrl: image.url,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[100],
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey[400],
                    size: 32,
                  ),
                ),
              ),
              
              // Overlay with metadata
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
                      // User indicator
                      CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: Text(
                          image.uploadedBy.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 8,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      
                      // Time ago
                      Expanded(
                        child: Text(
                          image.uploadedTimeAgo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Selection indicator
              if (isSelected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.check,
                      color: theme.colorScheme.onPrimary,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Image'),
        content: const Text(
          'Are you sure you want to delete this image? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}