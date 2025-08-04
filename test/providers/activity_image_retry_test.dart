import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../lib/providers/activity_image_provider.dart';
import '../../lib/services/image_service.dart';
import '../../lib/services/image_storage_service.dart';
import '../../lib/repositories/activity_repository.dart';
import '../../lib/models/user.dart';
import '../../lib/models/activity_image.dart';
import '../../lib/models/activity.dart';

// Generate mocks
@GenerateMocks([
  ImageService,
  ImageStorageService,
  ActivityRepository,
  PlatformFile,
])
void main() {
  group('ActivityImageNotifier Retry Tests', () {
    late ProviderContainer container;
    late MockImageService mockImageService;
    late MockImageStorageService mockStorageService;
    late MockActivityRepository mockActivityRepository;
    late MockPlatformFile mockImageFile;

    setUp(() {
      mockImageService = MockImageService();
      mockStorageService = MockImageStorageService();
      mockActivityRepository = MockActivityRepository();
      mockImageFile = MockPlatformFile();

      container = ProviderContainer(
        overrides: [
          imageServiceProvider.overrideWithValue(mockImageService),
          imageStorageServiceProvider.overrideWithValue(mockStorageService),
          activityRepositoryProvider.overrideWithValue(mockActivityRepository),
          // Mock auth provider to return a user
          authNotifierProvider.overrideWith((ref) => 
            AsyncValue.data(User(
              id: 'test-user',
              email: 'test@example.com',
              displayName: 'Test User',
              createdAt: DateTime.now(),
            ))
          ),
          // Mock other required providers
          loadingNotifierProvider.overrideWith((ref) => MockLoadingNotifier()),
          successNotifierProvider.overrideWith((ref) => MockSuccessNotifier()),
          errorNotifierProvider.overrideWith((ref) => MockErrorNotifier()),
        ],
      );

      // Setup common mock behaviors
      when(mockImageFile.name).thenReturn('test.jpg');
      when(mockImageFile.length()).thenAnswer((_) async => 1024 * 1024); // 1MB
      when(mockImageService.getFileSize(any)).thenAnswer((_) async => 1024 * 1024);
      when(mockImageService.compressImage(any)).thenAnswer((_) async => mockImageFile);
    });

    tearDown(() {
      container.dispose();
    });

    test('should retry upload on failure and succeed on second attempt', () async {
      // Setup mocks
      when(mockImageService.pickFromGallery()).thenAnswer((_) async => mockImageFile);
      
      // First upload attempt fails, second succeeds
      when(mockStorageService.uploadImage(any, any, onProgress: anyNamed('onProgress')))
          .thenThrow(Exception('Network error'))
          .thenAnswer((_) async => 'https://example.com/image.jpg');

      when(mockActivityRepository.addImageToActivity(any, any))
          .thenAnswer((_) async => Activity(
            id: 'test-activity',
            tripId: 'test-trip',
            place: 'Test Place',
            activityType: 'Test Type',
            createdBy: 'test-user',
            createdAt: DateTime.now(),
            images: [
              ActivityImage(
                id: 'test-image',
                url: 'https://example.com/image.jpg',
                storagePath: 'test/path',
                uploadedBy: 'test-user',
                uploadedAt: DateTime.now(),
                originalFileName: 'test.jpg',
                fileSizeBytes: 1024 * 1024,
              ),
            ],
          ));

      // Execute
      final notifier = container.read(activityImageNotifierProvider('test-activity').notifier);
      
      // Should not throw exception (retry should succeed)
      await expectLater(
        notifier.addImage(ImageSource.gallery),
        completes,
      );

      // Verify upload was called twice (first failed, second succeeded)
      verify(mockStorageService.uploadImage(any, any, onProgress: anyNamed('onProgress')))
          .called(2);
      
      // Verify activity was updated once (after successful upload)
      verify(mockActivityRepository.addImageToActivity(any, any)).called(1);
    });

    test('should fail after max retries', () async {
      // Setup mocks
      when(mockImageService.pickFromGallery()).thenAnswer((_) async => mockImageFile);
      
      // All upload attempts fail
      when(mockStorageService.uploadImage(any, any, onProgress: anyNamed('onProgress')))
          .thenThrow(Exception('Persistent network error'));

      // Execute
      final notifier = container.read(activityImageNotifierProvider('test-activity').notifier);
      
      // Should throw exception after max retries
      await expectLater(
        notifier.addImage(ImageSource.gallery),
        throwsException,
      );

      // Verify upload was called 4 times (initial + 3 retries)
      verify(mockStorageService.uploadImage(any, any, onProgress: anyNamed('onProgress')))
          .called(4);
      
      // Verify activity was never updated (all uploads failed)
      verifyNever(mockActivityRepository.addImageToActivity(any, any));
    });

    test('should use exponential backoff between retries', () async {
      // This test verifies the retry delay logic
      final stopwatch = Stopwatch()..start();
      
      // Setup mocks
      when(mockImageService.pickFromGallery()).thenAnswer((_) async => mockImageFile);
      when(mockStorageService.uploadImage(any, any, onProgress: anyNamed('onProgress')))
          .thenThrow(Exception('Network error'));

      // Execute
      final notifier = container.read(activityImageNotifierProvider('test-activity').notifier);
      
      try {
        await notifier.addImage(ImageSource.gallery);
      } catch (e) {
        // Expected to fail
      }

      stopwatch.stop();
      
      // Should take at least 2 + 4 + 6 = 12 seconds for the delays
      // (allowing some tolerance for test execution time)
      expect(stopwatch.elapsedMilliseconds, greaterThan(10000));
    });
  });
}

// Mock classes for providers that don't have generated mocks
class MockLoadingNotifier extends StateNotifier<bool> {
  MockLoadingNotifier() : super(false);
  
  void showLoading([String? message]) => state = true;
  void hideLoading() => state = false;
}

class MockSuccessNotifier extends StateNotifier<String?> {
  MockSuccessNotifier() : super(null);
  
  void showSuccessWithAutoClear(String message) => state = message;
}

class MockErrorNotifier extends StateNotifier<String?> {
  MockErrorNotifier() : super(null);
  
  void showError(dynamic error) => state = error.toString();
}