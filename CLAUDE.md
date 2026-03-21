<!-- GSD:project-start source:PROJECT.md -->
## Project

**flutter_datawedge Upgrade**

A Flutter plugin for communicating with Zebra DataWedge barcode scanners via the DataWedge Intent API. This is a maintained fork consumed internally via git dependencies. The project needs its dependencies modernized to latest stable versions, Android SDK targets updated, and a GitHub Actions CI/CD pipeline added with automated semantic versioning via mtrust-api-guard.

**Core Value:** The plugin must reliably bridge Flutter apps to Zebra DataWedge scanners with type-safe platform channels — all upgrades must preserve this functionality.

### Constraints

- **Platform**: Android-only — no iOS implementation exists or is planned
- **Compatibility**: Must remain compatible with Zebra DataWedge Intent API
- **Consumption**: Package installed via git URL, not pub.dev — versioning via git tags
- **Code generation**: Pigeon and Freezed upgrades require regeneration of generated files
<!-- GSD:project-end -->

<!-- GSD:stack-start source:codebase/STACK.md -->
## Technology Stack

## Languages
- Dart 3.0.0+ - Flutter package and platform channel implementation
- Kotlin 1.7.10 - Android native plugin implementation
- Java 8 - Build compatibility target
- Gradle - Android build configuration (Groovy and Kotlin DSL)
## Runtime
- Flutter 3.13.1+
- Dart SDK 3.0.0 to <4.0.0
- Pub (Dart's package manager)
- Lockfile: `pubspec.lock` (present)
## Frameworks
- Flutter 3.13.1+ - Mobile UI framework
- Pigeon 26.2.3 - Platform channel code generation for Dart-Kotlin communication
- Build Runner 2.4.6+ - Code generation runner
- Freezed 3.2.5 - Immutable model code generation
- JSON Serializable 6.6.1 - JSON serialization code generation
## Key Dependencies
- `freezed_annotation: ^3.0.0` - Annotations for immutable model generation
- `json_annotation: ^4.8.0` - Annotations for JSON serialization
- `pigeon: ^26.2.3` - Platform channel generation (generates `lib/src/pigeon.dart` and `android/src/main/kotlin/.../Pigeon.kt`)
- `async: ^2.11.0` - Async utilities
- `collection: ^1.17.1` - Collection utilities
- `stream_transform: ^2.1.0` - Stream transformation utilities
- `freezed_result: ^1.0.3+1` - Result type for error handling
- `strict_json: ^2.0.6` - Strict JSON parsing
- `mason_logger: ^0.3.5` - Logging utilities
- `very_good_analysis: ^10.2.0` - Linting configuration
- `lints: ^6.1.0` - Lint rules
- `flutter_test` - Flutter testing framework
## Configuration
- Configured via `pubspec.yaml` and `analysis_options.yaml`
- Dart strict mode enabled: strict-casts and strict-raw-types
- Generated files excluded from analysis: `**/*.g.dart`, `**/*.freezed.dart`, `**/*.mocks.dart`
- Android configuration: `android/build.gradle` (Groovy)
- Example app: `example/android/build.gradle.kts` (Kotlin DSL)
- Pigeon generation script: `generate.sh`
## Platform Requirements
- Dart SDK 3.0.0+
- Flutter 3.13.1+
- Android SDK with compileSdk 34
- Kotlin 1.7.10+
- Java 8 compatibility (source/target compatibility)
- Minimum SDK: Android 19 (minSdkVersion)
- Target/Compile SDK: 34 (compileSdk)
- Plugin class: `com.circuskitchens.flutter_datawedge.FlutterDatawedgePlugin`
- Dart side: Generated from Pigeon at `lib/src/pigeon.dart`
- Android side: Generated from Pigeon at `android/src/main/kotlin/com/circuskitchens/flutter_datawedge/pigeon/Pigeon.kt`
- Channel codec: Custom `_PigeonCodec` (StandardMessageCodec extension)
- Basic message channels for method calls and event callbacks
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

## Naming Patterns
- Dart files use snake_case: `flutter_datawedge.dart`, `scan_result.dart`, `action_result.dart`
- Generated files use snake_case with suffix: `*.g.dart` (JSON serialization), `*.freezed.dart` (Freezed models), `*.mocks.dart` (test mocks)
- Barrel/export files at directory root: `lib/flutter_datawedge.dart` exports public API
- Public functions use camelCase: `createProfile()`, `disableAllDecoders()`, `getPackageIdentifer()`, `setConfig()`
- Private functions use camelCase with leading underscore: `_setAllDecoders()`, `_hostApi`, `_scanEvents`
- Async functions return `Future` type explicitly
- Function names are action-oriented verbs: `enable`, `disable`, `get`, `set`, `register`, `create`
- Final fields use camelCase: `packageName`, `availableDecoders`, `config`
- Static fields use camelCase with leading underscore if private: `_instCount`, `_flutterDataWedge`
- Stream/controller variables use camelCase with leading underscore: `_scanEvents`, `_statusChangeEvents`
- Loop variables use camelCase: `decoder`, `scanEvent`, `statusEvent`
- Classes use PascalCase: `FlutterDataWedge`, `ScanResult`, `ActionResult`, `Logger`, `LogMessage`
- Enums use PascalCase: `LogSeverity`, `ConfigMode`, `ScannerStatusType`, `Decoder`
- Enum values use SCREAMING_SNAKE_CASE: `WAITING`, `SCANNING`, `IDLE`, `DISABLED`
- Type parameters use single capital letters or PascalCase: `Future<List<Decoder>>`, `Stream<ScanEvent>`
## Code Style
- Uses Dart standard formatting (dart format)
- Line breaks after imports for clarity: stdlib imports, package imports, relative imports
- Consistent spacing around operators and type annotations
- Uses `very_good_analysis` ^10.2.0 for linting rules (via `package:very_good_analysis/analysis_options.yaml`)
- Strict language settings enabled in `analysis_options.yaml`:
- Generated files excluded from analysis: `**/*.g.dart`, `**/*.freezed.dart`, `**/*.mocks.dart`, `build/**`
- `public_member_api_docs` disabled (not requiring documentation for public members)
- Linter rule `avoid_positional_boolean_parameters` ignored in pigeon files (see `//ignore_for_file:` comment)
## Import Organization
- No path aliases configured
- Absolute imports using package name throughout: `import 'package:flutter_datawedge/flutter_datawedge.dart'`
- Barrel files used for public API exports: `lib/flutter_datawedge.dart` centralizes exports
## Error Handling
- Custom Error subclasses for logic errors: `ProfileExistsError extends Error`, `ProfileNameEmptyError extends Error`
- Custom Exception subclasses for exceptional conditions: `FlutterDatawedgeException implements Exception`, `NotInitializedException`
- Try-catch blocks used for encoder attempts, logging failures without throwing: `_setAllDecoders()` catches decoder setup failures
- Assertions used for contract enforcement: `assert(profileName.isNotEmpty, 'Profile name cannot be empty')`
- Logger used to record errors and info: `logger.info('Decoder $decoder not available')` on catch
## Logging
- Logger is a singleton instance: `final logger = Logger(prefix: 'flutter_datawedge')`
- Severity levels: `LogSeverity.debug`, `LogSeverity.info`, `LogSeverity.warning`, `LogSeverity.error`
- Use appropriate level methods: `logger.debug()`, `logger.info()`, `logger.error()`, `logger.warning()`
- Logs are stored in memory and also emitted via developer.log()
- Logger extends ChangeNotifier for reactive UI updates when logs change
- `lib/src/flutter_datawedge.dart`: Profile changes, config updates, scan results, status changes, plugin state
- Decoder setup attempts logged at info level when unavailable
- Debug logs for lifecycle events: enabling/disabling/suspending scanner
## Comments
- Class-level documentation with `///` for public API: FlutterDataWedge, StreamController purposes
- Method documentation with `///` for public methods explaining behavior and parameters
- Minimal inline comments - code is self-documenting through descriptive names
- TODO/FIXME comments not used (code appears clean of technical debt)
- Uses triple-slash `///` documentation comments for Dart doc
- Example from `lib/src/flutter_datawedge.dart`:
## Function Design
- `createProfile()`: 27 lines - creates profile and optionally configures it
- `_setAllDecoders()`: 12 lines - iterates decoders, applies setting, handles failures
- `enableAllDecoders()` and `disableAllDecoders()`: 2 lines each - delegate to `_setAllDecoders()`
- Named parameters for clarity, especially booleans: `{required bool on}`, `{bool autoActivate = true}`
- Type annotations required on all parameters: `String profileName`, `bool enabled`, `String profileName`
- Required keyword used for non-optional parameters: `required String profileName`
- Optional parameters given defaults: `bool autoActivate = true`
- Explicit return types for all functions: `Future<void>`, `Future<String>`, `Future<List<Decoder>>`, `Stream<ScanEvent>`
- Early returns used (implicit with getters): `Stream<ScanEvent> get scans => _scanEvents.stream;`
- Futures and Streams used for async operations and event streams
## Module Design
- Barrel file pattern: `lib/flutter_datawedge.dart` exports public API
- Consumers import from package root: `import 'package:flutter_datawedge/flutter_datawedge.dart'`
- Internal modules (models, pigeon generated) not directly exported but re-exported through barrel
- Used to aggregate public API at package root
- Simplifies consumer imports (one import instead of multiple)
- Internal modules in `src/` directory kept private but accessible through barrel exports
- Models use Freezed for immutability: `ScanResult`, `ActionResult`, `ScannerStatus`
- JSON serialization via `json_serializable`: `.g.dart` files auto-generated
- Named constructors for alternate construction: `factory ScanResult.fromJson(Map<String, dynamic> json)`
- Computed properties supported via `const ActionResult._()`: `bool get success => result == 'SUCCESS'`
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

## Pattern Overview
- Singleton pattern for stateless API access via `FlutterDataWedge.instance`
- Platform channel communication using **Pigeon** for type-safe Dart-Kotlin interop
- Broadcast streams for decoupled event delivery (scans and status changes)
- Configuration-driven scanner setup through nested data classes
- Android-only implementation (no iOS support)
## Layers
- Purpose: Exposes high-level API to Flutter applications
- Location: `lib/src/flutter_datawedge.dart`
- Contains: Main `FlutterDataWedge` class with profile management, decoder control, and plugin state methods
- Depends on: Pigeon-generated APIs, StreamController, Logger
- Used by: Flutter application code
- Purpose: Type-safe bidirectional communication between Dart and Kotlin
- Location: `lib/src/pigeon.dart` (generated from `pigeons/datawedge_pigeon.dart`)
- Contains: Auto-generated `DataWedgeHostApi` and `DataWedgeFlutterApi` classes, all DTOs and enums
- Depends on: Flutter platform channels
- Used by: Flutter API layer and Android platform layer
- Purpose: Native Android implementation interfacing with DataWedge Intent API
- Location: `android/src/main/kotlin/com/circuskitchens/flutter_datawedge/`
- Contains:
- Depends on: Android Intent system, Pigeon-generated Kotlin code
- Used by: Flutter runtime via platform channels
- Purpose: Immutable data classes for events and configuration
- Location: `lib/src/models/` and Pigeon enums
- Contains:
- Depends on: Freezed annotations for code generation
- Used by: All layers
- Purpose: Structured logging with severity levels
- Location: `lib/logger.dart`
- Contains: `Logger` class with severity filtering and `LogMessage` records
- Depends on: Flutter Foundation
- Used by: Flutter API layer for debug output
## Data Flow
- **Scan Stream**: `StreamController<ScanEvent>.broadcast()` - Multi-listener support
- **Status Stream**: `StreamController<StatusChangeEvent>.broadcast()` - Multi-listener support
- **Singleton State**: `_flutterDataWedge` static instance ensures one active receiver
- **Callbacks Map**: `DWInterface.callbacks` HashMap stores pending command responses keyed by command identifier
## Key Abstractions
- Purpose: Single entry point for all DataWedge operations
- Examples: `lib/src/flutter_datawedge.dart`
- Pattern: Singleton with assertion in constructor to prevent multiple instances
- Exposes: Profile creation, decoder management, plugin state, scan/status streams
- Purpose: Fluent-style hierarchical configuration for scanner profiles
- Examples: Used in `lib/src/pigeon.dart` (generated)
- Pattern: Nested nullable configuration classes (`PluginBarcodeParamters`, `PluginIntentParamters`)
- Mapping: Kotlin builders convert to Android Bundles matching DataWedge Intent schema
- Purpose: Immutable representation of barcode scan data
- Examples: `lib/src/models/` (defined in Pigeon, maps from Android Intent extras)
- Pattern: Immutable class with JSON serialization, includes labelType, source, dataString, decodeData
- Usage: Streamed to listeners as events occur
- Purpose: Bidirectional bridge between Android Intent system and Dart
- Examples: `android/src/main/kotlin/.../DWInterface.kt`
- Pattern: BroadcastReceiver + HostApi implementation
- Responsibilities: Intent reception, payload parsing, command callback dispatch
## Entry Points
- Location: `lib/flutter_datawedge.dart`
- Triggers: App imports `package:flutter_datawedge`
- Responsibilities: Re-exports public API (decoder_all, flutter_datawedge, pigeon)
- Location: `android/src/main/kotlin/.../FlutterDatawedgePlugin.kt`
- Triggers: Flutter engine attachment at app startup
- Responsibilities:
- Location: `lib/src/flutter_datawedge.dart` constructor and static block
- Triggers: First access to `FlutterDataWedge.instance`
- Responsibilities:
## Error Handling
- **Custom Exceptions** (`lib/src/models/flutter_datawedge_exception.dart`):
- **Decoder Availability Handling** (`lib/src/flutter_datawedge.dart` lines 84-99):
- **Platform Exception Handling**:
## Cross-Cutting Concerns
- Framework: Custom `Logger` class in `lib/logger.dart`
- Output: Dart developer.log() with timestamp and severity
- Usage: `FlutterDataWedge` methods call `logger.debug()` and `logger.info()`
- Severity Levels: debug < info < warning < error (filtered by `logLevel`)
- Dart-side: Assertions in public methods (e.g., profile name not empty)
- Android-side: Bundle utilities validate enum conversions in `BuildBarcodeConfig.kt`
- Configuration: Nullable fields allow partial configs; DataWedge uses defaults
- Strategy: None - Direct Intent API assumes device is authorized
- Profile Activation: `autoActivate=true` auto-registers current app package as activation trigger
- Broadcast Receiver: Registered in `onAttachedToEngine()`, unregistered in `onDetachedFromEngine()`
- Streams: Broadcast streams created as instance fields, never closed by library (app responsibility)
- Platform Channels: Managed by Flutter framework, no explicit cleanup needed
<!-- GSD:architecture-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd:quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd:debug` for investigation and bug fixing
- `/gsd:execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->



<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd:profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
