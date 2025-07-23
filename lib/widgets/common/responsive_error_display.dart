import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

/// A responsive error display widget that adapts to different screen sizes
class ResponsiveErrorDisplay extends StatelessWidget {
  const ResponsiveErrorDisplay({
    super.key,
    required this.error,
    this.onRetry,
    this.title,
    this.compact = false,
  });

  final Object error;
  final VoidCallback? onRetry;
  final String? title;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactError(context);
    }

    return ResponsiveBuilder(
      mobile: _buildMobileError(context),
      tablet: _buildTabletError(context),
      desktop: _buildDesktopError(context),
    );
  }

  Widget _buildCompactError(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 8.0)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
            size: Responsive.getIconSize(context, baseSize: 16),
          ),
          SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
          Flexible(
            child: Text(
              error.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileError(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Responsive.getSpacing(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: Responsive.getIconSize(context, baseSize: 48),
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: Responsive.getSpacing(context)),
            Text(
              title ?? 'Something went wrong',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabletError(BuildContext context) {
    return Center(
      child: Container(
        width: Responsive.getDialogWidth(context),
        padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 24.0)),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: Responsive.getIconSize(context, baseSize: 64),
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 16.0)),
            Text(
              title ?? 'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.getSpacing(context, baseSpacing: 24.0),
                    vertical: Responsive.getSpacing(context, baseSpacing: 12.0),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopError(BuildContext context) {
    return Center(
      child: Container(
        width: Responsive.getDialogWidth(context) * 1.2,
        padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 32.0)),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: Responsive.getIconSize(context, baseSize: 80),
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
            Text(
              title ?? 'Something went wrong',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 16.0)),
            Container(
              padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 16.0)),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 32.0)),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.getSpacing(context, baseSpacing: 32.0),
                    vertical: Responsive.getSpacing(context, baseSpacing: 16.0),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A responsive loading indicator that adapts to different screen sizes
class ResponsiveLoadingIndicator extends StatelessWidget {
  const ResponsiveLoadingIndicator({
    super.key,
    this.message,
    this.compact = false,
  });

  final String? message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          if (message != null) ...[
            SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Responsive.isMobile(context) ? 32 : 48,
            height: Responsive.isMobile(context) ? 32 : 48,
            child: CircularProgressIndicator(
              strokeWidth: Responsive.isMobile(context) ? 3 : 4,
            ),
          ),
          if (message != null) ...[
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 16.0)),
            Text(
              message!,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// A responsive empty state display that adapts to different screen sizes
class ResponsiveEmptyState extends StatelessWidget {
  const ResponsiveEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.actionLabel,
    this.compact = false,
  });

  final String title;
  final String? message;
  final IconData icon;
  final VoidCallback? action;
  final String? actionLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactEmptyState(context);
    }

    return ResponsiveBuilder(
      mobile: _buildMobileEmptyState(context),
      tablet: _buildTabletEmptyState(context),
      desktop: _buildDesktopEmptyState(context),
    );
  }

  Widget _buildCompactEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 8.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Responsive.getIconSize(context, baseSize: 24),
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Responsive.getSpacing(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Responsive.getIconSize(context, baseSize: 48),
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: Responsive.getSpacing(context)),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null && actionLabel != null) ...[
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
              ElevatedButton(
                onPressed: action,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabletEmptyState(BuildContext context) {
    return Center(
      child: Container(
        width: Responsive.getDialogWidth(context),
        padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 24.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: Responsive.getIconSize(context, baseSize: 64),
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 16.0)),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null && actionLabel != null) ...[
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
              ElevatedButton.icon(
                onPressed: action,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.getSpacing(context, baseSpacing: 24.0),
                    vertical: Responsive.getSpacing(context, baseSpacing: 12.0),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopEmptyState(BuildContext context) {
    return Center(
      child: Container(
        width: Responsive.getDialogWidth(context) * 1.2,
        padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 32.0)),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: Responsive.getIconSize(context, baseSize: 80),
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 16.0)),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null && actionLabel != null) ...[
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 32.0)),
              ElevatedButton.icon(
                onPressed: action,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.getSpacing(context, baseSpacing: 32.0),
                    vertical: Responsive.getSpacing(context, baseSpacing: 16.0),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}