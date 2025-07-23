import 'package:flutter/material.dart';
import '../../models/activity.dart';
import '../../utils/responsive.dart';
import '../../utils/responsive_gestures.dart';
import 'activity_card.dart';

/// Enhanced draggable activity card with better touch support
class EnhancedDraggableActivityCard extends StatelessWidget {
  const EnhancedDraggableActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
    this.showDragHandle = true,
  });

  final Activity activity;
  final VoidCallback onTap;
  final bool showDragHandle;

  @override
  Widget build(BuildContext context) {
    if (ResponsiveGestures.supportsTouchGestures()) {
      return _TouchDraggableCard(
        activity: activity,
        onTap: onTap,
        showDragHandle: showDragHandle,
      );
    } else {
      return _DesktopDraggableCard(
        activity: activity,
        onTap: onTap,
        showDragHandle: showDragHandle,
      );
    }
  }
}

/// Touch-optimized draggable card for mobile and tablet
class _TouchDraggableCard extends StatelessWidget {
  const _TouchDraggableCard({
    required this.activity,
    required this.onTap,
    required this.showDragHandle,
  });

  final Activity activity;
  final VoidCallback onTap;
  final bool showDragHandle;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Activity>(
      data: activity,
      delay: ResponsiveGestures.getDragDelay(),
      hapticFeedbackOnStart: ResponsiveGestures.shouldUseHapticFeedback(),
      feedback: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: Responsive.getDragFeedbackWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ActivityCard(
            activity: activity,
            showActions: false,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildCardContent(context),
      ),
      child: _buildCardContent(context),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return ResponsiveGestureDetector(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Stack(
          children: [
            ActivityCard(
              activity: activity,
              showActions: false,
            ),
            if (showDragHandle)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 4.0)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.drag_handle,
                    size: Responsive.getDragHandleSize(context),
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Desktop-optimized draggable card
class _DesktopDraggableCard extends StatelessWidget {
  const _DesktopDraggableCard({
    required this.activity,
    required this.onTap,
    required this.showDragHandle,
  });

  final Activity activity;
  final VoidCallback onTap;
  final bool showDragHandle;

  @override
  Widget build(BuildContext context) {
    return Draggable<Activity>(
      data: activity,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: Responsive.getDragFeedbackWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ActivityCard(
            activity: activity,
            showActions: false,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildCardContent(context),
      ),
      child: _buildCardContent(context),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: ResponsiveGestureDetector(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            ActivityCard(
              activity: activity,
              showActions: false,
            ),
            if (showDragHandle)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 4.0)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.drag_handle,
                    size: Responsive.getDragHandleSize(context),
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Enhanced drag target with better visual feedback
class EnhancedDragTarget extends StatelessWidget {
  const EnhancedDragTarget({
    super.key,
    required this.onAccept,
    required this.child,
    this.onWillAccept,
  });

  final void Function(Activity) onAccept;
  final bool Function(Activity?)? onWillAccept;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Activity>(
      onAcceptWithDetails: (details) => onAccept(details.data),
      onWillAcceptWithDetails: (details) => onWillAccept?.call(details.data) ?? true,
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;
        final isRejected = rejectedData.isNotEmpty;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isHighlighted
                ? Border.all(
                    color: isRejected 
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
            color: isHighlighted
                ? (isRejected 
                    ? Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1))
                : null,
          ),
          child: child,
        );
      },
    );
  }
}