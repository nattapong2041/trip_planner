import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/activity_image.dart';
import '../../providers/providers.dart';
import 'activity_image_card.dart';
import 'full_screen_image_viewer.dart';

/// A horizontal scrollable gallery widget for displaying activity images
class ActivityImageGallery extends ConsumerStatefulWidget {
  final String activityId;
  final Function(ActivityImage)? onImageTap;
  final bool allowReordering;
  final bool showAddButton;

  const ActivityImageGallery({
    super.key,
    required this.activityId,
    this.onImageTap,
    this.allowReordering = true,
    this.showAddButton = true,
  });

  @override
  ConsumerState<ActivityImageGallery> createState() =>
      _ActivityImageGalleryState();
}

class _ActivityImageGalleryState extends ConsumerState<ActivityImageGallery> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imagesAsync =
        ref.watch(activityImageNotifierProvider(widget.activityId));

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use available height or default to 160
        final availableHeight =
            constraints.maxHeight.isFinite ? constraints.maxHeight : 160.0;

        return SizedBox(
          height: availableHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with image count
              _buildHeader(context, theme, imagesAsync),

              const SizedBox(height: 8),

              // Gallery content
              Expanded(
                child: imagesAsync.when(
                  data: (images) => _buildGalleryContent(context, images),
                  loading: () => _buildLoadingState(),
                  error: (error, stack) => _buildErrorState(context, error),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme,
      AsyncValue<List<ActivityImage>> imagesAsync) {
    final imageCount = imagesAsync.maybeWhen(
      data: (images) => images.length,
      orElse: () => 0,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title and count
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Images',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$imageCount of 5 images',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),

        // Add button
        if (widget.showAddButton && imageCount < 5)
          _buildAddImageButton(context, theme),
      ],
    );
  }

  Widget _buildAddImageButton(BuildContext context, ThemeData theme) {
    return PopupMenuButton<ImageSource>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.add_photo_alternate,
          color: theme.colorScheme.onPrimary,
          size: 20,
        ),
      ),
      tooltip: 'Add Image',
      onSelected: (source) => _addImage(source),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: ImageSource.camera,
          child: Row(
            children: [
              Icon(Icons.camera_alt),
              SizedBox(width: 12),
              Text('Take Photo'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: ImageSource.gallery,
          child: Row(
            children: [
              Icon(Icons.photo_library),
              SizedBox(width: 12),
              Text('Choose from Gallery'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryContent(
      BuildContext context, List<ActivityImage> images) {
    if (images.isEmpty) {
      return _buildEmptyState(context);
    }

    return widget.allowReordering
        ? _buildReorderableGallery(context, images)
        : _buildStaticGallery(context, images);
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: 8),
          Text(
            'Add images to visualize this activity',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          if (widget.showAddButton)
            ElevatedButton.icon(
              onPressed: () => _showImageSourceDialog(context),
              icon: const Icon(Icons.add_photo_alternate, size: 18),
              label: const Text('Add Image'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStaticGallery(BuildContext context, List<ActivityImage> images) {
    return ListView.separated(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemCount: images.length,
      separatorBuilder: (context, index) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final image = images[index];
        return ActivityImageGalleryCard(
          image: image,
          onTap: () => _openFullScreenViewer(images, index),
          onDelete: () => _deleteImage(image.id),
        );
      },
    );
  }

  Widget _buildReorderableGallery(
      BuildContext context, List<ActivityImage> images) {
    return ReorderableListView.builder(
      scrollController: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemCount: images.length,
      onReorder: (oldIndex, newIndex) =>
          _reorderImages(images, oldIndex, newIndex),
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final t = Curves.easeInOut.transform(animation.value);
            final elevation = lerpDouble(0, 6, t) ?? 0;
            final scale = lerpDouble(1, 1.02, t) ?? 1;

            return Transform.scale(
              scale: scale,
              child: Material(
                elevation: elevation,
                borderRadius: BorderRadius.circular(8),
                child: child,
              ),
            );
          },
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final image = images[index];
        return Container(
          key: ValueKey(image.id),
          margin: const EdgeInsets.only(right: 8),
          child: ActivityImageGalleryCard(
            image: image,
            onTap: () => _openFullScreenViewer(images, index),
            onDelete: () => _deleteImage(image.id),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text(
              'Loading images...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load images',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            error.toString(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                ref.refresh(activityImageNotifierProvider(widget.activityId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _addImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _addImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _addImage(ImageSource source) async {
    try {
      final notifier =
          ref.read(activityImageNotifierProvider(widget.activityId).notifier);
      await notifier.addImage(source);

      // Force a rebuild to ensure the new image is displayed
      if (mounted) {
        setState(() {});
      }

      // Scroll to the end to show the new image
      if (_scrollController.hasClients) {
        await Future.delayed(const Duration(milliseconds: 500));
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (error) {
      // Error is handled by the provider and shown globally
    }
  }

  Future<void> _deleteImage(String imageId) async {
    try {
      final notifier =
          ref.read(activityImageNotifierProvider(widget.activityId).notifier);
      await notifier.removeImage(imageId);

      // Force a rebuild to ensure the UI updates
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      // Error is handled by the provider and shown globally
    }
  }

  Future<void> _reorderImages(
      List<ActivityImage> images, int oldIndex, int newIndex) async {
    try {
      // Adjust newIndex if moving item down
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      // Create new order list
      final reorderedImages = List<ActivityImage>.from(images);
      final item = reorderedImages.removeAt(oldIndex);
      reorderedImages.insert(newIndex, item);

      // Extract image IDs in new order
      final imageIds = reorderedImages.map((img) => img.id).toList();

      // Update the order
      final notifier =
          ref.read(activityImageNotifierProvider(widget.activityId).notifier);
      await notifier.reorderImages(imageIds);
    } catch (error) {
      // Error is handled by the provider and shown globally
    }
  }

  void _openFullScreenViewer(List<ActivityImage> images, int initialIndex) {
    // Use the custom onImageTap if provided, otherwise open full screen viewer
    if (widget.onImageTap != null) {
      widget.onImageTap!(images[initialIndex]);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullScreenImageViewer(
            images: images,
            initialIndex: initialIndex,
            activityId: widget.activityId,
          ),
          fullscreenDialog: true,
        ),
      );
    }
  }
}

// Helper function for lerping double values
double? lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}
