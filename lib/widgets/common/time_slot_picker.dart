import 'package:flutter/material.dart';
import '../../utils/time_slot_utils.dart';

/// A dialog widget for picking time slots
class TimeSlotPicker extends StatefulWidget {
  final TimeOfDay? initialTime;
  final String title;
  final List<String>? suggestedTimes;

  const TimeSlotPicker({
    super.key,
    this.initialTime,
    this.title = 'Select Time',
    this.suggestedTimes,
  });

  @override
  State<TimeSlotPicker> createState() => _TimeSlotPickerState();
}

class _TimeSlotPickerState extends State<TimeSlotPicker> {
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current time display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Selected Time',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedTime != null
                        ? TimeSlotUtils.formatTimeSlot(
                            TimeSlotUtils.timeOfDayToTimeSlot(selectedTime!))
                        : 'No time selected',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Time picker button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showTimePicker,
                icon: const Icon(Icons.access_time),
                label: const Text('Pick Custom Time'),
              ),
            ),
            
            // Suggested times (if provided)
            if (widget.suggestedTimes != null && widget.suggestedTimes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Quick Select',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.suggestedTimes!.map((timeSlot) {
                  final isSelected = selectedTime != null &&
                      TimeSlotUtils.timeOfDayToTimeSlot(selectedTime!) == timeSlot;
                  
                  return FilterChip(
                    label: Text(TimeSlotUtils.formatTimeSlot(timeSlot)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedTime = TimeSlotUtils.timeSlotToTimeOfDay(timeSlot);
                        });
                      }
                    },
                  );
                }).toList(),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Clear time option
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    selectedTime = null;
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear Time'),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(selectedTime),
          child: const Text('Set Time'),
        ),
      ],
    );
  }

  Future<void> _showTimePicker() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }
}

/// A simplified time slot picker for inline use
class InlineTimeSlotPicker extends StatelessWidget {
  final String? currentTimeSlot;
  final Function(String?) onTimeSelected;
  final List<String>? suggestedTimes;

  const InlineTimeSlotPicker({
    super.key,
    this.currentTimeSlot,
    required this.onTimeSelected,
    this.suggestedTimes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Time'),
          subtitle: Text(
            currentTimeSlot != null 
                ? TimeSlotUtils.formatTimeSlot(currentTimeSlot!)
                : 'No time set',
          ),
          trailing: const Icon(Icons.edit),
          onTap: () => _showTimeSlotPicker(context),
        ),
        
        if (suggestedTimes != null && suggestedTimes!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Quick Select',
              style: theme.textTheme.labelMedium,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: suggestedTimes!.map((timeSlot) {
                final isSelected = currentTimeSlot == timeSlot;
                
                return FilterChip(
                  label: Text(TimeSlotUtils.formatTimeSlot(timeSlot)),
                  selected: isSelected,
                  onSelected: (selected) {
                    onTimeSelected(selected ? timeSlot : null);
                  },
                );
              }).toList(),
            ),
          ),
        ],
        
        if (currentTimeSlot != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton.icon(
              onPressed: () => onTimeSelected(null),
              icon: const Icon(Icons.clear),
              label: const Text('Remove Time'),
            ),
          ),
      ],
    );
  }

  Future<void> _showTimeSlotPicker(BuildContext context) async {
    final currentTime = currentTimeSlot != null 
        ? TimeSlotUtils.timeSlotToTimeOfDay(currentTimeSlot!)
        : null;
    
    final selectedTime = await showDialog<TimeOfDay>(
      context: context,
      builder: (context) => TimeSlotPicker(
        initialTime: currentTime,
        suggestedTimes: suggestedTimes,
      ),
    );
    
    if (selectedTime != null) {
      final timeSlot = TimeSlotUtils.timeOfDayToTimeSlot(selectedTime);
      onTimeSelected(timeSlot);
    }
  }
}