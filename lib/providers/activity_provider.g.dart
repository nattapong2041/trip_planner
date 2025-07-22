// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Provider for the ActivityRepository instance
@ProviderFor(activityRepository)
const activityRepositoryProvider = ActivityRepositoryProvider._();

/// Provider for the ActivityRepository instance
final class ActivityRepositoryProvider extends $FunctionalProvider<
    ActivityRepository,
    ActivityRepository,
    ActivityRepository> with $Provider<ActivityRepository> {
  /// Provider for the ActivityRepository instance
  const ActivityRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'activityRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activityRepositoryHash();

  @$internal
  @override
  $ProviderElement<ActivityRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ActivityRepository create(Ref ref) {
    return activityRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityRepository>(value),
    );
  }
}

String _$activityRepositoryHash() =>
    r'fa14f3c5ef87fa0bccceb49a81b745ee61b9cc2f';

/// Notifier for managing activities for a specific trip
@ProviderFor(ActivityListNotifier)
const activityListNotifierProvider = ActivityListNotifierFamily._();

/// Notifier for managing activities for a specific trip
final class ActivityListNotifierProvider
    extends $StreamNotifierProvider<ActivityListNotifier, List<Activity>> {
  /// Notifier for managing activities for a specific trip
  const ActivityListNotifierProvider._(
      {required ActivityListNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'activityListNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activityListNotifierHash();

  @override
  String toString() {
    return r'activityListNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActivityListNotifier create() => ActivityListNotifier();

  @override
  bool operator ==(Object other) {
    return other is ActivityListNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityListNotifierHash() =>
    r'5b5ece82b3a5aeb95c97e25a5d180f9ddfb2017b';

/// Notifier for managing activities for a specific trip
final class ActivityListNotifierFamily extends $Family
    with
        $ClassFamilyOverride<ActivityListNotifier, AsyncValue<List<Activity>>,
            List<Activity>, Stream<List<Activity>>, String> {
  const ActivityListNotifierFamily._()
      : super(
          retry: null,
          name: r'activityListNotifierProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Notifier for managing activities for a specific trip
  ActivityListNotifierProvider call(
    String tripId,
  ) =>
      ActivityListNotifierProvider._(argument: tripId, from: this);

  @override
  String toString() => r'activityListNotifierProvider';
}

abstract class _$ActivityListNotifier extends $StreamNotifier<List<Activity>> {
  late final _$args = ref.$arg as String;
  String get tripId => _$args;

  Stream<List<Activity>> build(
    String tripId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<List<Activity>>, List<Activity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Activity>>, List<Activity>>,
        AsyncValue<List<Activity>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// Provider for getting a single activity by ID
@ProviderFor(ActivityDetailNotifier)
const activityDetailNotifierProvider = ActivityDetailNotifierFamily._();

/// Provider for getting a single activity by ID
final class ActivityDetailNotifierProvider
    extends $AsyncNotifierProvider<ActivityDetailNotifier, Activity?> {
  /// Provider for getting a single activity by ID
  const ActivityDetailNotifierProvider._(
      {required ActivityDetailNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'activityDetailNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activityDetailNotifierHash();

  @override
  String toString() {
    return r'activityDetailNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActivityDetailNotifier create() => ActivityDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is ActivityDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityDetailNotifierHash() =>
    r'dccec235726fe973e88affe82569688d628f0144';

/// Provider for getting a single activity by ID
final class ActivityDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<ActivityDetailNotifier, AsyncValue<Activity?>,
            Activity?, FutureOr<Activity?>, String> {
  const ActivityDetailNotifierFamily._()
      : super(
          retry: null,
          name: r'activityDetailNotifierProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for getting a single activity by ID
  ActivityDetailNotifierProvider call(
    String activityId,
  ) =>
      ActivityDetailNotifierProvider._(argument: activityId, from: this);

  @override
  String toString() => r'activityDetailNotifierProvider';
}

abstract class _$ActivityDetailNotifier extends $AsyncNotifier<Activity?> {
  late final _$args = ref.$arg as String;
  String get activityId => _$args;

  FutureOr<Activity?> build(
    String activityId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<Activity?>, Activity?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Activity?>, Activity?>,
        AsyncValue<Activity?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// Provider for getting activities grouped by assignment status
@ProviderFor(ActivityGroupsNotifier)
const activityGroupsNotifierProvider = ActivityGroupsNotifierFamily._();

/// Provider for getting activities grouped by assignment status
final class ActivityGroupsNotifierProvider
    extends $AsyncNotifierProvider<ActivityGroupsNotifier, ActivityGroups> {
  /// Provider for getting activities grouped by assignment status
  const ActivityGroupsNotifierProvider._(
      {required ActivityGroupsNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'activityGroupsNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activityGroupsNotifierHash();

  @override
  String toString() {
    return r'activityGroupsNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActivityGroupsNotifier create() => ActivityGroupsNotifier();

  @override
  bool operator ==(Object other) {
    return other is ActivityGroupsNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityGroupsNotifierHash() =>
    r'63a2fbd34f6721698dc4982ece311aa55b709313';

/// Provider for getting activities grouped by assignment status
final class ActivityGroupsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<ActivityGroupsNotifier, AsyncValue<ActivityGroups>,
            ActivityGroups, FutureOr<ActivityGroups>, String> {
  const ActivityGroupsNotifierFamily._()
      : super(
          retry: null,
          name: r'activityGroupsNotifierProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for getting activities grouped by assignment status
  ActivityGroupsNotifierProvider call(
    String tripId,
  ) =>
      ActivityGroupsNotifierProvider._(argument: tripId, from: this);

  @override
  String toString() => r'activityGroupsNotifierProvider';
}

abstract class _$ActivityGroupsNotifier extends $AsyncNotifier<ActivityGroups> {
  late final _$args = ref.$arg as String;
  String get tripId => _$args;

  FutureOr<ActivityGroups> build(
    String tripId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<ActivityGroups>, ActivityGroups>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ActivityGroups>, ActivityGroups>,
        AsyncValue<ActivityGroups>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
