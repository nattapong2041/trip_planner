import 'package:flutter/material.dart';

/// Responsive breakpoints for different screen sizes
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Responsive helper class to determine screen type and provide utilities
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < ResponsiveBreakpoints.mobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.mobile &&
      MediaQuery.of(context).size.width < ResponsiveBreakpoints.desktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.desktop;

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.tablet;

  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Get appropriate padding based on screen size
  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  /// Get appropriate content width with max constraints
  static double getContentWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isMobile(context)) {
      return screenWidth;
    } else if (isTablet(context)) {
      return screenWidth * 0.9;
    } else {
      return (screenWidth * 0.8).clamp(800.0, 1200.0);
    }
  }

  /// Get grid column count based on screen size
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }

  /// Get appropriate card width for lists
  static double getCardWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return 400.0;
    } else {
      return 350.0;
    }
  }

  /// Get appropriate font size scaling
  static double getFontScale(BuildContext context) {
    if (isMobile(context)) {
      return 1.0;
    } else if (isTablet(context)) {
      return 1.1;
    } else {
      return 1.2;
    }
  }

  /// Get appropriate icon size
  static double getIconSize(BuildContext context, {double baseSize = 24.0}) {
    final scale = getFontScale(context);
    return baseSize * scale;
  }

  /// Get appropriate spacing
  static double getSpacing(BuildContext context, {double baseSpacing = 16.0}) {
    if (isMobile(context)) {
      return baseSpacing;
    } else if (isTablet(context)) {
      return baseSpacing * 1.25;
    } else {
      return baseSpacing * 1.5;
    }
  }

  /// Check if device supports touch gestures
  static bool supportsTouchGestures(BuildContext context) {
    // On mobile and tablet, assume touch support
    return isMobile(context) || isTablet(context);
  }

  /// Get appropriate drag feedback size
  static double getDragFeedbackWidth(BuildContext context) {
    if (isMobile(context)) {
      return getScreenWidth(context) * 0.8;
    } else if (isTablet(context)) {
      return 350.0;
    } else {
      return 300.0;
    }
  }

  /// Get appropriate touch target size
  static double getTouchTargetSize(BuildContext context) {
    if (isMobile(context)) {
      return 48.0; // Material Design minimum touch target
    } else {
      return 40.0;
    }
  }

  /// Get appropriate drag handle size for touch devices
  static double getDragHandleSize(BuildContext context) {
    if (supportsTouchGestures(context)) {
      return 24.0;
    } else {
      return 16.0;
    }
  }

  /// Get appropriate dialog width
  static double getDialogWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isMobile(context)) {
      return screenWidth * 0.9;
    } else if (isTablet(context)) {
      return 500.0;
    } else {
      return 600.0;
    }
  }

  /// Get appropriate sidebar width for desktop layouts
  static double getSidebarWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 300.0;
    } else if (isTablet(context)) {
      return 250.0;
    } else {
      return 0.0; // No sidebar on mobile
    }
  }
}

/// Widget that builds different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (Responsive.isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

/// Widget that provides responsive constraints
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? Responsive.getScreenPadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? Responsive.getContentWidth(context),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Responsive grid widget
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;

  @override
  Widget build(BuildContext context) {
    int columns;
    if (Responsive.isMobile(context)) {
      columns = mobileColumns;
    } else if (Responsive.isTablet(context)) {
      columns = tabletColumns;
    } else {
      columns = desktopColumns;
    }

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children.map((child) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 
                 (spacing * (columns + 1))) / columns,
          child: child,
        );
      }).toList(),
    );
  }
}