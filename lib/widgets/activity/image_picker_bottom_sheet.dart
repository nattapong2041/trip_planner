import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/responsive.dart';
import '../../services/permission_service.dart';

/// Bottom sheet widget for selecting image source (camera or gallery)
/// Provides clear visual indicators and proper permission handling
class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({
    super.key,
    required this.onSourceSelected,
    this.title = 'Add Image',
    this.subtitle = 'Choose how you want to add an image',
  });

  final Function(ImageSource source) onSourceSelected;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(
                top: Responsive.getSpacing(context, baseSpacing: 12.0),
              ),
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: EdgeInsets.all(
                Responsive.getSpacing(context, baseSpacing: 24.0),
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Options
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.getSpacing(context, baseSpacing: 24.0),
              ),
              child: Column(
                children: [
                  // Camera option
                  _ImageSourceOption(
                    icon: Icons.camera_alt_outlined,
                    title: 'Camera',
                    subtitle: 'Take a new photo',
                    onTap: () => _handleSourceSelection(context, ImageSource.camera),
                  ),
                  
                  SizedBox(height: Responsive.getSpacing(context, baseSpacing: 12.0)),
                  
                  // Gallery option
                  _ImageSourceOption(
                    icon: Icons.photo_library_outlined,
                    title: 'Gallery',
                    subtitle: 'Choose from your photos',
                    onTap: () => _handleSourceSelection(context, ImageSource.gallery),
                  ),
                ],
              ),
            ),
            
            // Cancel button
            Padding(
              padding: EdgeInsets.all(
                Responsive.getSpacing(context, baseSpacing: 24.0),
              ),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: Responsive.getSpacing(context, baseSpacing: 16.0),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSourceSelection(BuildContext context, ImageSource source) async {
    Navigator.of(context).pop();
    
    // Check and request permissions based on source
    bool hasPermission = false;
    String permissionType = '';
    
    if (source == ImageSource.camera) {
      hasPermission = await PermissionService.requestCameraPermission();
      permissionType = 'camera';
    } else {
      hasPermission = await PermissionService.requestPhotoLibraryPermission();
      permissionType = 'photo library';
    }
    
    if (!hasPermission) {
      if (context.mounted) {
        _showPermissionDeniedDialog(context, permissionType);
      }
      return;
    }
    
    onSourceSelected(source);
  }

  void _showPermissionDeniedDialog(BuildContext context, String permissionType) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: colorScheme.error,
          size: Responsive.getIconSize(context, baseSize: 32),
        ),
        title: Text(
          'Permission Required',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          PermissionService.getPermissionDeniedMessage(permissionType),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              PermissionService.openAppSettings();
            },
            child: Text(
              'Settings',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  /// Show the image picker bottom sheet
  static Future<void> show({
    required BuildContext context,
    required Function(ImageSource source) onSourceSelected,
    String title = 'Add Image',
    String subtitle = 'Choose how you want to add an image',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ImagePickerBottomSheet(
        onSourceSelected: onSourceSelected,
        title: title,
        subtitle: subtitle,
      ),
    );
  }
}

/// Individual option widget for image source selection
class _ImageSourceOption extends StatelessWidget {
  const _ImageSourceOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(
            Responsive.getSpacing(context, baseSpacing: 16.0),
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: Responsive.getIconSize(context, baseSize: 48),
                height: Responsive.getIconSize(context, baseSize: 48),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: Responsive.getIconSize(context, baseSize: 24),
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              
              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 16.0)),
              
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: Responsive.getSpacing(context, baseSpacing: 4.0)),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: Responsive.getIconSize(context, baseSize: 16),
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}