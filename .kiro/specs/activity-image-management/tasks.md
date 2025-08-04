# Implementation Plan

- [x] 1. Setup dependencies and project configuration
  - Add required dependencies to pubspec.yaml (firebase_storage, image_picker, flutter_image_compress)
  - Configure Firebase Storage in the project
  - Update build configurations for camera and photo library permissions
  - _Requirements: 1.2, 3.1, 4.1_

- [x] 2. Create core data models for image management
  - [x] 2.1 Create ActivityImage model with Freezed
    - Define ActivityImage class with all required fields (id, url, storagePath, uploadedBy, etc.)
    - Add JSON serialization support
    - Implement helper methods for file size formatting and time display
    - Generate Freezed and JSON serialization files
    - _Requirements: 8.1, 8.2_

  - [x] 2.2 Extend Activity model to include images
    - Add images field as List<ActivityImage> to Activity model
    - Add helper methods for image count and capacity checking
    - Update toFirestoreJson method to handle images serialization
    - Regenerate Freezed files for Activity model
    - _Requirements: 1.1, 2.2_

- [x] 3. Implement image service layer
  - [x] 3.1 Create ImageService interface and implementation
    - Define abstract ImageService interface with methods for picking and compression
    - Implement ImageServiceImpl with image_picker integration
    - Add image compression logic using flutter_image_compress
    - Implement file size validation and thumbnail generation
    - _Requirements: 1.2, 3.1, 3.2_

  - [x] 3.2 Create ImageStorageService for Firebase Storage
    - Define abstract ImageStorageService interface
    - Implement FirebaseImageStorageService with upload, delete, and URL methods
    - Add upload progress tracking functionality
    - Implement error handling for storage operations
    - _Requirements: 4.1, 4.2, 4.4_

- [x] 4. Extend repository layer for image operations
  - [x] 4.1 Add image methods to ActivityRepository interface
    - Add addImageToActivity method signature
    - Add removeImageFromActivity method signature
    - Add reorderActivityImages method signature
    - Add updateImageCaption method signature
    - _Requirements: 1.4, 6.2, 8.3_

  - [x] 4.2 Implement image methods in FirebaseActivityRepository
    - Implement addImageToActivity with Firestore updates
    - Implement removeImageFromActivity with proper cleanup
    - Implement reorderActivityImages with batch updates
    - Implement updateImageCaption with validation
    - Add proper error handling and logging for all image operations
    - _Requirements: 4.4, 6.3, 7.2, 8.4_

- [x] 5. Create image management providers
  - [x] 5.1 Create ActivityImageNotifier provider
    - Implement Riverpod provider for managing activity images
    - Add addImage method with source selection (camera/gallery)
    - Add removeImage method with storage cleanup
    - Add reorderImages method for drag-and-drop support
    - Add updateCaption method for image captions
    - _Requirements: 1.4, 6.3, 8.4_

  - [x] 5.2 Create service providers
    - Create imageServiceProvider for dependency injection
    - Create imageStorageServiceProvider for Firebase Storage
    - Add proper provider configuration and error handling
    - _Requirements: 4.1, 3.1_

- [x] 6. Build image gallery UI components
  - [x] 6.1 Create ActivityImageCard widget
    - Design individual image card with thumbnail display
    - Add loading states and error handling
    - Implement tap-to-fullscreen functionality
    - Add long-press context menu for delete option
    - Show image metadata (uploader, timestamp, file size)
    - _Requirements: 5.1, 5.2, 6.1, 8.2_

  - [x] 6.2 Create ActivityImageGallery widget
    - Implement horizontal scrollable gallery layout
    - Add empty state placeholder when no images
    - Show image count indicator (X of 5 images)
    - Implement drag-and-drop reordering functionality
    - Add "Add Image" button with proper state management
    - _Requirements: 1.1, 2.1, 5.1, 5.3_

  - [x] 6.3 Create FullScreenImageViewer widget
    - Implement full-screen image display with zoom capabilities
    - Add swipe navigation between images
    - Show image details overlay (caption, uploader, timestamp)
    - Add edit caption functionality
    - Implement proper navigation and back button handling
    - _Requirements: 5.2, 5.3, 8.2_

- [x] 7. Create image picker and upload UI
  - [x] 7.1 Create ImagePickerBottomSheet widget
    - Design bottom sheet with camera and gallery options
    - Add proper permission handling and error messages
    - Implement source selection with clear visual indicators
    - Add cancel functionality and proper dismissal
    - _Requirements: 1.2, 1.3_

  - [x] 7.2 Create ImageUploadProgressDialog widget
    - Design progress dialog for compression and upload
    - Show different states (optimizing, uploading with percentage)
    - Add cancel functionality for ongoing uploads
    - Implement proper error display and retry options
    - _Requirements: 3.3, 4.3_

- [x] 8. Integrate image management into existing activity screens
  - [x] 8.1 Update ActivityDetailScreen to include image gallery
    - Add ActivityImageGallery widget to activity detail layout
    - Integrate with existing activity data loading
    - Add proper error handling and loading states
    - Ensure responsive design for different screen sizes
    - _Requirements: 1.1, 5.1, 10.1_

  - [x] 8.2 Update ActivityCard to show image preview
    - Add small image preview to activity cards
    - Show image count indicator when images exist
    - Implement proper loading and error states
    - Maintain existing card layout and functionality
    - _Requirements: 5.1, 10.2_

- [ ] 9. Implement network error handling and image caching
  - [ ] 9.1 Add network-aware error handling
    - Implement network connectivity checks before upload attempts
    - Add clear error messages for offline upload attempts
    - Create manual retry functionality for failed uploads
    - Add refresh functionality to reload images from server
    - _Requirements: 9.1, 9.2, 9.4_

  - [ ] 9.2 Configure cached_network_image for image display
    - Use cached_network_image for all image displays
    - Configure appropriate cache duration and size limits
    - Add loading placeholders and error widgets
    - Implement retry functionality for failed image loads
    - _Requirements: 9.3, 9.5_

- [ ] 10. Add collaborative features and real-time updates
  - [ ] 10.1 Implement real-time image updates
    - Ensure Firestore listeners update image gallery in real-time
    - Add proper handling for concurrent image additions
    - Implement conflict resolution for simultaneous uploads
    - _Requirements: 7.1, 7.4_

  - [ ] 10.2 Add image attribution display
    - Show uploader information on each image
    - Display relative timestamps for image uploads
    - Add user avatars and names in image metadata
    - Group images by contributor when appropriate
    - _Requirements: 8.1, 8.2, 8.3, 8.4_

- [ ] 11. Implement error handling and validation
  - [ ] 11.1 Add comprehensive image validation
    - Validate file types (JPEG, PNG, WebP only)
    - Check file size limits before and after compression
    - Validate image dimensions and quality
    - Add user-friendly error messages for all validation failures
    - _Requirements: 2.3, 3.4_

  - [ ] 11.2 Add network and storage error handling
    - Handle Firebase Storage upload failures with retry logic
    - Add proper error messages for network connectivity issues
    - Implement graceful degradation when storage is unavailable
    - Add error recovery mechanisms for partial uploads
    - _Requirements: 4.5, 9.4_

- [ ] 12. Add performance optimizations
  - [ ] 12.1 Implement image compression and optimization
    - Add automatic compression for images over 3MB
    - Implement progressive image loading for better UX
    - Generate and cache thumbnails for gallery view
    - Add lazy loading for images not currently visible
    - _Requirements: 3.1, 3.2, 10.3, 10.4_

  - [ ] 12.2 Optimize memory usage and caching
    - Configure image cache limits and cleanup policies
    - Implement efficient image disposal when not needed
    - Add memory pressure handling for low-memory devices
    - Optimize image loading and rendering performance
    - _Requirements: 10.1, 10.3_

- [ ] 13. Write comprehensive tests
  - [ ] 13.1 Create unit tests for image services
    - Test image compression functionality with various file sizes
    - Test Firebase Storage upload and download operations
    - Test image validation and error handling
    - Test network error handling and retry logic
    - _Requirements: 3.1, 4.1, 9.1_

  - [ ] 13.2 Create integration tests for image workflows
    - Test complete image upload workflow from picker to storage
    - Test image deletion with proper cleanup
    - Test collaborative image viewing and real-time updates
    - Test network error scenarios and manual retry functionality
    - _Requirements: 1.4, 6.3, 7.1, 9.2_

- [ ] 14. Update Firebase configuration and security rules
  - [ ] 14.1 Configure Firebase Storage security rules
    - Add rules for activity image access control
    - Implement user authentication and authorization checks
    - Add file type and size validation in storage rules
    - Configure proper read/write permissions for collaborators
    - _Requirements: 4.1, 7.3_

  - [ ] 14.2 Update Firestore security rules for image metadata
    - Add rules for activity image array updates
    - Ensure proper validation of image metadata fields
    - Add collaborative access controls for image management
    - _Requirements: 7.2, 8.4_

- [ ] 15. Final integration and testing
  - [ ] 15.1 Integration testing with existing features
    - Test image functionality with activity drag-and-drop
    - Verify image persistence during activity updates
    - Test image display in trip overview and day planning
    - Ensure proper cleanup when activities are deleted
    - _Requirements: 1.5, 6.4_

  - [ ] 15.2 Performance testing and optimization
    - Test app performance with multiple images per activity
    - Verify memory usage stays within acceptable limits
    - Test upload/download speeds with various network conditions
    - Optimize any performance bottlenecks discovered
    - _Requirements: 10.1, 10.3, 10.5_