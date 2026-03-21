# External Integrations

**Analysis Date:** 2026-03-21

## APIs & External Services

**Zebra DataWedge Scanner SDK:**
- Zebra DataWedge Intent API - Barcode scanning and device configuration on Zebra mobile devices
  - SDK/Client: Native Android Broadcast Intent receiver
  - Integration: Intent-based protocol via `DWInterface` at `android/src/main/kotlin/com/circuskitchens/flutter_datawedge/DWInterface.kt`
  - Documentation reference: https://techdocs.zebra.com/datawedge/13-0/guide/api/setconfig/

## Data Storage

**Databases:**
- Not used - This is a platform channel plugin without persistent data requirements

**File Storage:**
- Local filesystem only - Configuration and scan data handled in-memory

**Caching:**
- None

## Authentication & Identity

**Auth Provider:**
- Custom - No external authentication required
- Package identification via Android Context: `getPackageIdentifer()` method returns application package name

## Platform Channel Communication

**Bidirectional Communication:**
- Dart ↔ Kotlin via Pigeon-generated platform channels
- Message channel codec: Custom `_PigeonCodec` extending `StandardMessageCodec`

**Android Broadcast Receiver:**
- Intent filtering for DataWedge broadcasts from `android/src/main/kotlin/com/circuskitchens/flutter_datawedge/DWInterface.kt`
- Receives scan results, status changes, profile changes, and config updates
- Broadcasts forwarded to Dart via `DataWedgeFlutterApi` callback interface

**Basic Message Channels:**
- `dev.flutter.pigeon.flutter_datawedge.DataWedgeFlutterApi.onScannerStatusChanged` - Status updates
- `dev.flutter.pigeon.flutter_datawedge.DataWedgeFlutterApi.onScanResult` - Scan data delivery
- `dev.flutter.pigeon.flutter_datawedge.DataWedgeFlutterApi.onProfileChange` - Profile change notifications
- `dev.flutter.pigeon.flutter_datawedge.DataWedgeFlutterApi.onConfigUpdate` - Configuration change notifications

## Android Intent System Integration

**Broadcast Receivers:**
- Registered dynamically via `setupBroadcastReceiver()` in `DWInterface`
- Receives DataWedge Intent broadcasts with action patterns matching barcode scanner output

**Intent Configuration:**
- Profile configuration includes intent delivery method (startActivity, startService, or broadcast)
- Intent action customizable via `PluginIntentParamters.intentAction` in profile config
- Intent category customizable via `PluginIntentParamters.intentCategory`

**Scanner Control Intents:**
- Plugin control: suspend, resume, enable, disable operations via DataWedge control intents
- Soft trigger support for programmatic scan activation

## Monitoring & Observability

**Error Tracking:**
- None - No external error tracking service integrated

**Logs:**
- Console logging via `mason_logger` at `lib/logger.dart`
- Android logging via `android.util.Log` in Kotlin implementation
- Log levels: debug, info for development visibility

## CI/CD & Deployment

**Hosting:**
- pub.dev - Dart/Flutter package repository (from pubspec.yaml homepage)

**CI Pipeline:**
- GitHub Actions workflows in `.github/workflows/`
  - `publish-to-pub.dev.yml` - Package publication workflow
  - `pull_request.yml` - PR validation workflow
- Dependabot configuration in `.github/dependabot.yml`

**Package Information:**
- Repository: https://github.com/circus-kitchens/flutter_datawedge
- Version: 3.0.0
- Package name: `flutter_datawedge` (Dart/Flutter)
- Android plugin package: `com.circuskitchens.flutter_datawedge`

## Environment Configuration

**Required env vars:**
- None required for runtime
- CI/CD may require Pub authentication token for automated publishing (handled via secrets)

**Secrets location:**
- GitHub Actions secrets (for pub.dev publishing credentials)
- Not committed to repository

## Generated Protocol Definitions

**Pigeon Interface:**
- Definition source: `pigeons/datawedge_pigeon.dart`
- Generated Dart code: `lib/src/pigeon.dart`
- Generated Kotlin code: `android/src/main/kotlin/com/circuskitchens/flutter_datawedge/pigeon/Pigeon.kt`
- Generation script: `generate.sh` (runs `flutter pub run pigeon`)

**Platform Channel APIs:**

**Host API (Dart → Kotlin):**
- `createProfile(String profileName)` - Create scanner profile
- `registerForNotifications()` - Enable event listening
- `unregisterForNotifications()` - Disable event listening
- `suspendPlugin()` - Pause DataWedge plugin
- `resumePlugin()` - Resume DataWedge plugin
- `enablePlugin()` - Enable DataWedge plugin
- `disablePlugin()` - Disable DataWedge plugin
- `softScanTrigger(bool on)` - Activate/deactivate software trigger
- `getPackageIdentifer()` - Get app package name
- `setDecoder(Decoder decoder, bool enabled, String profileName)` - Configure decoders
- `setProfileConfig(ProfileConfig config)` - Apply profile configuration

**Flutter Callback API (Kotlin → Dart):**
- `onScannerStatusChanged(StatusChangeEvent statusEvent)` - Scanner state changes
- `onScanResult(ScanEvent scanEvent)` - Barcode scan data received
- `onProfileChange()` - DataWedge profile changed
- `onConfigUpdate()` - Configuration updated

## Data Models

**Scan Data:**
- `ScanEvent` - Contains decoded barcode label type, source, data string, binary decode data, and decode mode
- Supported decoders: 44+ barcode formats (Code39, Code128, QR, PDF417, DataMatrix, UPC/EAN, etc.)

**Device Status:**
- `StatusChangeEvent` - Scanner state: waiting, scanning, idle, connected, disconnected, disabled

**Configuration:**
- `ProfileConfig` - Scanner profile with name, mode (create/overwrite/update), barcode parameters, intent parameters, app associations
- `PluginBarcodeParamters` - 97+ configurable barcode scanner parameters
- `PluginIntentParamters` - Intent delivery configuration (action, category, delivery method, content provider usage)

---

*Integration audit: 2026-03-21*
