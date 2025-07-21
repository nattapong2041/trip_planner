# Project Structure

## Root Directory
- `lib/` - Main application source code
- `test/` - Unit and widget tests
- `assets/` - Static assets (images, icons)
- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` - Platform-specific code
- `pubspec.yaml` - Dependencies and project configuration
- `analysis_options.yaml` - Dart analyzer configuration
- `generate.sh` - Code generation script

## Core Application Structure (`lib/`)

### Configuration
- `config/` - App-wide configuration
  - `app_config.dart` - Firebase options and app constants

### Data Layer
- `models/` - Data models using Freezed for immutability
  - All models include `.freezed.dart` and `.g.dart` generated files
  - JSON serialization support via `json_annotation`
- `repositories/` - Data access layer
  - Abstract repository interfaces
  - Mock implementations for development
  - `mock_data_generator.dart` - Test data generation

### State Management
- `providers/` - Riverpod providers for state management
  - Generated providers using `riverpod_annotation`
  - `providers.dart` - Central export file for all providers
  - Include `.g.dart` generated files

### UI Layer
- `screens/` - Full-screen views organized by feature
  - `auth/` - Authentication screens
  - `trips/` - Trip-related screens
  - `activities/` - Activity-related screens
  - `app.dart` - Root application widget
- `widgets/` - Reusable UI components organized by domain
  - `common/` - Shared widgets
  - `trip/` - Trip-specific widgets
  - `activity/` - Activity-specific widgets

### Utilities
- `services/` - Business logic and external service integrations
- `utils/` - Helper functions and utilities

## Code Generation Files
All generated files follow these patterns:
- `*.freezed.dart` - Freezed generated immutable classes
- `*.g.dart` - JSON serialization and Riverpod providers
- Generated files are committed to version control

## Architecture Patterns

### State Management
- Use Riverpod providers for all state management
- Providers are generated using `riverpod_annotation`
- Export all providers through `providers/providers.dart`

### Data Models
- All models use Freezed for immutability
- Include JSON serialization with `json_annotation`
- Follow the pattern: `model.dart`, `model.freezed.dart`, `model.g.dart`

### Repository Pattern
- Abstract repository interfaces in `repositories/`
- Mock implementations for development and testing
- Dependency injection through Riverpod providers

### Navigation
- Declarative routing with `go_router`
- Router configuration in `providers/router_provider.dart`

## Naming Conventions
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `camelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants
- Providers: `camelCaseProvider`