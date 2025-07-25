import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/activity.dart';
import '../../models/brainstorm_idea.dart';
import '../../providers/activity_provider.dart';
import '../../providers/auth_provider.dart';
import 'activity_collaborator_info.dart';

/// Widget for displaying and reordering brainstorm ideas with real-time collaboration
class ReorderableBrainstormIdeas extends ConsumerStatefulWidget {
  final Activity activity;
  final bool allowReordering;
  final bool allowEditing;
  
  const ReorderableBrainstormIdeas({
    super.key,
    required this.activity,
    this.allowReordering = true,
    this.allowEditing = true,
  });

  @override
  ConsumerState<ReorderableBrainstormIdeas> createState() => _ReorderableBrainstormIdeasState();
}

class _ReorderableBrainstormIdeasState extends ConsumerState<ReorderableBrainstormIdeas> {
  final _ideaController = TextEditingController();
  bool _isAddingIdea = false;

  @override
  void dispose() {
    _ideaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sort brainstorm ideas by order field for consistent display
    final sortedIdeas = [...widget.activity.brainstormIdeas]
      ..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Icon(Icons.lightbulb),
            const SizedBox(width: 8),
            Text(
              'Brainstorm Ideas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            Text(
              '${sortedIdeas.length} idea${sortedIdeas.length == 1 ? '' : 's'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Add new idea form
        if (widget.allowEditing) ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ideaController,
                  decoration: const InputDecoration(
                    hintText: 'Add a brainstorm idea...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.add),
                  ),
                  enabled: !_isAddingIdea,
                  onSubmitted: (_) => _addIdea(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isAddingIdea ? null : _addIdea,
                child: _isAddingIdea
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        
        // Ideas list
        if (sortedIdeas.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No brainstorm ideas yet',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first idea to get started!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (widget.allowReordering)
          _buildReorderableList(sortedIdeas)
        else
          _buildStaticList(sortedIdeas),
      ],
    );
  }

  Widget _buildReorderableList(List<BrainstormIdea> ideas) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ideas.length,
      onReorder: _reorderIdeas,
      itemBuilder: (context, index) {
        final idea = ideas[index];
        return _buildIdeaItem(idea, index, key: ValueKey(idea.id));
      },
    );
  }

  Widget _buildStaticList(List<BrainstormIdea> ideas) {
    return Column(
      children: ideas.asMap().entries.map((entry) {
        final index = entry.key;
        final idea = entry.value;
        return _buildIdeaItem(idea, index);
      }).toList(),
    );
  }

  Widget _buildIdeaItem(BrainstormIdea idea, int index, {Key? key}) {
    final currentUser = ref.watch(authNotifierProvider).value;
    final canDelete = widget.allowEditing && 
                     (currentUser?.id == idea.createdBy || currentUser?.id == widget.activity.createdBy);

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 8),
      child: BrainstormIdeaWithCreator(
        ideaId: idea.id,
        description: idea.description,
        createdBy: idea.createdBy,
        createdAt: idea.createdAt,
        tripId: widget.activity.tripId,
        onDelete: canDelete ? () => _deleteIdea(idea.id) : null,
      ),
    );
  }

  Future<void> _addIdea() async {
    final description = _ideaController.text.trim();
    if (description.isEmpty) return;

    setState(() {
      _isAddingIdea = true;
    });

    try {
      await ref.read(activityListNotifierProvider(widget.activity.tripId).notifier)
          .addBrainstormIdea(widget.activity.id, description);
      
      _ideaController.clear();
    } catch (error) {
      // Error is handled by the provider
    } finally {
      if (mounted) {
        setState(() {
          _isAddingIdea = false;
        });
      }
    }
  }

  Future<void> _deleteIdea(String ideaId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Idea'),
        content: const Text('Are you sure you want to delete this brainstorm idea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(activityListNotifierProvider(widget.activity.tripId).notifier)
            .removeBrainstormIdea(widget.activity.id, ideaId);
      } catch (error) {
        // Error is handled by the provider
      }
    }
  }

  Future<void> _reorderIdeas(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // Create a copy of the sorted ideas list
    final ideas = [...widget.activity.brainstormIdeas]
      ..sort((a, b) => a.order.compareTo(b.order));
    
    // Reorder the list locally
    final item = ideas.removeAt(oldIndex);
    ideas.insert(newIndex, item);
    
    // Create the new order list with idea IDs
    final reorderedIds = ideas.map((idea) => idea.id).toList();
    
    try {
      await ref.read(activityListNotifierProvider(widget.activity.tripId).notifier)
          .reorderBrainstormIdeas(widget.activity.id, reorderedIds);
    } catch (error) {
      // Error is handled by the provider
    }
  }
}

/// Compact version for displaying in activity cards
class BrainstormIdeasPreview extends ConsumerWidget {
  final Activity activity;
  final int maxIdeasToShow;
  
  const BrainstormIdeasPreview({
    super.key,
    required this.activity,
    this.maxIdeasToShow = 3,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (activity.brainstormIdeas.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort ideas by order and take only the first few
    final sortedIdeas = [...activity.brainstormIdeas]
      ..sort((a, b) => a.order.compareTo(b.order));
    
    final displayIdeas = sortedIdeas.take(maxIdeasToShow).toList();
    final hasMore = sortedIdeas.length > maxIdeasToShow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lightbulb, size: 16),
            const SizedBox(width: 4),
            Text(
              'Ideas (${sortedIdeas.length})',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        ...displayIdeas.map((idea) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  idea.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )),
        
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '... and ${sortedIdeas.length - maxIdeasToShow} more',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}