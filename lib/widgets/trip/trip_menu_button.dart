import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/trip.dart';
import '../../providers/trip_provider.dart';
import '../../utils/responsive.dart';

class TripMenuButton extends ConsumerWidget {
  const TripMenuButton({
    super.key,
    required this.trip,
  });

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenuAction(context, ref, value),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 8),
              Text('Edit Trip'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete Trip', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        _showEditTripDialog(context, ref);
        break;
      case 'delete':
        _showDeleteTripDialog(context, ref);
        break;
    }
  }

  void _showEditTripDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController(text: trip.name);
    final durationController = TextEditingController(text: trip.durationDays.toString());
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.edit),
              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
              const Text('Edit Trip'),
            ],
          ),
          content: SizedBox(
            width: Responsive.getDialogWidth(context),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNameField(nameController, isLoading),
                  SizedBox(height: Responsive.getSpacing(context)),
                  _buildDurationField(durationController, isLoading),
                  if (isLoading) ...[
                    SizedBox(height: Responsive.getSpacing(context)),
                    const LinearProgressIndicator(),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (!formKey.currentState!.validate()) return;

                setState(() => isLoading = true);

                try {
                  final updatedTrip = trip.copyWith(
                    name: nameController.text.trim(),
                    durationDays: int.parse(durationController.text.trim()),
                    updatedAt: DateTime.now(),
                  );

                  await ref.read(tripListNotifierProvider.notifier).updateTrip(updatedTrip);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    _showSuccessSnackBar(context, 'Trip updated successfully!');
                    ref.invalidate(tripDetailNotifierProvider(trip.id));
                  }
                } catch (error) {
                  if (context.mounted) {
                    setState(() => isLoading = false);
                    _showErrorSnackBar(context, 'Failed to update trip: ${error.toString()}');
                  }
                }
              },
              child: _buildSaveButton(context, isLoading),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(TextEditingController controller, bool isLoading) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Trip Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.label),
      ),
      enabled: !isLoading,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a trip name';
        }
        if (value.trim().length < 2) {
          return 'Trip name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildDurationField(TextEditingController controller, bool isLoading) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Duration (days)',
        border: OutlineInputBorder(),
        suffixText: 'days',
        prefixIcon: Icon(Icons.calendar_today),
      ),
      keyboardType: TextInputType.number,
      enabled: !isLoading,
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
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isLoading) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),
        SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
        const Text('Save'),
      ],
    );
  }



  void _showDeleteTripDialog(BuildContext context, WidgetRef ref) {
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
              const Text('Delete Trip'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete "${trip.name}"?'),
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              if (isLoading) ...[
                SizedBox(height: Responsive.getSpacing(context)),
                const LinearProgressIndicator(),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: isLoading ? null : () async {
                setState(() => isLoading = true);

                try {
                  await ref.read(tripListNotifierProvider.notifier).deleteTrip(trip.id);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    context.pop();
                    _showSuccessSnackBar(context, 'Trip deleted successfully');
                  }
                } catch (error) {
                  if (context.mounted) {
                    setState(() => isLoading = false);
                    Navigator.of(context).pop();
                    _showErrorSnackBar(context, 'Failed to delete trip: ${error.toString()}');
                  }
                }
              },
              child: _buildDeleteButton(context, isLoading),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, bool isLoading) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.onError,
                ),
              )
            : const Icon(Icons.delete_forever),
        SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
        const Text('Delete'),
      ],
    );
  }



  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onPrimary),
            SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
            Text(message),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 8.0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onError),
            SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 8.0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}