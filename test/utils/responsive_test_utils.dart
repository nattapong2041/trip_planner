import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Utility class for testing responsive layouts
class ResponsiveTestUtils {
  /// Test a widget on different screen sizes
  static Future<void> testResponsiveWidget({
    required WidgetTester tester,
    required Widget widget,
    List<Size> screenSizes = const [
      Size(320, 568),  // Small mobile (iPhone SE)
      Size(375, 812),  // Medium mobile (iPhone X)
      Size(414, 896),  // Large mobile (iPhone 11 Pro Max)
      Size(768, 1024), // Tablet (iPad)
      Size(1024, 768), // Tablet landscape
      Size(1280, 800), // Small desktop
      Size(1920, 1080), // Large desktop
    ],
  }) async {
    for (final size in screenSizes) {
      await _testOnScreenSize(tester, widget, size);
    }
  }

  /// Test a widget on a specific screen size
  static Future<void> _testOnScreenSize(
    WidgetTester tester,
    Widget widget,
    Size size,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(
      MaterialApp(
        home: widget,
      ),
    );
    
    await tester.pumpAndSettle();
    
    // Reset the test values
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  /// Simulate different device orientations
  static Future<void> testResponsiveWidgetInOrientations({
    required WidgetTester tester,
    required Widget widget,
    Size portraitSize = const Size(375, 812),
    Size landscapeSize = const Size(812, 375),
  }) async {
    // Test in portrait mode
    await _testOnScreenSize(tester, widget, portraitSize);
    
    // Test in landscape mode
    await _testOnScreenSize(tester, widget, landscapeSize);
  }

  /// Test a widget with different text scale factors
  static Future<void> testResponsiveWidgetWithTextScales({
    required WidgetTester tester,
    required Widget widget,
    List<double> textScales = const [0.85, 1.0, 1.5, 2.0],
    Size screenSize = const Size(375, 812),
  }) async {
    for (final scale in textScales) {
      tester.view.physicalSize = screenSize;
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              size: screenSize,
              devicePixelRatio: 1.0,
              textScaler: TextScaler.linear(scale),
            ),
            child: widget,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
    }
    
    // Reset the test values
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  /// Test a widget with different platform themes
  static Future<void> testResponsiveWidgetWithPlatforms({
    required WidgetTester tester,
    required Widget widget,
    List<TargetPlatform> platforms = const [
      TargetPlatform.android,
      TargetPlatform.iOS,
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
    ],
    Size screenSize = const Size(375, 812),
  }) async {
    for (final platform in platforms) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            platform: platform,
            useMaterial3: true,
          ),
          home: MediaQuery(
            data: MediaQueryData(
              size: screenSize,
              devicePixelRatio: 1.0,
            ),
            child: widget,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
    }
  }
}

/// Extension methods for testing responsive widgets
extension ResponsiveTestExtensions on WidgetTester {
  /// Test a widget on different screen sizes
  Future<void> testOnDifferentScreenSizes(
    Widget widget, {
    List<Size> screenSizes = const [
      Size(320, 568),  // Small mobile
      Size(768, 1024), // Tablet
      Size(1280, 800), // Desktop
    ],
  }) async {
    await ResponsiveTestUtils.testResponsiveWidget(
      tester: this,
      widget: widget,
      screenSizes: screenSizes,
    );
  }

  /// Test a widget in different orientations
  Future<void> testInDifferentOrientations(Widget widget) async {
    await ResponsiveTestUtils.testResponsiveWidgetInOrientations(
      tester: this,
      widget: widget,
    );
  }

  /// Test a widget with different text scales
  Future<void> testWithDifferentTextScales(Widget widget) async {
    await ResponsiveTestUtils.testResponsiveWidgetWithTextScales(
      tester: this,
      widget: widget,
    );
  }

  /// Test a widget with different platforms
  Future<void> testOnDifferentPlatforms(Widget widget) async {
    await ResponsiveTestUtils.testResponsiveWidgetWithPlatforms(
      tester: this,
      widget: widget,
    );
  }
}