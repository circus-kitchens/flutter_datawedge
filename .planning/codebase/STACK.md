# Technology Stack

**Analysis Date:** 2026-03-21

## Languages

**Primary:**
- Dart 3.0.0+ - Flutter package and platform channel implementation
- Kotlin 1.7.10 - Android native plugin implementation
- Java 8 - Build compatibility target

**Secondary:**
- Gradle - Android build configuration (Groovy and Kotlin DSL)

## Runtime

**Environment:**
- Flutter 3.13.1+
- Dart SDK 3.0.0 to <4.0.0

**Package Manager:**
- Pub (Dart's package manager)
- Lockfile: `pubspec.lock` (present)

## Frameworks

**Core:**
- Flutter 3.13.1+ - Mobile UI framework
- Pigeon 26.2.3 - Platform channel code generation for Dart-Kotlin communication

**Build/Dev:**
- Build Runner 2.4.6+ - Code generation runner
- Freezed 3.2.5 - Immutable model code generation
- JSON Serializable 6.6.1 - JSON serialization code generation

## Key Dependencies

**Critical:**
- `freezed_annotation: ^3.0.0` - Annotations for immutable model generation
- `json_annotation: ^4.8.0` - Annotations for JSON serialization
- `pigeon: ^26.2.3` - Platform channel generation (generates `lib/src/pigeon.dart` and `android/src/main/kotlin/.../Pigeon.kt`)

**Utilities:**
- `async: ^2.11.0` - Async utilities
- `collection: ^1.17.1` - Collection utilities
- `stream_transform: ^2.1.0` - Stream transformation utilities
- `freezed_result: ^1.0.3+1` - Result type for error handling
- `strict_json: ^2.0.6` - Strict JSON parsing
- `mason_logger: ^0.3.5` - Logging utilities

**Development:**
- `very_good_analysis: ^10.2.0` - Linting configuration
- `lints: ^6.1.0` - Lint rules
- `flutter_test` - Flutter testing framework

## Configuration

**Environment:**
- Configured via `pubspec.yaml` and `analysis_options.yaml`
- Dart strict mode enabled: strict-casts and strict-raw-types
- Generated files excluded from analysis: `**/*.g.dart`, `**/*.freezed.dart`, `**/*.mocks.dart`

**Build:**
- Android configuration: `android/build.gradle` (Groovy)
- Example app: `example/android/build.gradle.kts` (Kotlin DSL)
- Pigeon generation script: `generate.sh`

## Platform Requirements

**Development:**
- Dart SDK 3.0.0+
- Flutter 3.13.1+
- Android SDK with compileSdk 34
- Kotlin 1.7.10+
- Java 8 compatibility (source/target compatibility)

**Android:**
- Minimum SDK: Android 19 (minSdkVersion)
- Target/Compile SDK: 34 (compileSdk)
- Plugin class: `com.circuskitchens.flutter_datawedge.FlutterDatawedgePlugin`

**Platform Channel Implementation:**
- Dart side: Generated from Pigeon at `lib/src/pigeon.dart`
- Android side: Generated from Pigeon at `android/src/main/kotlin/com/circuskitchens/flutter_datawedge/pigeon/Pigeon.kt`
- Channel codec: Custom `_PigeonCodec` (StandardMessageCodec extension)
- Basic message channels for method calls and event callbacks

---

*Stack analysis: 2026-03-21*
