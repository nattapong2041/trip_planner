// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Provider for timeline view toggle state
@ProviderFor(TimelineViewNotifier)
const timelineViewNotifierProvider = TimelineViewNotifierProvider._();

/// Provider for timeline view toggle state
final class TimelineViewNotifierProvider
    extends $NotifierProvider<TimelineViewNotifier, bool> {
  /// Provider for timeline view toggle state
  const TimelineViewNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'timelineViewNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$timelineViewNotifierHash();

  @$internal
  @override
  TimelineViewNotifier create() => TimelineViewNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$timelineViewNotifierHash() =>
    r'f761bd4aa4d4baf19cbe7440c6efcc8596106aee';

abstract class _$TimelineViewNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// Provider for day collapse/expand state
@ProviderFor(DayCollapseNotifier)
const dayCollapseNotifierProvider = DayCollapseNotifierProvider._();

/// Provider for day collapse/expand state
final class DayCollapseNotifierProvider
    extends $NotifierProvider<DayCollapseNotifier, Map<String, bool>> {
  /// Provider for day collapse/expand state
  const DayCollapseNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dayCollapseNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dayCollapseNotifierHash();

  @$internal
  @override
  DayCollapseNotifier create() => DayCollapseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, bool>>(value),
    );
  }
}

String _$dayCollapseNotifierHash() =>
    r'bfb2cfe2b7fff2c860ddd194ebd547f6dde72f4a';

abstract class _$DayCollapseNotifier extends $Notifier<Map<String, bool>> {
  Map<String, bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<String, bool>, Map<String, bool>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Map<String, bool>, Map<String, bool>>,
        Map<String, bool>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
