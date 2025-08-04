import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/activity_image.dart';
import '../../providers/providers.dart';

/// A full-screen image viewer with zoom, swipe navigation, and caption editing
class FullScreenImageViewer extends ConsumerStatefulWidget {
  final List<ActivityImage> images;
  final int initialIndex;
  final String activityId;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.activityId,
  });

  @override
  ConsumerState<FullScreenImageViewer> createState() =>
      _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends ConsumerState<FullScreenImageViewer>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _overlayController;
  late AnimationController _fadeController;

  int _currentIndex = 0;
  bool _showOverlay = true;
  bool _isEditingCaption = false;
  final TextEditingController _captionController = TextEditingController();
  final FocusNode _captionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _overlayController.forward();
    _fadeController.forward();

    // Set initial caption
    _updateCaptionController();

    // Auto-hide overlay after 3 seconds
    _startOverlayTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _overlayController.dispose();
    _fadeController.dispose();
    _captionController.dispose();
    _captionFocusNode.dispose();
    super.dispose();
  }

  void _updateCaptionController() {
    if (_currentIndex < widget.images.length) {
      _captionController.text = widget.images[_currentIndex].caption ?? '';
    }
  }

  void _startOverlayTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _showOverlay && !_isEditingCaption) {
        _toggleOverlay();
      }
    });
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });

    if (_showOverlay) {
      _overlayController.forward();
      _startOverlayTimer();
    } else {
      _overlayController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main image viewer
          _buildImageViewer(),

          // Top overlay (app bar)
          _buildTopOverlay(),

          // Bottom overlay (image details and caption)
          _buildBottomOverlay(),

          // Navigation indicators
          if (widget.images.length > 1) _buildNavigationIndicators(),
        ],
      ),
    );
  }

  Widget _buildImageViewer() {
    return GestureDetector(
      onTap: _toggleOverlay,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
            _isEditingCaption = false;
          });
          _updateCaptionController();
          HapticFeedback.selectionClick();
        },
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return _buildZoomableImage(widget.images[index]);
        },
      ),
    );
  }

  Widget _buildZoomableImage(ActivityImage image) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: CachedNetworkImage(
          imageUrl: image.url,
          fit: BoxFit.contain,
          placeholder: (context, url) => _buildImagePlaceholder(),
          errorWidget: (context, url, error) => _buildImageError(),
          fadeInDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
          SizedBox(height: 16),
          Text(
            'Loading image...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageError() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            color: Colors.white70,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'Failed to load image',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopOverlay() {
    return AnimatedBuilder(
      animation: _overlayController,
      builder: (context, child) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(0, -100 * (1 - _overlayController.value)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    '${_currentIndex + 1} of ${widget.images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: _showImageOptions,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomOverlay() {
    final currentImage = widget.images[_currentIndex];

    return AnimatedBuilder(
      animation: _overlayController,
      builder: (context, child) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(0, 200 * (1 - _overlayController.value)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image metadata
                      _buildImageMetadata(currentImage),

                      const SizedBox(height: 12),

                      // Caption section
                      _buildCaptionSection(currentImage),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageMetadata(ActivityImage image) {
    return Row(
      children: [
        // User avatar
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Text(
            image.uploadedBy.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // User info and metadata
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Added by ${_getUploaderDisplayName(image.uploadedBy)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    image.uploadedTimeAgo,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    ' • ${image.fileSizeFormatted}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCaptionSection(ActivityImage image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Caption header
        Row(
          children: [
            const Text(
              'Caption',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (!_isEditingCaption)
              TextButton(
                onPressed: _startEditingCaption,
                child: Text(
                  image.caption?.isNotEmpty == true ? 'Edit' : 'Add',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // Caption content
        if (_isEditingCaption)
          _buildCaptionEditor()
        else
          _buildCaptionDisplay(image),
      ],
    );
  }

  Widget _buildCaptionDisplay(ActivityImage image) {
    if (image.caption?.isNotEmpty == true) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          image.caption!,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            height: 1.4,
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Text(
          'No caption added',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
  }

  Widget _buildCaptionEditor() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          TextField(
            controller: _captionController,
            focusNode: _captionFocusNode,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'Add a caption for this image...',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _cancelEditingCaption,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveCaption,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationIndicators() {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _overlayController,
        builder: (context, child) {
          return Opacity(
            opacity: _overlayController.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentIndex
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: const Text(
                'Edit Caption',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _startEditingCaption();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete Image',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete Image',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this image? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteCurrentImage();
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

  void _startEditingCaption() {
    setState(() {
      _isEditingCaption = true;
    });
    _captionFocusNode.requestFocus();
  }

  void _cancelEditingCaption() {
    setState(() {
      _isEditingCaption = false;
    });
    _updateCaptionController();
    _captionFocusNode.unfocus();
  }

  Future<void> _saveCaption() async {
    try {
      final currentImage = widget.images[_currentIndex];
      final notifier =
          ref.read(activityImageNotifierProvider(widget.activityId).notifier);

      await notifier.updateCaption(currentImage.id, _captionController.text);

      setState(() {
        _isEditingCaption = false;
      });
      _captionFocusNode.unfocus();
    } catch (error) {
      // Error is handled by the provider and shown globally
    }
  }

  Future<void> _deleteCurrentImage() async {
    try {
      final currentImage = widget.images[_currentIndex];
      final notifier =
          ref.read(activityImageNotifierProvider(widget.activityId).notifier);

      await notifier.removeImage(currentImage.id);

      // Close the viewer if this was the last image
      if (widget.images.length <= 1) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        // Navigate to the previous image if we deleted the last one
        if (_currentIndex >= widget.images.length - 1) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    } catch (error) {
      // Error is handled by the provider and shown globally
    }
  }

  String _getUploaderDisplayName(String uploadedBy) {
    // For now, return a truncated version of the user ID
    // This will be enhanced later when we have access to user data
    if (uploadedBy.length > 12) {
      return '${uploadedBy.substring(0, 12)}...';
    }
    return uploadedBy;
  }
}
