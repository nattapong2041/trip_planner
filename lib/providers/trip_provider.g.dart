// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Provider for the TripRepository instance
@ProviderFor(tripRepository)
const tripRepositoryProvider = TripRepositoryProvider._();

/// Provider for the TripRepository instance
final class TripRepositoryProvider
    extends $FunctionalProvider<TripRepository, TripRepository, TripRepository>
    with $Provider<TripRepository> {
  /// Provider for the TripRepository instance
  const TripRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'tripRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tripRepositoryHash();

  @$internal
  @override
  $ProviderElement<TripRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TripRepository create(Ref ref) {
    return tripRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TripRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TripRepository>(value),
    );
  }
}

String _$tripRepositoryHash() => r'ba6243a090330636ef6bc301f2ce2eca3344ff3a';

/// Notifier for managing the list of user trips
@ProviderFor(TripListNotifier)
const tripListNotifierProvider = TripListNotifierProvider._();

/// Notifier for managing the list of user trips
final class TripListNotifierProvider
    extends $StreamNotifierProvider<TripListNotifier, List<Trip>> {
  /// Notifier for managing the list of user trips
  const TripListNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'tripListNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tripListNotifierHash();

  @$internal
  @override
  TripListNotifier create() => TripListNotifier();
}

String _$tripListNotifierHash() => r'563ef5bb4178762d1f8b0a9a010f063a8b07838b';

abstract class _$TripListNotifier extends $StreamNotifier<List<Trip>> {
  Stream<List<Trip>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Trip>>, List<Trip>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Trip>>, List<Trip>>,
        AsyncValue<List<Trip>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// Provider for getting a single trip by ID
@ProviderFor(TripDetailNotifier)
const tripDetailNotifierProvider = TripDetailNotifierFamily._();

/// Provider for getting a single trip by ID
final class TripDetailNotifierProvider
    extends $AsyncNotifierProvider<TripDetailNotifier, Trip?> {
  /// Provider for getting a single trip by ID
  const TripDetailNotifierProvider._(
      {required TripDetailNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'tripDetailNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tripDetailNotifierHash();

  @override
  String toString() {
    return r'tripDetailNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TripDetailNotifier create() => TripDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is TripDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tripDetailNotifierHash() =>
    r'f5aba9e21032eaccf3476b13e7dc989f408f2259';

/// Provider for getting a single trip by ID
final class TripDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<TripDetailNotifier, AsyncValue<Trip?>, Trip?,
            FutureOr<Trip?>, String> {
  const TripDetailNotifierFamily._()
      : super(
          retry: null,
          name: r'tripDetailNotifierProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for getting a single trip by ID
  TripDetailNotifierProvider call(
    String tripId,
  ) =>
      TripDetailNotifierProvider._(argument: tripId, from: this);

  @override
  String toString() => r'tripDetailNotifierProvider';
}

abstract class _$TripDetailNotifier extends $AsyncNotifier<Trip?> {
  late final _$args = ref.$arg as String;
  String get tripId => _$args;

  FutureOr<Trip?> build(
    String tripId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<Trip?>, Trip?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Trip?>, Trip?>,
        AsyncValue<Trip?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
