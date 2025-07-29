import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/trip.dart';
import '../../providers/auth_provider.dart';
import '../../utils/responsive.dart';
import '../../utils/trip_detail_utils.dart';
import 'collaborator_management_widget.dart';

class TripInfoHeader extends ConsumerWidget {
  const TripInfoHeader({
    super.key,
    required this.trip,
  });

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authNotifierProvider).value;
    final isOwner = currentUser?.id == trip.ownerId;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.getSpacing(context)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Theme.of(context).colorScheme.primary,
                size: Responsive.getIconSize(context, baseSize: 20),
              ),
              SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Text(
                '${trip.durationDays} ${trip.durationDays == 1 ? 'day' : 'days'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              _buildCollaboratorsInfo(context, isOwner),
            ],
          ),
          SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
          Text(
            'Created ${TripDetailUtils.formatDate(trip.createdAt)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollaboratorsInfo(BuildContext context, bool isOwner) {
    return GestureDetector(
      onTap: () => _showCollaboratorManagement(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.group,
            color: Theme.of(context).colorScheme.primary,
            size: Responsive.getIconSize(context, baseSize: 20),
          ),
          SizedBox(width: Responsive.getSpacing(context, baseSpacing: 4.0)),
          Text(
            '${trip.collaboratorIds.length + 1}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (isOwner) ...[
            SizedBox(width: Responsive.getSpacing(context, baseSpacing: 4.0)),
            Icon(
              Icons.settings,
              size: Responsive.getIconSize(context, baseSize: 16),
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
        ],
      ),
    );
  }

  void _showCollaboratorManagement(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: Responsive.getDialogWidth(context),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: CollaboratorManagementWidget(
            tripId: trip.id,
            ownerId: trip.ownerId,
            trip: trip,
          ),
        ),
      ),
    );
  }
}