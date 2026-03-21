---
phase: 01-dependency-modernization-android-build-verification
plan: 02
subsystem: android
tags: [kotlin-dsl, gradle, pigeon, freezed, android, build-system]

# Dependency graph
requires:
  - phase: 01-01
    provides: Updated pubspec.yaml with Pigeon 26.2.3 and Freezed 3.2.5 dependencies
provides:
  - android/build.gradle.kts (Kotlin DSL library module with compileSdk 36, Kotlin 2.3.20)
  - android/gradle/wrapper/gradle-wrapper.properties (Gradle 9.4.1)
  - example/android/settings.gradle.kts (AGP 8.7.3, Kotlin 2.3.20)
  - generate.sh (modern Pigeon CLI: dart run pigeon)
  - lib/src/pigeon.dart (regenerated Dart platform channel code)
  - android/.../pigeon/Pigeon.kt (regenerated Kotlin platform channel code)
  - Kotlin source files updated for new Pigeon enum naming conventions
affects: [01-03-CI-setup, release-automation]

# Tech tracking
tech-stack:
  added:
    - Gradle 9.4.1 (plugin wrapper)
    - Kotlin 2.3.20 (Android plugin)
    - AGP 8.7.3 (Android Gradle Plugin)
  patterns:
    - Kotlin DSL for Android build configuration (build.gradle.kts)
    - compilerOptions DSL for jvmTarget (replaces deprecated kotlinOptions)
    - abstract class modifier on Freezed models (Freezed 3.x pattern)

key-files:
  created:
    - android/build.gradle.kts
  modified:
    - android/gradle/wrapper/gradle-wrapper.properties
    - example/android/settings.gradle.kts
    - example/android/app/build.gradle.kts
    - generate.sh
    - lib/src/pigeon.dart
    - android/src/main/kotlin/com/circuskitchens/flutter_datawedge/pigeon/Pigeon.kt
    - android/src/main/kotlin/com/circuskitchens/flutter_datawedge/BuildBarcodeConfig.kt
    - android/src/main/kotlin/com/circuskitchens/flutter_datawedge/BuildIntentConfig.kt
    - android/src/main/kotlin/com/circuskitchens/flutter_datawedge/ConvertLabelType.kt
    - android/src/main/kotlin/com/circuskitchens/flutter_datawedge/DWInterface.kt
    - android/src/main/kotlin/com/circuskitchens/flutter_datawedge/Decoders.kt
    - lib/src/flutter_datawedge.dart
    - lib/src/models/action_result.dart
    - lib/src/models/scan_result.dart
    - lib/src/models/scanner_status.dart

key-decisions:
  - "android/build.gradle.kts is a library module build file (not root multi-project) since android/settings.gradle defines only the root project"
  - "Removed version declarations from android/build.gradle.kts plugins block — AGP and Kotlin versions sourced from example app settings.gradle.kts to avoid classpath conflict"
  - "Freezed 3.x requires abstract class modifier on user-defined model classes"
  - "Pigeon 26.x changed enum naming from compact (AUSTRALIANPOSTAL) to SCREAMING_SNAKE_CASE (AUSTRALIAN_POSTAL)"
  - "Pigeon 26.x changed FlutterApi callback signatures from () -> Unit to (Result<Unit>) -> Unit"
  - "Pigeon 26.x renamed DataWedgeFlutterApi.setup() to DataWedgeFlutterApi.setUp()"

patterns-established:
  - "Kotlin DSL: use kotlin { compilerOptions { jvmTarget = JvmTarget.JVM_11 } } (not kotlinOptions)"
  - "Freezed 3.x pattern: abstract class ModelName with _$ModelName"
  - "Pigeon FlutterApi callbacks: { _ -> } pattern for ignored Result<Unit>"

requirements-completed: [AND-01, AND-02, AND-03, AND-04, GEN-01, GEN-02, GEN-03, GEN-04]

# Metrics
duration: 14min
completed: 2026-03-21
---

# Phase 01 Plan 02: Android Build Modernization Summary

**Kotlin DSL migration with Gradle 9.4.1 and compileSdk 36; regenerated Pigeon/Freezed with all Kotlin enum and API compatibility fixes for successful Android debug build**

## Performance

- **Duration:** ~14 min
- **Started:** 2026-03-21T13:48:59Z
- **Completed:** 2026-03-21T14:03:03Z
- **Tasks:** 2
- **Files modified:** 23

## Accomplishments

- Migrated android/build.gradle (Groovy DSL) to android/build.gradle.kts (Kotlin DSL) with compileSdk 36 and Kotlin 2.3.20
- Updated Gradle wrapper to 9.4.1, example app settings to AGP 8.7.3 and Kotlin 2.3.20
- Rewrote generate.sh to use modern `dart run pigeon` CLI (removed deprecated `--experimental_kotlin_out` and `flutter pub run` syntax)
- Regenerated lib/src/pigeon.dart and Pigeon.kt with Pigeon 26.2.3
- Regenerated all Freezed models (.freezed.dart and .g.dart files)
- Fixed all Kotlin compilation errors from Pigeon API changes (enum renaming, callback signatures, API method renames)
- Android debug build confirmed: BUILD SUCCESSFUL in 51s

## Task Commits

1. **Task 1: Migrate android/build.gradle to Kotlin DSL** - `50a90bf` (feat)
2. **Task 2: Update generate.sh and regenerate Pigeon/Freezed** - `83f7ab9` (feat)

## Files Created/Modified

- `android/build.gradle.kts` - New Kotlin DSL library module build file (compileSdk 36, Kotlin 2.3.20)
- `android/build.gradle` - DELETED (replaced by Kotlin DSL)
- `android/gradle/wrapper/gradle-wrapper.properties` - Gradle 9.4.1
- `example/android/settings.gradle.kts` - AGP 8.7.3, Kotlin 2.3.20
- `example/android/app/build.gradle.kts` - kotlinOptions -> compilerOptions DSL
- `generate.sh` - Modern `dart run pigeon` CLI syntax
- `lib/src/pigeon.dart` - Regenerated Dart platform channel code
- `android/src/main/kotlin/.../pigeon/Pigeon.kt` - Regenerated Kotlin platform channel code
- `android/src/main/kotlin/.../BuildBarcodeConfig.kt` - Updated for new Pigeon enum names
- `android/src/main/kotlin/.../BuildIntentConfig.kt` - Updated IntentDelivery enum names
- `android/src/main/kotlin/.../ConvertLabelType.kt` - Updated LabelType enum names
- `android/src/main/kotlin/.../DWInterface.kt` - ConfigMode enum fix, callback signatures
- `android/src/main/kotlin/.../Decoders.kt` - Updated Decoder enum names
- `lib/src/flutter_datawedge.dart` - DataWedgeFlutterApi.setUp (was .setup)
- `lib/src/models/action_result.dart` - Added abstract keyword (Freezed 3.x)
- `lib/src/models/scan_result.dart` - Added abstract keyword (Freezed 3.x)
- `lib/src/models/scanner_status.dart` - Added abstract keyword (Freezed 3.x)
- `lib/src/models/*.freezed.dart` - Regenerated Freezed code
- `lib/src/models/*.g.dart` - Regenerated JSON serialization code
- `example/test/widget_test.dart` - Removed const from non-const MyApp constructor

## Decisions Made

- Used library-module pattern for android/build.gradle.kts (not root multi-project) because android/settings.gradle defines only one project
- Removed plugin version declarations from android/build.gradle.kts to prevent classpath conflict when consumed by the example app's Gradle build
- Accepted Gradle 8.10.2 from example app (not 9.4.1) since example has its own wrapper; the plugin's gradle wrapper (9.4.1) would be used for standalone plugin builds

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed Kotlin DSL syntax errors in android/build.gradle.kts**
- **Found during:** Task 1 (build.gradle Kotlin DSL migration)
- **Issue:** Plan's suggested content had `apply false` pattern and subproject references incompatible with the single-module Flutter plugin structure; Groovy-specific `hasProperty` and `outputs` API not available in Kotlin DSL
- **Fix:** Rewrote as proper library module build file (applying plugins directly, not with `apply false`); removed `hasProperty` check; migrated to `compilerOptions` DSL for jvmTarget
- **Files modified:** android/build.gradle.kts
- **Verification:** Android debug build succeeds
- **Committed in:** 83f7ab9 (Task 2 commit)

**2. [Rule 1 - Bug] Fixed DataWedgeFlutterApi.setup -> setUp rename**
- **Found during:** Task 2 (Pigeon regeneration)
- **Issue:** Pigeon 26.x renamed `DataWedgeFlutterApi.setup()` to `DataWedgeFlutterApi.setUp()`
- **Fix:** Updated call in lib/src/flutter_datawedge.dart
- **Files modified:** lib/src/flutter_datawedge.dart
- **Verification:** dart analyze passes (no errors)
- **Committed in:** 83f7ab9 (Task 2 commit)

**3. [Rule 1 - Bug] Added abstract keyword to Freezed model classes**
- **Found during:** Task 2 (Freezed regeneration)
- **Issue:** Freezed 3.x generates mixin `_$ModelName` with abstract `toJson()` method; the concrete class must be abstract to compile
- **Fix:** Added `abstract` keyword to ActionResult, ScanResult, ScannerStatus class declarations
- **Files modified:** lib/src/models/action_result.dart, scan_result.dart, scanner_status.dart
- **Verification:** dart analyze passes (no errors), Freezed regenerated successfully
- **Committed in:** 83f7ab9 (Task 2 commit)

**4. [Rule 1 - Bug] Fixed Pigeon enum SCREAMING_SNAKE_CASE naming across Kotlin source**
- **Found during:** Task 2 (Android compilation)
- **Issue:** Pigeon 26.x changed enum value names from compact SCREAMING_CASE (AUSTRALIANPOSTAL) to SCREAMING_SNAKE_CASE (AUSTRALIAN_POSTAL); 20+ enum values in 5 Kotlin files needed updating
- **Fix:** Updated all enum references in BuildBarcodeConfig.kt, BuildIntentConfig.kt, ConvertLabelType.kt, DWInterface.kt, Decoders.kt
- **Files modified:** All 5 Kotlin source files
- **Verification:** Android build succeeds (BUILD SUCCESSFUL in 51s)
- **Committed in:** 83f7ab9 (Task 2 commit)

**5. [Rule 1 - Bug] Fixed Pigeon FlutterApi callback signature change**
- **Found during:** Task 2 (Android compilation)
- **Issue:** Pigeon 26.x changed FlutterApi callback signatures from `() -> Unit` to `(Result<Unit>) -> Unit`
- **Fix:** Updated DWInterface.kt callback lambdas from `{ -> }` / `{ }` to `{ _ -> }`
- **Files modified:** android/src/main/kotlin/.../DWInterface.kt
- **Verification:** Android build succeeds
- **Committed in:** 83f7ab9 (Task 2 commit)

**6. [Rule 1 - Bug] Fixed example/android/app/build.gradle.kts kotlinOptions deprecation**
- **Found during:** Task 2 (Android compilation)
- **Issue:** Kotlin 2.x + AGP 8.7.3 treats `kotlinOptions.jvmTarget = String` as an error
- **Fix:** Migrated to `kotlin { compilerOptions { jvmTarget = JvmTarget.JVM_11 } }`
- **Files modified:** example/android/app/build.gradle.kts
- **Verification:** Android build succeeds
- **Committed in:** 83f7ab9 (Task 2 commit)

**7. [Rule 1 - Bug] Fixed const_with_non_const in example/test/widget_test.dart**
- **Found during:** Task 2 (dart analyze)
- **Issue:** `const MyApp()` where MyApp is a StatefulWidget (not const-constructible)
- **Fix:** Removed `const` from the call site
- **Files modified:** example/test/widget_test.dart
- **Verification:** dart analyze passes (no errors)
- **Committed in:** 83f7ab9 (Task 2 commit)

---

**Total deviations:** 7 auto-fixed (all Rule 1 bugs caused by Pigeon/Kotlin API changes)
**Impact on plan:** All fixes required for correctness — directly caused by the Kotlin DSL migration and Pigeon regeneration that was the plan's goal. No scope creep.

## Issues Encountered

- android/build.gradle.kts initially structured as root multi-project file per plan template, but the Flutter plugin `android/` directory is a single-module project; resolved by using library module pattern directly
- Pigeon 26.x has more extensive enum renaming than expected (both SCREAMING_SNAKE_CASE change and API method renames) — fixed across all affected files

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Android build modernization complete: Kotlin DSL, Gradle 9.4.1 (plugin wrapper), compileSdk 36, Kotlin 2.3.20
- All generated code (Pigeon, Freezed) is current and compiles successfully
- dart analyze passes (warnings only in generated files, no errors)
- Android debug build confirmed passing
- Plan 03 (CI/CD setup) can proceed

---
*Phase: 01-dependency-modernization-android-build-verification*
*Completed: 2026-03-21*
