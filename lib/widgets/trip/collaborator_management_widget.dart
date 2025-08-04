import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/user.dart';
import '../../models/trip.dart';
import '../../providers/trip_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/invitation_service.dart';

/// Widget for managing trip collaborators
class CollaboratorManagementWidget extends ConsumerStatefulWidget {
  final String tripId;
  final String ownerId;
  final Trip? trip; // Optional trip data for invitation messages
  
  const CollaboratorManagementWidget({
    super.key,
    required this.tripId,
    required this.ownerId,
    this.trip,
  });

  @override
  ConsumerState<CollaboratorManagementWidget> createState() => _CollaboratorManagementWidgetState();
}

class _CollaboratorManagementWidgetState extends ConsumerState<CollaboratorManagementWidget> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isAddingCollaborator = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collaboratorsAsync = ref.watch(tripCollaboratorsNotifierProvider(widget.tripId));
    final currentUser = ref.watch(authNotifierProvider).value;
    final isOwner = currentUser?.id == widget.ownerId;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.people),
                const SizedBox(width: 8),
                Text(
                  'Collaborators',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Add collaborator form (only for owner)
            if (isOwner) ...[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email address',
                              hintText: 'Enter collaborator email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email address';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            enabled: !_isAddingCollaborator,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isAddingCollaborator ? null : _addCollaborator,
                          child: _isAddingCollaborator
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Add'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Note: Users must sign up for the app before they can be added as collaborators.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
            ],
            
            // Collaborators list
            collaboratorsAsync.when(
              data: (collaborators) => _buildCollaboratorsList(collaborators, isOwner, currentUser),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(height: 8),
                    Text('Error loading collaborators: $error'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.refresh(tripCollaboratorsNotifierProvider(widget.tripId)),
                      child: const Text('Retry'),
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

  Widget _buildCollaboratorsList(List<User> collaborators, bool isOwner, User? currentUser) {
    if (collaborators.isEmpty) {
      return const Center(
        child: Text('No collaborators yet'),
      );
    }

    return Column(
      children: collaborators.map((user) {
        final isCurrentUser = user.id == currentUser?.id;
        final isOwnerUser = user.id == widget.ownerId;
        
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: user.photoUrl != null 
                ? CachedNetworkImageProvider(user.photoUrl!) 
                : null,
            child: user.photoUrl == null ? Text(user.displayName[0].toUpperCase()) : null,
          ),
          title: Text(user.displayName),
          subtitle: Text(user.email),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isOwnerUser)
                const Chip(
                  label: Text('Owner'),
                  backgroundColor: Colors.blue,
                  labelStyle: TextStyle(color: Colors.white),
                )
              else if (isCurrentUser)
                const Chip(
                  label: Text('You'),
                  backgroundColor: Colors.green,
                  labelStyle: TextStyle(color: Colors.white),
                )
              else
                const Chip(
                  label: Text('Collaborator'),
                  backgroundColor: Colors.grey,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              
              // Remove button (only for owner, and not for themselves)
              if (isOwner && !isOwnerUser && !isCurrentUser)
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => _removeCollaborator(user),
                  tooltip: 'Remove collaborator',
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _addCollaborator() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isAddingCollaborator = true;
    });

    try {
      await ref.read(tripListNotifierProvider.notifier).addCollaborator(
        widget.tripId,
        _emailController.text.trim(),
      );
      
      _emailController.clear();
      
      // Refresh collaborators list
      ref.invalidate(tripCollaboratorsNotifierProvider(widget.tripId));
    } catch (error) {
      // Show additional help if user not found
      if (error.toString().contains('need to sign up')) {
        _showUserNotFoundDialog(_emailController.text.trim());
      }
      // Error is also handled by the provider for global display
    } finally {
      if (mounted) {
        setState(() {
          _isAddingCollaborator = false;
        });
      }
    }
  }

  void _showUserNotFoundDialog(String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person_search, color: Colors.orange),
            SizedBox(width: 8),
            Text('User Not Found'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('The user with email "$email" hasn\'t signed up for the app yet.'),
            const SizedBox(height: 16),
            const Text('To add them as a collaborator:'),
            const SizedBox(height: 8),
            const Text('1. Ask them to download and sign up for the app'),
            const Text('2. Once they\'ve signed up, try adding them again'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline, size: 16, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tip: You can share the app with them so they can sign up!',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (widget.trip != null) ...[
            TextButton(
              onPressed: () => _copyInvitationMessage(email),
              child: const Text('Copy Invitation'),
            ),
          ],
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _copyInvitationMessage(String email) async {
    final currentUser = ref.read(authNotifierProvider).value;
    if (currentUser == null || widget.trip == null) return;

    try {
      await InvitationService.copyInvitationToClipboard(
        tripName: widget.trip!.name,
        inviterName: currentUser.displayName,
      );
      
      if (mounted) {
        Navigator.of(context).pop(); // Close the dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Invitation message copied! You can now share it with your friend.'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to copy invitation: $error'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _removeCollaborator(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Collaborator'),
        content: Text('Are you sure you want to remove ${user.displayName} from this trip?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(tripListNotifierProvider.notifier).removeCollaborator(
          widget.tripId,
          user.id,
        );
        
        // Refresh collaborators list
        ref.invalidate(tripCollaboratorsNotifierProvider(widget.tripId));
      } catch (error) {
        // Error is handled by the provider
      }
    }
  }
}