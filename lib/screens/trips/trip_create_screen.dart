import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/trip_provider.dart';
import '../../utils/responsive.dart';

class TripCreateScreen extends ConsumerStatefulWidget {
  const TripCreateScreen({super.key});

  @override
  ConsumerState<TripCreateScreen> createState() => _TripCreateScreenState();
}

class _TripCreateScreenState extends ConsumerState<TripCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Trip'),
        actions: [
          if (Responsive.isLargeScreen(context))
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _saveTrip,
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
              label: const Text('Save Trip'),
            )
          else
            TextButton(
              onPressed: _isLoading ? null : _saveTrip,
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
                  Icons.add_location_alt,
                  size: Responsive.getIconSize(context, baseSize: 48),
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: Responsive.getSpacing(context)),
                Text(
                  'Create New Trip',
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
                      Icons.add_location_alt,
                      size: Responsive.getIconSize(context, baseSize: 80),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
                    Text(
                      'Create Your Trip',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Responsive.getSpacing(context)),
                    Text(
                      'Start planning your next adventure',
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
                      'Trip Details',
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
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Trip Name',
            hintText: 'Enter trip name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.label),
          ),
          textInputAction: TextInputAction.next,
          enabled: !_isLoading,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a trip name';
            }
            if (value.trim().length < 2) {
              return 'Trip name must be at least 2 characters';
            }
            return null;
          },
        ),
        SizedBox(height: Responsive.getSpacing(context)),
        TextFormField(
          controller: _durationController,
          decoration: const InputDecoration(
            labelText: 'Duration (days)',
            hintText: 'Enter number of days',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_today),
            suffixText: 'days',
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          enabled: !_isLoading,
          onFieldSubmitted: (_) => _saveTrip(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter trip duration';
            }
            final duration = int.tryParse(value);
            if (duration == null || duration <= 0) {
              return 'Please enter a valid number of days';
            }
            if (duration > 365) {
              return 'Trip duration cannot exceed 365 days';
            }
            return null;
          },
        ),
        SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
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
                    size: Responsive.getIconSize(context, baseSize: 20),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                  Text(
                    'Trip Structure',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Text(
                'Your trip will be organized into daily sections (Day 1, Day 2, etc.) where you can add and organize activities.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final duration = int.parse(_durationController.text.trim());

      await ref.read(tripListNotifierProvider.notifier).createTrip(
        name: name,
        durationDays: duration,
      );

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Trip "$name" created successfully!'),
                ),
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
        
        // Navigate back to trip list
        context.pop();
      }
    } catch (error) {
      if (mounted) {
        // Show error message
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
                  child: Text('Failed to create trip: ${error.toString()}'),
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}