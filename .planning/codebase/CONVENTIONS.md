# Coding Conventions

**Analysis Date:** 2026-03-21

## Naming Patterns

**Files:**
- Dart files use snake_case: `flutter_datawedge.dart`, `scan_result.dart`, `action_result.dart`
- Generated files use snake_case with suffix: `*.g.dart` (JSON serialization), `*.freezed.dart` (Freezed models), `*.mocks.dart` (test mocks)
- Barrel/export files at directory root: `lib/flutter_datawedge.dart` exports public API

**Functions:**
- Public functions use camelCase: `createProfile()`, `disableAllDecoders()`, `getPackageIdentifer()`, `setConfig()`
- Private functions use camelCase with leading underscore: `_setAllDecoders()`, `_hostApi`, `_scanEvents`
- Async functions return `Future` type explicitly
- Function names are action-oriented verbs: `enable`, `disable`, `get`, `set`, `register`, `create`

**Variables:**
- Final fields use camelCase: `packageName`, `availableDecoders`, `config`
- Static fields use camelCase with leading underscore if private: `_instCount`, `_flutterDataWedge`
- Stream/controller variables use camelCase with leading underscore: `_scanEvents`, `_statusChangeEvents`
- Loop variables use camelCase: `decoder`, `scanEvent`, `statusEvent`

**Types:**
- Classes use PascalCase: `FlutterDataWedge`, `ScanResult`, `ActionResult`, `Logger`, `LogMessage`
- Enums use PascalCase: `LogSeverity`, `ConfigMode`, `ScannerStatusType`, `Decoder`
- Enum values use SCREAMING_SNAKE_CASE: `WAITING`, `SCANNING`, `IDLE`, `DISABLED`
- Type parameters use single capital letters or PascalCase: `Future<List<Decoder>>`, `Stream<ScanEvent>`

## Code Style

**Formatting:**
- Uses Dart standard formatting (dart format)
- Line breaks after imports for clarity: stdlib imports, package imports, relative imports
- Consistent spacing around operators and type annotations

**Linting:**
- Uses `very_good_analysis` ^10.2.0 for linting rules (via `package:very_good_analysis/analysis_options.yaml`)
- Strict language settings enabled in `analysis_options.yaml`:
  - `strict-casts: true`
  - `strict-raw-types: true`
- Generated files excluded from analysis: `**/*.g.dart`, `**/*.freezed.dart`, `**/*.mocks.dart`, `build/**`
- `public_member_api_docs` disabled (not requiring documentation for public members)
- Linter rule `avoid_positional_boolean_parameters` ignored in pigeon files (see `//ignore_for_file:` comment)

## Import Organization

**Order:**
1. Dart core imports: `dart:async`, `dart:developer`
2. Flutter framework imports: `package:flutter/foundation.dart`, `package:flutter/material.dart`
3. Third-party package imports: `package:freezed_annotation`, `package:json_annotation`
4. Local package imports: `package:flutter_datawedge/...`
5. Relative imports (minimal use, prefer absolute package imports)

**Path Aliases:**
- No path aliases configured
- Absolute imports using package name throughout: `import 'package:flutter_datawedge/flutter_datawedge.dart'`
- Barrel files used for public API exports: `lib/flutter_datawedge.dart` centralizes exports

**Example from `lib/src/flutter_datawedge.dart`:**
```dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:flutter_datawedge/logger.dart';
import 'package:flutter_datawedge/src/pigeon.dart';
```

## Error Handling

**Patterns:**
- Custom Error subclasses for logic errors: `ProfileExistsError extends Error`, `ProfileNameEmptyError extends Error`
- Custom Exception subclasses for exceptional conditions: `FlutterDatawedgeException implements Exception`, `NotInitializedException`
- Try-catch blocks used for encoder attempts, logging failures without throwing: `_setAllDecoders()` catches decoder setup failures
- Assertions used for contract enforcement: `assert(profileName.isNotEmpty, 'Profile name cannot be empty')`
- Logger used to record errors and info: `logger.info('Decoder $decoder not available')` on catch

**Example from `lib/src/flutter_datawedge.dart`:**
```dart
try {
  await _hostApi.setDecoder(decoder, enabled, profileName);
  availableDecoders.add(decoder);
} catch (e) {
  logger.info('Decoder $decoder not available');
}
```

## Logging

**Framework:** Custom Logger class in `lib/logger.dart`

**Patterns:**
- Logger is a singleton instance: `final logger = Logger(prefix: 'flutter_datawedge')`
- Severity levels: `LogSeverity.debug`, `LogSeverity.info`, `LogSeverity.warning`, `LogSeverity.error`
- Use appropriate level methods: `logger.debug()`, `logger.info()`, `logger.error()`, `logger.warning()`
- Logs are stored in memory and also emitted via developer.log()
- Logger extends ChangeNotifier for reactive UI updates when logs change

**Logging locations in source:**
- `lib/src/flutter_datawedge.dart`: Profile changes, config updates, scan results, status changes, plugin state
- Decoder setup attempts logged at info level when unavailable
- Debug logs for lifecycle events: enabling/disabling/suspending scanner

## Comments

**When to Comment:**
- Class-level documentation with `///` for public API: FlutterDataWedge, StreamController purposes
- Method documentation with `///` for public methods explaining behavior and parameters
- Minimal inline comments - code is self-documenting through descriptive names
- TODO/FIXME comments not used (code appears clean of technical debt)

**JSDoc/TSDoc:**
- Uses triple-slash `///` documentation comments for Dart doc
- Example from `lib/src/flutter_datawedge.dart`:
```dart
/// Main class used to interact with DataWedge. Use [FlutterDataWedge.instance]
/// to access a singleton instance
class FlutterDataWedge extends DataWedgeFlutterApi {
  /// Used to create a new [FlutterDataWedge]
  /// ...
}

/// create a new profile in data wedge with the name [profileName]
/// if [autoActivate] is true, current app is added as an activation app
/// to the profile.
Future<void> createProfile(
  String profileName, {
  bool autoActivate = true,
}) async {
```

## Function Design

**Size:** Functions are generally concise (10-40 lines), with single responsibility
- `createProfile()`: 27 lines - creates profile and optionally configures it
- `_setAllDecoders()`: 12 lines - iterates decoders, applies setting, handles failures
- `enableAllDecoders()` and `disableAllDecoders()`: 2 lines each - delegate to `_setAllDecoders()`

**Parameters:**
- Named parameters for clarity, especially booleans: `{required bool on}`, `{bool autoActivate = true}`
- Type annotations required on all parameters: `String profileName`, `bool enabled`, `String profileName`
- Required keyword used for non-optional parameters: `required String profileName`
- Optional parameters given defaults: `bool autoActivate = true`

**Return Values:**
- Explicit return types for all functions: `Future<void>`, `Future<String>`, `Future<List<Decoder>>`, `Stream<ScanEvent>`
- Early returns used (implicit with getters): `Stream<ScanEvent> get scans => _scanEvents.stream;`
- Futures and Streams used for async operations and event streams

**Example from `lib/src/flutter_datawedge.dart`:**
```dart
Future<void> createProfile(
  String profileName, {
  bool autoActivate = true,
}) async {
  assert(profileName.isNotEmpty, 'Profile name cannot be empty');

  await _hostApi.createProfile(profileName);

  if (autoActivate) {
    // ... configuration
  }
}
```

## Module Design

**Exports:**
- Barrel file pattern: `lib/flutter_datawedge.dart` exports public API
```dart
export 'src/decoder_all.dart';
export 'src/flutter_datawedge.dart';
export 'src/pigeon.dart';
```
- Consumers import from package root: `import 'package:flutter_datawedge/flutter_datawedge.dart'`
- Internal modules (models, pigeon generated) not directly exported but re-exported through barrel

**Barrel Files:**
- Used to aggregate public API at package root
- Simplifies consumer imports (one import instead of multiple)
- Internal modules in `src/` directory kept private but accessible through barrel exports

**Data Classes and Freezed:**
- Models use Freezed for immutability: `ScanResult`, `ActionResult`, `ScannerStatus`
- JSON serialization via `json_serializable`: `.g.dart` files auto-generated
- Named constructors for alternate construction: `factory ScanResult.fromJson(Map<String, dynamic> json)`
- Computed properties supported via `const ActionResult._()`: `bool get success => result == 'SUCCESS'`

---

*Convention analysis: 2026-03-21*
