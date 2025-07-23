import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'responsive.dart';

/// Utility class for handling platform-specific gestures and interactions
class ResponsiveGestures {
  /// Determines if the current platform supports touch gestures
  static bool supportsTouchGestures() {
    return !kIsWeb || (kIsWeb && defaultTargetPlatform == TargetPlatform.iOS || 
                       defaultTargetPlatform == TargetPlatform.android);
  }

  /// Returns appropriate drag delay based on platform
  static Duration getDragDelay() {
    if (supportsTouchGestures()) {
      return const Duration(milliseconds: 500); // Longer delay for touch devices
    } else {
      return const Duration(milliseconds: 150); // Shorter delay for mouse
    }
  }

  /// Returns appropriate haptic feedback settings based on platform
  static bool shouldUseHapticFeedback() {
    return supportsTouchGestures();
  }

  /// Returns appropriate scroll physics based on platform
  static ScrollPhysics getScrollPhysics(BuildContext context) {
    if (Responsive.isMobile(context) || Responsive.isTablet(context)) {
      return const BouncingScrollPhysics();
    } else {
      return const ClampingScrollPhysics();
    }
  }

  /// Returns appropriate page transition based on platform
  static PageTransitionsBuilder getPageTransitionsBuilder() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return const CupertinoPageTransitionsBuilder();
      case TargetPlatform.android:
        return const ZoomPageTransitionsBuilder();
      default:
        return const FadeUpwardsPageTransitionsBuilder();
    }
  }

  /// Creates a platform-optimized tap/click effect
  static Widget addTapEffect({
    required Widget child,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: borderRadius,
          child: child,
        ),
      ),
    );
  }

  /// Creates a platform-optimized hover effect for desktop
  static Widget addHoverEffect({
    required Widget child,
    required BuildContext context,
    Color? hoverColor,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) {
    if (Responsive.isDesktop(context)) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.transparent,
          ),
          child: child,
        ),
      );
    } else {
      return child;
    }
  }

  /// Returns appropriate tooltip behavior based on platform
  static TooltipTriggerMode getTooltipTriggerMode() {
    if (supportsTouchGestures()) {
      return TooltipTriggerMode.longPress;
    } else {
      return TooltipTriggerMode.manual;
    }
  }

  /// Returns appropriate tooltip wait duration based on platform
  static Duration getTooltipWaitDuration() {
    if (supportsTouchGestures()) {
      return const Duration(seconds: 1);
    } else {
      return const Duration(milliseconds: 500);
    }
  }

  /// Returns appropriate double tap duration based on platform
  static Duration getDoubleTapDuration() {
    if (supportsTouchGestures()) {
      return const Duration(milliseconds: 300);
    } else {
      return const Duration(milliseconds: 200);
    }
  }
}

/// Widget that applies platform-specific gesture behaviors
class ResponsiveGestureDetector extends StatelessWidget {
  const ResponsiveGestureDetector({
    super.key,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
          borderRadius: borderRadius,
          child: child,
        ),
      ),
    );
  }
}

/// Widget that applies platform-specific hover behaviors
class ResponsiveHoverDetector extends StatefulWidget {
  const ResponsiveHoverDetector({
    super.key,
    required this.child,
    required this.builder,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  final Widget child;
  final Widget Function(BuildContext context, bool isHovered) builder;
  final BorderRadius borderRadius;

  @override
  State<ResponsiveHoverDetector> createState() => _ResponsiveHoverDetectorState();
}

class _ResponsiveHoverDetectorState extends State<ResponsiveHoverDetector> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: widget.builder(context, isHovered),
      );
    } else {
      return widget.builder(context, false);
    }
  }
}