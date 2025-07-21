import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/activity_provider.dart';

class ActivityCreateScreen extends ConsumerStatefulWidget {
  const ActivityCreateScreen({
    super.key,
    required this.tripId,
  });

  final String tripId;

  @override
  ConsumerState<ActivityCreateScreen> createState() => _ActivityCreateScreenState();
}

class _ActivityCreateScreenState extends ConsumerState<ActivityCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placeController = TextEditingController();
  final _activityTypeController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  
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
        title: const Text('Add Activity'),
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
            
            // Info card
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
                          Icons.info_outline,
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
                      'New activities are added to the activity pool. You can assign them to specific days later from the trip details page.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
      await ref.read(activityListNotifierProvider(widget.tripId).notifier).createActivity(
        tripId: widget.tripId,
        place: _placeController.text.trim(),
        activityType: _activityTypeController.text.trim(),
        price: _priceController.text.trim().isEmpty ? null : _priceController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

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
                const Text('Activity added successfully!'),
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
                  child: Text('Failed to add activity: ${error.toString()}'),
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