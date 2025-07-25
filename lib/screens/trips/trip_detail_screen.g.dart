// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_detail_screen.dart';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
