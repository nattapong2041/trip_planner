import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

/// Service for handling app permissions
class PermissionService {
  static final Logger _logger = Logger();

  /// Check and request camera permission
  static Future<bool> requestCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      
      if (status.isGranted) {
        return true;
      }
      
      if (status.isDenied) {
        final result = await Permission.camera.request();
        return result.isGranted;
      }
      
      if (status.isPermanentlyDenied) {
        _logger.w('Camera permission permanently denied');
        return false;
      }
      
      return false;
    } catch (e) {
      _logger.e('Error requesting camera permission: $e');
      return false;
    }
  }

  /// Check and request photo library permission
  static Future<bool> requestPhotoLibraryPermission() async {
    try {
      final status = await Permission.photos.status;
      
      if (status.isGranted) {
        return true;
      }
      
      if (status.isDenied) {
        final result = await Permission.photos.request();
        return result.isGranted;
      }
      
      if (status.isPermanentlyDenied) {
        _logger.w('Photo library permission permanently denied');
        return false;
      }
      
      return false;
    } catch (e) {
      _logger.e('Error requesting photo library permission: $e');
      return false;
    }
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    try {
      final status = await Permission.camera.status;
      return status.isGranted;
    } catch (e) {
      _logger.e('Error checking camera permission: $e');
      return false;
    }
  }

  /// Check if photo library permission is granted
  static Future<bool> isPhotoLibraryPermissionGranted() async {
    try {
      final status = await Permission.photos.status;
      return status.isGranted;
    } catch (e) {
      _logger.e('Error checking photo library permission: $e');
      return false;
    }
  }

  /// Open app settings for permission management
  static Future<bool> openAppSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      _logger.e('Error opening app settings: $e');
      return false;
    }
  }

  /// Get permission status message for UI display
  static String getPermissionDeniedMessage(String permissionType) {
    return 'Permission to access $permissionType is required. Please enable it in Settings.';
  }
}