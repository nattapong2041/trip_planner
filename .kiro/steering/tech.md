# Technology Stack

## Framework & Language
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language (SDK >=3.0.0 <4.0.0)

## State Management
- **Riverpod** - Primary state management solution
- **riverpod_annotation** - Code generation for providers
- **riverpod_generator** - Build-time code generation

## Navigation
- **go_router** - Declarative routing solution

## Backend & Services
- **Firebase Core** - Backend infrastructure
- **Firebase Auth** (planned) - User authentication
- **Cloud Firestore** (planned) - Database
- **Google Sign-In** (planned) - OAuth integration
- **Sign in with Apple** (planned) - iOS authentication

## UI & Assets
- **Material Design 3** - Design system
- **flutter_svg** - SVG asset support
- **cached_network_image** - Image caching
- **cupertino_icons** - iOS-style icons

## Code Generation & Serialization
- **freezed** - Immutable data classes
- **json_annotation** & **json_serializable** - JSON serialization
- **build_runner** - Code generation runner

## Development Tools
- **flutter_lints** - Dart/Flutter linting rules
- **custom_lint** & **riverpod_lint** - Custom linting
- **logger** - Logging utility
- **uuid** - UUID generation

## Common Commands

### Code Generation
```bash
# Generate all code (freezed, riverpod, json)
./generate.sh
# or manually:
dart run build_runner build --delete-conflicting-outputs
```

### Development
```bash
# Run the app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .
```

### Build
```bash
# Build for production
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
flutter build macos        # macOS
flutter build windows      # Windows
flutter build linux        # Linux
```