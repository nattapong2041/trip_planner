import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../models/app_error.dart';
import '../../utils/responsive.dart';

/// Global feedback overlay that shows errors and success messages
class GlobalFeedbackOverlay extends ConsumerWidget {
  const GlobalFeedbackOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorState = ref.watch(errorNotifierProvider);
    final successState = ref.watch(successNotifierProvider);
    final loadingState = ref.watch(loadingNotifierProvider);

    return Stack(
      children: [
        child,
        
        // Global loading overlay
        if (loadingState)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading...'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        
        // Error messages
        if (errorState != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 8,
            child: _ErrorBanner(
              error: errorState,
              onDismiss: () => ref.read(errorNotifierProvider.notifier).clearError(),
            ),
          ),
        
        // Success messages
        if (successState != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 8,
            child: _SuccessBanner(
              message: successState,
              onDismiss: () => ref.read(successNotifierProvider.notifier).clearSuccess(),
            ),
          ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({
    required this.error,
    required this.onDismiss,
  });

  final AppError error;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: _buildMobileBanner(context),
      tablet: _buildTabletBanner(context),
      desktop: _buildDesktopBanner(context),
    );
  }

  Widget _buildMobileBanner(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 12.0)),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              _getErrorIcon(),
              color: Theme.of(context).colorScheme.onErrorContainer,
              size: Responsive.getIconSize(context, baseSize: 20),
            ),
            SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
            Expanded(
              child: Text(
                _getErrorMessage(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onErrorContainer,
                size: Responsive.getIconSize(context, baseSize: 20),
              ),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletBanner(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: Responsive.getDialogWidth(context),
        ),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 16.0)),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _getErrorIcon(),
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  size: Responsive.getIconSize(context, baseSize: 24),
                ),
                SizedBox(width: Responsive.getSpacing(context, baseSpacing: 12.0)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getErrorTitle(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getErrorMessage(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    size: Responsive.getIconSize(context, baseSize: 24),
                  ),
                  onPressed: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopBanner(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: Responsive.getDialogWidth(context) * 1.2,
        ),
        child: Material(
          elevation: 12,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 20.0)),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getErrorIcon(),
                    color: Theme.of(context).colorScheme.error,
                    size: Responsive.getIconSize(context, baseSize: 28),
                  ),
                ),
                SizedBox(width: Responsive.getSpacing(context, baseSpacing: 16.0)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getErrorTitle(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getErrorMessage(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    size: Responsive.getIconSize(context, baseSize: 24),
                  ),
                  onPressed: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getErrorIcon() {
    return error.when(
      network: (_) => Icons.wifi_off,
      authentication: (_) => Icons.lock_outline,
      permission: (_) => Icons.block,
      validation: (_) => Icons.warning_outlined,
      unknown: (_) => Icons.error_outline,
    );
  }

  String _getErrorTitle() {
    return error.when(
      network: (_) => 'Network Error',
      authentication: (_) => 'Authentication Error',
      permission: (_) => 'Permission Error',
      validation: (_) => 'Validation Error',
      unknown: (_) => 'Error',
    );
  }

  String _getErrorMessage() {
    return error.when(
      network: (message) => message,
      authentication: (message) => message,
      permission: (message) => message,
      validation: (message) => message,
      unknown: (message) => message,
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: _buildMobileBanner(context),
      tablet: _buildTabletBanner(context),
      desktop: _buildDesktopBanner(context),
    );
  }

  Widget _buildMobileBanner(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 12.0)),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: Responsive.getIconSize(context, baseSize: 20),
            ),
            SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: Responsive.getIconSize(context, baseSize: 20),
              ),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletBanner(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: Responsive.getDialogWidth(context),
        ),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 16.0)),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: Responsive.getIconSize(context, baseSize: 24),
                ),
                SizedBox(width: Responsive.getSpacing(context, baseSpacing: 12.0)),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: Responsive.getIconSize(context, baseSize: 24),
                  ),
                  onPressed: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopBanner(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: Responsive.getDialogWidth(context) * 1.2,
        ),
        child: Material(
          elevation: 12,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 20.0)),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: Responsive.getIconSize(context, baseSize: 28),
                  ),
                ),
                SizedBox(width: Responsive.getSpacing(context, baseSpacing: 16.0)),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: Responsive.getIconSize(context, baseSize: 24),
                  ),
                  onPressed: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}