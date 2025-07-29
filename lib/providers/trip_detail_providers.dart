import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip_detail_providers.g.dart';

/// Provider for timeline view toggle state
@riverpod
class TimelineViewNotifier extends _$TimelineViewNotifier {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }

  void setTimelineView(bool enabled) {
    state = enabled;
  }
}

/// Provider for day collapse/expand state
@riverpod
class DayCollapseNotifier extends _$DayCollapseNotifier {
  @override
  Map<String, bool> build() => {};

  void toggleDay(String dayKey) {
    state = {
      ...state,
      dayKey: !(state[dayKey] ?? false),
    };
  }

  void expandAll(List<String> dayKeys) {
    final newState = <String, bool>{};
    for (final key in dayKeys) {
      newState[key] = false;
    }
    state = newState;
  }

  void collapseAll(List<String> dayKeys) {
    final newState = <String, bool>{};
    for (final key in dayKeys) {
      newState[key] = true;
    }
    state = newState;
  }

  bool isDayCollapsed(String dayKey) {
    return state[dayKey] ?? false;
  }
}