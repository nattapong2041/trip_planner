// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Provider for the ImageService instance
@ProviderFor(imageService)
const imageServiceProvider = ImageServiceProvider._();

/// Provider for the ImageService instance
final class ImageServiceProvider
    extends $FunctionalProvider<ImageService, ImageService, ImageService>
    with $Provider<ImageService> {
  /// Provider for the ImageService instance
  const ImageServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'imageServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$imageServiceHash();

  @$internal
  @override
  $ProviderElement<ImageService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageService create(Ref ref) {
    return imageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageService>(value),
    );
  }
}

String _$imageServiceHash() => r'e785a12d1ba331875be0d1b617adf615ddc0d2ef';

/// Provider for the ImageStorageService instance
@ProviderFor(imageStorageService)
const imageStorageServiceProvider = ImageStorageServiceProvider._();

/// Provider for the ImageStorageService instance
final class ImageStorageServiceProvider extends $FunctionalProvider<
    ImageStorageService,
    ImageStorageService,
    ImageStorageService> with $Provider<ImageStorageService> {
  /// Provider for the ImageStorageService instance
  const ImageStorageServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'imageStorageServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$imageStorageServiceHash();

  @$internal
  @override
  $ProviderElement<ImageStorageService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageStorageService create(Ref ref) {
    return imageStorageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageStorageService>(value),
    );
  }
}

String _$imageStorageServiceHash() =>
    r'23c2f370ad251ebe71aa4304d1e546e7a1b73071';

/// Notifier for managing activity images
@ProviderFor(ActivityImageNotifier)
const activityImageNotifierProvider = ActivityImageNotifierFamily._();

/// Notifier for managing activity images
final class ActivityImageNotifierProvider extends $NotifierProvider<
    ActivityImageNotifier, AsyncValue<List<ActivityImage>>> {
  /// Notifier for managing activity images
  const ActivityImageNotifierProvider._(
      {required ActivityImageNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'activityImageNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activityImageNotifierHash();

  @override
  String toString() {
    return r'activityImageNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActivityImageNotifier create() => ActivityImageNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<ActivityImage>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<ActivityImage>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityImageNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityImageNotifierHash() =>
    r'19a4db75c16a5b64860df64b353ad1b166735b78';

/// Notifier for managing activity images
final class ActivityImageNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
            ActivityImageNotifier,
            AsyncValue<List<ActivityImage>>,
            AsyncValue<List<ActivityImage>>,
            AsyncValue<List<ActivityImage>>,
            String> {
  const ActivityImageNotifierFamily._()
      : super(
          retry: null,
          name: r'activityImageNotifierProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Notifier for managing activity images
  ActivityImageNotifierProvider call(
    String activityId,
  ) =>
      ActivityImageNotifierProvider._(argument: activityId, from: this);

  @override
  String toString() => r'activityImageNotifierProvider';
}

abstract class _$ActivityImageNotifier
    extends $Notifier<AsyncValue<List<ActivityImage>>> {
  late final _$args = ref.$arg as String;
  String get activityId => _$args;

  AsyncValue<List<ActivityImage>> build(
    String activityId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<List<ActivityImage>>,
        AsyncValue<List<ActivityImage>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<ActivityImage>>,
            AsyncValue<List<ActivityImage>>>,
        AsyncValue<List<ActivityImage>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
