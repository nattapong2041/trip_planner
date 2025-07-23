import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/activity_provider.dart';
import '../../utils/responsive.dart';
import '../../utils/responsive_gestures.dart';
import '../../widgets/common/responsive_error_display.dart';

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
          if (Responsive.isLargeScreen(context))
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _saveActivity,
              icon: _isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.save),
              label: const Text('Save Activity'),
            )
          else
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
      body: ResponsiveContainer(
        child: ResponsiveBuilder(
          mobile: _buildMobileLayout(context),
          tablet: _buildTabletLayout(context),
          desktop: _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(Responsive.getSpacing(context)),
        children: [
          _buildFormFields(context),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(Responsive.getSpacing(context)),
        child: Container(
          width: Responsive.getDialogWidth(context),
          padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 24.0)),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_location,
                  size: Responsive.getIconSize(context, baseSize: 48),
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: Responsive.getSpacing(context)),
                Text(
                  'Add New Activity',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
                _buildFormFields(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left side - Hero section
        Expanded(
          flex: 2,
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 48.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_location,
                      size: Responsive.getIconSize(context, baseSize: 80),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
                    Text(
                      'Add Activity',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Responsive.getSpacing(context)),
                    Text(
                      'Create a new activity for your trip',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Right side - Form
        Expanded(
          flex: 3,
          child: Center(
            child: Container(
              width: 500,
              padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 48.0)),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Activity Details',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Responsive.getSpacing(context, baseSpacing: 32.0)),
                    _buildFormFields(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(height: Responsive.getSpacing(context)),
        
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
        SizedBox(height: Responsive.getSpacing(context)),
        
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
        SizedBox(height: Responsive.getSpacing(context)),
        
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
        SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
        
        // Info card
        Container(
          padding: EdgeInsets.all(Responsive.getSpacing(context)),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: Responsive.getIconSize(context, baseSize: 20),
                  ),
                  SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                  Text(
                    'Activity Pool',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Text(
                'New activities are added to the activity pool. You can assign them to specific days later from the trip details page.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
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