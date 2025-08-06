# Copilot Instructions for Trip Planner

## Project Overview
- **Trip Planner** is a collaborative travel planning app built with Flutter and Riverpod, using Firebase for backend services. It supports web, mobile, and desktop platforms.
- The architecture follows MVVM with Riverpod providers as ViewModels, Freezed models, and repository pattern for data access.

## Key Directories & Patterns
- `lib/models/`: Freezed data models with JSON serialization (`model.dart`, `model.freezed.dart`, `model.g.dart`).
- `lib/repositories/`: Abstract repository interfaces and Firebase implementations. Use dependency injection via Riverpod providers.
- `lib/providers/`: Riverpod providers for state management. Providers are generated and exported via `providers.dart`.
- `lib/screens/`: Feature screens (auth, trips, activities) using Go Router for navigation.
- `lib/widgets/`: Reusable UI components, organized by domain.
- `lib/config/`: App-wide configuration, including Firebase options.
- `lib/services/` & `lib/utils/`: Business logic, helpers, and external integrations.

## Developer Workflows
- **Code Generation:**
  - Run `./generate.sh` or `dart run build_runner build --delete-conflicting-outputs` to generate Freezed, Riverpod, and JSON code.
- **Build & Run:**
  - Use `flutter run` for development.
  - Build for platforms: `flutter build web|apk|ios|macos|windows|linux`.
- **Testing:**
  - Run all tests: `flutter test`
  - Mocks for Firebase are in `test/helpers/firebase_mocks.dart`.
  - Organize tests by feature in `test/models/`, `test/providers/`, `test/integration/`, etc.
- **Linting & Formatting:**
  - Analyze: `flutter analyze`
  - Format: `dart format .`

## Architectural Conventions
- **MVVM:**
  - UI widgets observe Riverpod providers (ViewModels).
  - Providers manage business logic and async state (use `AsyncValue`).
  - Repositories abstract data access; use Firebase for production, Mockito for tests.
- **Navigation:**
  - Declarative routing via Go Router. Auth guards redirect unauthenticated users.
- **Drag-and-Drop:**
  - Activities and days use drag-and-drop components for assignment and reordering.
- **Collaboration:**
  - Real-time updates via Firestore streams. Collaborator management via provider widgets.
- **Error Handling:**
  - Use global error notifier and user-friendly messages. AsyncValue for error states.

## Integration Points
- **Firebase:**
  - Auth, Firestore, and Storage. Security rules in `firestore.rules`.
  - CORS for web: configure via `cors.json` and `gsutil cors set`.
- **Code Generation:**
  - Freezed, Riverpod, and JSON serialization. All generated files are committed.

## Project-Specific Patterns
- **Naming:**
  - Files: `snake_case.dart`, Classes: `PascalCase`, Providers: `camelCaseProvider`.
- **Testing:**
  - Use Mockito for repository mocks. Test data in `TestData` classes.
- **Responsive Design:**
  - Layouts adapt for mobile, tablet, and web. Drag-and-drop optimized for all platforms.

## Example: Adding a New Feature
1. Define model in `lib/models/` using Freezed.
2. Add repository method in `lib/repositories/`.
3. Create provider in `lib/providers/`.
4. Build UI in `lib/screens/` and `lib/widgets/`.
5. Write tests in `test/`.
6. Run code generation and tests.

---

For more details, see `.kiro/steering/structure.md`, `.kiro/steering/tech.md`, and `.kiro/specs/trip-planner/design.md`.
