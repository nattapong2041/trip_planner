import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/activity.dart';
import '../../models/user.dart';
import '../../providers/trip_provider.dart';

/// Widget that displays collaborator information for an activity
class ActivityCollaboratorInfo extends ConsumerWidget {
  final Activity activity;
  
  const ActivityCollaboratorInfo({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collaboratorsAsync = ref.watch(tripCollaboratorsNotifierProvider(activity.tripId));
    
    return collaboratorsAsync.when(
      data: (collaborators) => _buildCollaboratorInfo(context, collaborators),
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildCollaboratorInfo(BuildContext context, List<User> collaborators) {
    // Find the creator of the activity
    final creator = collaborators.firstWhere(
      (user) => user.id == activity.createdBy,
      orElse: () => User(
        id: activity.createdBy,
        email: 'unknown@example.com',
        displayName: 'Unknown User',
      ),
    );

    // Get unique contributors from brainstorm ideas
    final contributorIds = activity.brainstormIdeas
        .map((idea) => idea.createdBy)
        .toSet()
        .toList();
    
    final contributors = collaborators
        .where((user) => contributorIds.contains(user.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Activity creator
        Row(
          children: [
            const Icon(Icons.person, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              'Created by ${creator.displayName}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        
        // Brainstorm contributors (if any)
        if (contributors.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.lightbulb, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Ideas from: ${contributors.map((u) => u.displayName).join(', ')}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        
        // Brainstorm idea count
        if (activity.brainstormIdeas.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.comment, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${activity.brainstormIdeas.length} idea${activity.brainstormIdeas.length == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Widget that displays brainstorm idea with creator information
class BrainstormIdeaWithCreator extends ConsumerWidget {
  final String ideaId;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final String tripId;
  final VoidCallback? onDelete;
  
  const BrainstormIdeaWithCreator({
    super.key,
    required this.ideaId,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.tripId,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collaboratorsAsync = ref.watch(tripCollaboratorsNotifierProvider(tripId));
    
    return collaboratorsAsync.when(
      data: (collaborators) => _buildIdeaWithCreator(context, collaborators),
      loading: () => _buildIdeaWithCreator(context, []),
      error: (error, stack) => _buildIdeaWithCreator(context, []),
    );
  }

  Widget _buildIdeaWithCreator(BuildContext context, List<User> collaborators) {
    // Find the creator of the idea
    final creator = collaborators.firstWhere(
      (user) => user.id == createdBy,
      orElse: () => User(
        id: createdBy,
        email: 'unknown@example.com',
        displayName: 'Unknown User',
      ),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Idea description
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            
            // Creator and timestamp info
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: creator.photoUrl != null 
                      ? CachedNetworkImageProvider(creator.photoUrl!) 
                      : null,
                  child: creator.photoUrl == null 
                      ? Text(
                          creator.displayName[0].toUpperCase(),
                          style: const TextStyle(fontSize: 10),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        creator.displayName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatTimestamp(createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Delete button (if provided)
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, size: 18),
                    onPressed: onDelete,
                    tooltip: 'Delete idea',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}