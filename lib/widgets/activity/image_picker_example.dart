import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'image_picker_bottom_sheet.dart';
import 'image_upload_progress_dialog.dart';

/// Example widget demonstrating how to use ImagePickerBottomSheet and ImageUploadProgressDialog together
class ImagePickerExample extends StatefulWidget {
  const ImagePickerExample({super.key});

  @override
  State<ImagePickerExample> createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _showImagePicker,
              child: const Text('Add Image'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showProgressDialog,
              child: const Text('Show Progress Dialog'),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePicker() {
    ImagePickerBottomSheet.show(
      context: context,
      onSourceSelected: (source) {
        _handleImageSourceSelected(source);
      },
    );
  }

  void _handleImageSourceSelected(ImageSource source) {
    // Simulate image upload process
    _simulateImageUpload(source);
  }

  void _simulateImageUpload(ImageSource source) {
    final controller = ImageUploadProgressController(
      context: context,
      onCancel: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload cancelled')),
        );
      },
      onRetry: () {
        _simulateImageUpload(source);
      },
    );

    // Show initial progress
    controller.show(fileName: 'example_image.jpg');

    // Simulate compression phase
    Future.delayed(const Duration(seconds: 2), () {
      if (controller.isShowing) {
        controller.updateUploading(0.0);
      }
    });

    // Simulate upload progress
    _simulateUploadProgress(controller, 0.0);
  }

  void _simulateUploadProgress(ImageUploadProgressController controller, double progress) {
    if (!controller.isShowing) return;

    if (progress >= 1.0) {
      controller.updateCompleted();
      Future.delayed(const Duration(seconds: 1), () {
        if (controller.isShowing) {
          controller.hide();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully!')),
          );
        }
      });
      return;
    }

    controller.updateUploading(progress);
    
    Future.delayed(const Duration(milliseconds: 200), () {
      _simulateUploadProgress(controller, progress + 0.1);
    });
  }

  void _showProgressDialog() {
    ImageUploadProgressDialog.show(
      context: context,
      progress: const ImageUploadProgress(
        state: ImageUploadState.uploading,
        progress: 0.5,
        fileName: 'sample_image.jpg',
      ),
      onCancel: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload cancelled')),
        );
      },
    );
  }
}