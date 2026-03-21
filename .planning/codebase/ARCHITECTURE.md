# Architecture

**Analysis Date:** 2026-03-21

## Pattern Overview

**Overall:** Bridge Pattern + Singleton with Platform Channels

The flutter_datawedge package implements a **platform-specific bridge architecture** where Flutter communicates with Zebra DataWedge on Android via Pigeon-generated platform channels. The design uses a singleton pattern for the main API surface and streams for event propagation.

**Key Characteristics:**
- Singleton pattern for stateless API access via `FlutterDataWedge.instance`
- Platform channel communication using **Pigeon** for type-safe Dart-Kotlin interop
- Broadcast streams for decoupled event delivery (scans and status changes)
- Configuration-driven scanner setup through nested data classes
- Android-only implementation (no iOS support)

## Layers

**Dart API Layer:**
- Purpose: Exposes high-level API to Flutter applications
- Location: `lib/src/flutter_datawedge.dart`
- Contains: Main `FlutterDataWedge` class with profile management, decoder control, and plugin state methods
- Depends on: Pigeon-generated APIs, StreamController, Logger
- Used by: Flutter application code

**Pigeon Bridge Layer:**
- Purpose: Type-safe bidirectional communication between Dart and Kotlin
- Location: `lib/src/pigeon.dart` (generated from `pigeons/datawedge_pigeon.dart`)
- Contains: Auto-generated `DataWedgeHostApi` and `DataWedgeFlutterApi` classes, all DTOs and enums
- Depends on: Flutter platform channels
- Used by: Flutter API layer and Android platform layer

**Android Platform Layer:**
- Purpose: Native Android implementation interfacing with DataWedge Intent API
- Location: `android/src/main/kotlin/com/circuskitchens/flutter_datawedge/`
- Contains:
  - `FlutterDatawedgePlugin.kt`: Plugin lifecycle management
  - `DWInterface.kt`: BroadcastReceiver that handles DataWedge intents
  - Helper files: `BuildBarcodeConfig.kt`, `BuildIntentConfig.kt`, `BundleUtils.kt`, etc.
- Depends on: Android Intent system, Pigeon-generated Kotlin code
- Used by: Flutter runtime via platform channels

**Data Model Layer:**
- Purpose: Immutable data classes for events and configuration
- Location: `lib/src/models/` and Pigeon enums
- Contains:
  - `ScanResult` / `ScanEvent`: Barcode scan data
  - `ScannerStatus` / `StatusChangeEvent`: Device state
  - `ActionResult`: API response status
  - Nested configuration classes: `ProfileConfig`, `PluginBarcodeParamters`, `PluginIntentParamters`
- Depends on: Freezed annotations for code generation
- Used by: All layers

**Logging Layer:**
- Purpose: Structured logging with severity levels
- Location: `lib/logger.dart`
- Contains: `Logger` class with severity filtering and `LogMessage` records
- Depends on: Flutter Foundation
- Used by: Flutter API layer for debug output

## Data Flow

**Scan Event Flow (From Scanner to Listener):**

1. Zebra device scans barcode, DataWedge broadcasts Intent
2. `DWInterface.onReceive()` intercepts the Intent in Android
3. Intent data parsed from extras (source, labelType, dataString, decodeData)
4. `ScanEvent` object created and sent to Dart via `DataWedgeFlutterApi.onScanResult()`
5. Dart callback in `FlutterDataWedge.onScanResult()` adds event to `_scanEvents` stream
6. App code listening on `FlutterDataWedge.instance.scans` receives the event

**Configuration Flow (From App to DataWedge):**

1. App calls `FlutterDataWedge.instance.setConfig(ProfileConfig)`
2. Dart method calls `DataWedgeHostApi.setProfileConfig()` via Pigeon
3. Kotlin `DWInterface.setProfileConfig()` receives the call
4. Nested configuration builders create Android Bundles:
   - `buildBarcodeConfig()` for barcode scanner settings
   - `buildIntentConfig()` for intent output configuration
5. Intent sent to DataWedge with bundle via `sendBroadcast()`
6. DataWedge applies configuration and sends result Intent back
7. Result intercepted in `onReceive()` and forwarded to listeners

**State Management:**

- **Scan Stream**: `StreamController<ScanEvent>.broadcast()` - Multi-listener support
- **Status Stream**: `StreamController<StatusChangeEvent>.broadcast()` - Multi-listener support
- **Singleton State**: `_flutterDataWedge` static instance ensures one active receiver
- **Callbacks Map**: `DWInterface.callbacks` HashMap stores pending command responses keyed by command identifier

## Key Abstractions

**FlutterDataWedge (Main Facade):**
- Purpose: Single entry point for all DataWedge operations
- Examples: `lib/src/flutter_datawedge.dart`
- Pattern: Singleton with assertion in constructor to prevent multiple instances
- Exposes: Profile creation, decoder management, plugin state, scan/status streams

**ProfileConfig (Configuration Builder):**
- Purpose: Fluent-style hierarchical configuration for scanner profiles
- Examples: Used in `lib/src/pigeon.dart` (generated)
- Pattern: Nested nullable configuration classes (`PluginBarcodeParamters`, `PluginIntentParamters`)
- Mapping: Kotlin builders convert to Android Bundles matching DataWedge Intent schema

**ScanEvent (Domain Model):**
- Purpose: Immutable representation of barcode scan data
- Examples: `lib/src/models/` (defined in Pigeon, maps from Android Intent extras)
- Pattern: Immutable class with JSON serialization, includes labelType, source, dataString, decodeData
- Usage: Streamed to listeners as events occur

**DWInterface (Platform Adapter):**
- Purpose: Bidirectional bridge between Android Intent system and Dart
- Examples: `android/src/main/kotlin/.../DWInterface.kt`
- Pattern: BroadcastReceiver + HostApi implementation
- Responsibilities: Intent reception, payload parsing, command callback dispatch

## Entry Points

**Dart Entry Point:**
- Location: `lib/flutter_datawedge.dart`
- Triggers: App imports `package:flutter_datawedge`
- Responsibilities: Re-exports public API (decoder_all, flutter_datawedge, pigeon)

**Flutter Plugin Entry Point:**
- Location: `android/src/main/kotlin/.../FlutterDatawedgePlugin.kt`
- Triggers: Flutter engine attachment at app startup
- Responsibilities:
  - Creates `DWInterface` with application context
  - Sets up Pigeon API endpoints
  - Initializes broadcast receiver for DataWedge intents

**Singleton Initialization:**
- Location: `lib/src/flutter_datawedge.dart` constructor and static block
- Triggers: First access to `FlutterDataWedge.instance`
- Responsibilities:
  - Enforces singleton via assertion
  - Calls `DataWedgeFlutterApi.setup(this)` to register Dart-side callbacks
  - Creates host API instance `_hostApi = DataWedgeHostApi()`

## Error Handling

**Strategy:** Exception propagation with semantic custom exceptions for application-level errors

**Patterns:**

- **Custom Exceptions** (`lib/src/models/flutter_datawedge_exception.dart`):
  - `FlutterDatawedgeException`: Base exception with message
  - `NotInitializedException`: Thrown if API called before initialization
  - Assertions in constructors check preconditions (e.g., profile name not empty)

- **Decoder Availability Handling** (`lib/src/flutter_datawedge.dart` lines 84-99):
  - `_setAllDecoders()` catches exceptions for each decoder
  - Logs unavailable decoders as info, continues with others
  - Returns list of successfully enabled decoders

- **Platform Exception Handling**:
  - Pigeon auto-generates exception handling in `pigeon.dart`
  - Android callback failures bubble up as platform exceptions
  - No global try-catch; errors propagate to caller

## Cross-Cutting Concerns

**Logging:**
- Framework: Custom `Logger` class in `lib/logger.dart`
- Output: Dart developer.log() with timestamp and severity
- Usage: `FlutterDataWedge` methods call `logger.debug()` and `logger.info()`
- Severity Levels: debug < info < warning < error (filtered by `logLevel`)

**Validation:**
- Dart-side: Assertions in public methods (e.g., profile name not empty)
- Android-side: Bundle utilities validate enum conversions in `BuildBarcodeConfig.kt`
- Configuration: Nullable fields allow partial configs; DataWedge uses defaults

**Authentication:**
- Strategy: None - Direct Intent API assumes device is authorized
- Profile Activation: `autoActivate=true` auto-registers current app package as activation trigger

**Resource Management:**
- Broadcast Receiver: Registered in `onAttachedToEngine()`, unregistered in `onDetachedFromEngine()`
- Streams: Broadcast streams created as instance fields, never closed by library (app responsibility)
- Platform Channels: Managed by Flutter framework, no explicit cleanup needed

---

*Architecture analysis: 2026-03-21*
