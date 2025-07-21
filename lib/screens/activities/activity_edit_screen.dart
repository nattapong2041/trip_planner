import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/activity.dart';
import '../../providers/activity_provider.dart';

class ActivityEditScreen extends ConsumerStatefulWidget {
  const ActivityEditScreen({
    super.key,
    required this.tripId,
    required this.activity,
  });

  final String tripId;
  final Activity activity;

  @override
  ConsumerState<ActivityEditScreen> createState() => _ActivityEditScreenState();
}

class _ActivityEditScreenState extends ConsumerState<ActivityEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _placeController;
  late final TextEditingController _activityTypeController;
  late final TextEditingController _priceController;
  late final TextEditingController _notesController;
  
  bool _isLoading = false;

  // Common activity types for suggestions
  final List<String> _activityTypes = [
    'Restaurant',
    'Museum',
    'Park',
    'Shopping',
    'Entertainment',
    'Sightseeing',
    'Adventure',
    'Beach',
    'Nightlife',
    'Cultural',
    'Sports',
    'Nature',
    'Transportation',
    'Accommodation',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _placeController = TextEditingController(text: widget.activity.place);
    _activityTypeController = TextEditingController(text: widget.activity.activityType);
    _priceController = TextEditingController(text: widget.activity.price ?? '');
    _notesController = TextEditingController(text: widget.activity.notes ?? '');
  }

  @override
  void dispose() {
    _placeController.dispose();
    _activityTypeController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Activity'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveActivity,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Place field
            TextFormField(
              controller: _placeController,
              decoration: const InputDecoration(
                labelText: 'Place *',
                hintText: 'e.g., Central Park, Eiffel Tower',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.place),
              ),
              textInputAction: TextInputAction.next,
              enabled: !_isLoading,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a place name';
                }
                if (value.trim().length < 2) {
                  return 'Place name must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Activity Type field with dropdown suggestions
            TextFormField(
              controller: _activityTypeController,
              decoration: InputDecoration(
                labelText: 'Activity Type *',
                hintText: 'e.g., Restaurant, Museum, Park',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.category),
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (String value) {
                    _activityTypeController.text = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return _activityTypes.map((String type) {
                      return PopupMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList();
                  },
                ),
              ),
              textInputAction: TextInputAction.next,
              enabled: !_isLoading,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an activity type';
                }
                if (value.trim().length < 2) {
                  return 'Activity type must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Price field (optional)
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price (optional)',
                hintText: 'e.g., \$25, Free, €15-20',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              textInputAction: TextInputAction.next,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            
            // Notes field (optional)
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Additional details, opening hours, etc.',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
              enabled: !_isLoading,
              onFieldSubmitted: (_) => _saveActivity(),
            ),
            const SizedBox(height: 24),
            
            // Assignment status info
            if (widget.activity.assignedDay != null) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Assignment Status',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This activity is assigned to ${widget.activity.assignedDay!.replaceAll('-', ' ').toUpperCase()}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Activity Pool',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This activity is in the activity pool and not assigned to any specific day.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedActivity = widget.activity.copyWith(
        place: _placeController.text.trim(),
        activityType: _activityTypeController.text.trim(),
        price: _priceController.text.trim().isEmpty ? null : _priceController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      await ref.read(activityListNotifierProvider(widget.tripId).notifier).updateActivity(updatedActivity);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(width: 8),
                const Text('Activity updated successfully!'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.onError,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Failed to update activity: ${error.toString()}'),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}