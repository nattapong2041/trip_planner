import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

/// A button that shows loading state during async operations
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
    this.icon,
    this.loadingText,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final ButtonStyle? style;
  final Widget? icon;
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: style,
        icon: isLoading
            ? SizedBox(
                width: Responsive.getIconSize(context, baseSize: 16),
                height: Responsive.getIconSize(context, baseSize: 16),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : icon!,
        label: isLoading && loadingText != null
            ? Text(loadingText!)
            : child,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: Responsive.getIconSize(context, baseSize: 16),
                  height: Responsive.getIconSize(context, baseSize: 16),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                if (loadingText != null) ...[
                  SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                  Text(loadingText!),
                ],
              ],
            )
          : child,
    );
  }
}

/// A text button that shows loading state during async operations
class LoadingTextButton extends StatelessWidget {
  const LoadingTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
    this.icon,
    this.loadingText,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final ButtonStyle? style;
  final Widget? icon;
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return TextButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: style,
        icon: isLoading
            ? SizedBox(
                width: Responsive.getIconSize(context, baseSize: 16),
                height: Responsive.getIconSize(context, baseSize: 16),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : icon!,
        label: isLoading && loadingText != null
            ? Text(loadingText!)
            : child,
      );
    }

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: Responsive.getIconSize(context, baseSize: 16),
                  height: Responsive.getIconSize(context, baseSize: 16),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (loadingText != null) ...[
                  SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                  Text(loadingText!),
                ],
              ],
            )
          : child,
    );
  }
}

/// An outlined button that shows loading state during async operations
class LoadingOutlinedButton extends StatelessWidget {
  const LoadingOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
    this.icon,
    this.loadingText,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final ButtonStyle? style;
  final Widget? icon;
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: style,
        icon: isLoading
            ? SizedBox(
                width: Responsive.getIconSize(context, baseSize: 16),
                height: Responsive.getIconSize(context, baseSize: 16),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : icon!,
        label: isLoading && loadingText != null
            ? Text(loadingText!)
            : child,
      );
    }

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: Responsive.getIconSize(context, baseSize: 16),
                  height: Responsive.getIconSize(context, baseSize: 16),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (loadingText != null) ...[
                  SizedBox(width: Responsive.getSpacing(context, baseSpacing: 8.0)),
                  Text(loadingText!),
                ],
              ],
            )
          : child,
    );
  }
}

/// A floating action button that shows loading state during async operations
class LoadingFloatingActionButton extends StatelessWidget {
  const LoadingFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.mini = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool mini;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: isLoading ? null : onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      mini: mini,
      child: isLoading
          ? SizedBox(
              width: mini ? 16 : 24,
              height: mini ? 16 : 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : child,
    );
  }
}