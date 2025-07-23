import 'package:flutter/material.dart';
import '../../models/activity.dart';
import '../../utils/responsive.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
    this.trailing,
  });

  final Activity activity;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 12.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.place,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Responsive.getSpacing(context, baseSpacing: 4.0)),
                        Wrap(
                          spacing: Responsive.getSpacing(context, baseSpacing: 8.0),
                          runSpacing: Responsive.getSpacing(context, baseSpacing: 4.0),
                          children: [
                            _InfoItem(
                              icon: Icons.category,
                              text: activity.activityType,
                            ),
                            if (activity.price != null && activity.price!.isNotEmpty)
                              _InfoItem(
                                icon: Icons.attach_money,
                                text: activity.price!,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (activity.brainstormIdeas.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.getSpacing(context, baseSpacing: 8.0),
                        vertical: Responsive.getSpacing(context, baseSpacing: 4.0),
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: Responsive.getIconSize(context, baseSize: 14),
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          SizedBox(width: Responsive.getSpacing(context, baseSpacing: 4.0)),
                          Text(
                            '${activity.brainstormIdeas.length}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                  ],
                  if (trailing != null) ...[
                    trailing!,
                    SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                  ],
                  if (showActions) ...[
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else if (onTap != null) ...[
                    Icon(
                      Icons.arrow_forward_ios,
                      size: Responsive.getIconSize(context, baseSize: 16),
                    ),
                  ],
                ],
              ),
              if (activity.notes != null && activity.notes!.isNotEmpty) ...[
                SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 8.0)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    activity.notes!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: Responsive.getIconSize(context, baseSize: 14),
          color: Theme.of(context).colorScheme.outline,
        ),
        SizedBox(width: Responsive.getSpacing(context, baseSpacing: 4.0)),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }
}

class ActivityCardCompact extends StatelessWidget {
  const ActivityCardCompact({
    super.key,
    required this.activity,
    this.onTap,
    this.trailing,
  });

  final Activity activity;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 12.0)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.place,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: Responsive.getSpacing(context, baseSpacing: 4.0)),
                    Row(
                      children: [
                        Text(
                          activity.activityType,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        if (activity.price != null && activity.price!.isNotEmpty) ...[
                          SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                          Text(
                            '• ${activity.price}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (activity.brainstormIdeas.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.getSpacing(context, baseSpacing: 8.0),
                    vertical: Responsive.getSpacing(context, baseSpacing: 4.0),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${activity.brainstormIdeas.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
              ],
              if (trailing != null) ...[
                trailing!,
              ] else if (onTap != null) ...[
                Icon(
                  Icons.arrow_forward_ios,
                  size: Responsive.getIconSize(context, baseSize: 16),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}