import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../providers/router_provider.dart';
import '../utils/responsive.dart';

class TripPlannerApp extends ConsumerWidget {
  const TripPlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: AppConfig.appName,
      theme: _buildTheme(context),
      darkTheme: _buildDarkTheme(context),
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      // Responsive typography
      textTheme: _buildTextTheme(context, Brightness.light),
      // Card theme for consistent styling
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      // App bar theme
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        highlightElevation: 8,
      ),
    );
  }

  ThemeData _buildDarkTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      textTheme: _buildTextTheme(context, Brightness.dark),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        highlightElevation: 8,
      ),
    );
  }

  TextTheme _buildTextTheme(BuildContext context, Brightness brightness) {
    // Get base text theme
    final baseTheme = brightness == Brightness.light
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme;

    // Apply responsive scaling
    final scale = Responsive.getFontScale(context);
    
    return baseTheme.copyWith(
      displayLarge: baseTheme.displayLarge?.copyWith(
        fontSize: (baseTheme.displayLarge?.fontSize ?? 57) * scale,
      ),
      displayMedium: baseTheme.displayMedium?.copyWith(
        fontSize: (baseTheme.displayMedium?.fontSize ?? 45) * scale,
      ),
      displaySmall: baseTheme.displaySmall?.copyWith(
        fontSize: (baseTheme.displaySmall?.fontSize ?? 36) * scale,
      ),
      headlineLarge: baseTheme.headlineLarge?.copyWith(
        fontSize: (baseTheme.headlineLarge?.fontSize ?? 32) * scale,
      ),
      headlineMedium: baseTheme.headlineMedium?.copyWith(
        fontSize: (baseTheme.headlineMedium?.fontSize ?? 28) * scale,
      ),
      headlineSmall: baseTheme.headlineSmall?.copyWith(
        fontSize: (baseTheme.headlineSmall?.fontSize ?? 24) * scale,
      ),
      titleLarge: baseTheme.titleLarge?.copyWith(
        fontSize: (baseTheme.titleLarge?.fontSize ?? 22) * scale,
      ),
      titleMedium: baseTheme.titleMedium?.copyWith(
        fontSize: (baseTheme.titleMedium?.fontSize ?? 16) * scale,
      ),
      titleSmall: baseTheme.titleSmall?.copyWith(
        fontSize: (baseTheme.titleSmall?.fontSize ?? 14) * scale,
      ),
      bodyLarge: baseTheme.bodyLarge?.copyWith(
        fontSize: (baseTheme.bodyLarge?.fontSize ?? 16) * scale,
      ),
      bodyMedium: baseTheme.bodyMedium?.copyWith(
        fontSize: (baseTheme.bodyMedium?.fontSize ?? 14) * scale,
      ),
      bodySmall: baseTheme.bodySmall?.copyWith(
        fontSize: (baseTheme.bodySmall?.fontSize ?? 12) * scale,
      ),
      labelLarge: baseTheme.labelLarge?.copyWith(
        fontSize: (baseTheme.labelLarge?.fontSize ?? 14) * scale,
      ),
      labelMedium: baseTheme.labelMedium?.copyWith(
        fontSize: (baseTheme.labelMedium?.fontSize ?? 12) * scale,
      ),
      labelSmall: baseTheme.labelSmall?.copyWith(
        fontSize: (baseTheme.labelSmall?.fontSize ?? 11) * scale,
      ),
    );
  }
}