import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/trip_detail_providers.dart';

class TimelineToggleButton extends ConsumerWidget {
  const TimelineToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTimelineView = ref.watch(timelineViewNotifierProvider);

    return IconButton(
      onPressed: () {
        ref.read(timelineViewNotifierProvider.notifier).toggle();
      },
      icon: Icon(
        isTimelineView ? Icons.view_list : Icons.schedule,
      ),
      tooltip: isTimelineView ? 'Switch to List View' : 'Switch to Timeline View',
    );
  }
}