# Requirements: flutter_datawedge Upgrade

**Defined:** 2026-03-21
**Core Value:** The plugin must reliably bridge Flutter apps to Zebra DataWedge scanners with type-safe platform channels

## v1 Requirements

Requirements for this upgrade milestone. Each maps to roadmap phases.

### Dart/Flutter SDK

- [x] **SDK-01**: Dart SDK constraint updated to >=3.11.0 <4.0.0
- [x] **SDK-02**: Flutter SDK constraint updated to >=3.41.0
- [x] **SDK-03**: All transitive dependencies bumped to latest stable (async, collection, stream_transform, freezed_annotation, json_annotation, mason_logger, strict_json, freezed_result)
- [x] **SDK-04**: Dev dependencies bumped to latest stable (build_runner, freezed, json_serializable, lints, pigeon, very_good_analysis)

### Android Platform

- [x] **AND-01**: Android compileSdk updated to 36
- [x] **AND-02**: Kotlin version updated to 2.3.20
- [x] **AND-03**: Gradle updated to 9.4.1 with compatible Android Gradle Plugin
- [x] **AND-04**: Example app Android configuration updated to match plugin targets

### Code Generation

- [x] **GEN-01**: Pigeon platform channel code regenerated for both Dart and Kotlin
- [x] **GEN-02**: Freezed data models regenerated with updated build_runner/freezed
- [x] **GEN-03**: Generated code compiles without errors on both Dart and Kotlin sides
- [x] **GEN-04**: Plugin example app builds and runs successfully after regeneration

### CI Pipeline

- [x] **CI-01**: GitHub Actions PR workflow runs dart analyze on pull requests
- [x] **CI-02**: GitHub Actions PR workflow runs dart format check on pull requests
- [x] **CI-03**: GitHub Actions PR workflow runs lint rules on pull requests
- [x] **CI-04**: GitHub Actions PR workflow verifies Android build compiles
- [x] **CI-05**: GitHub Actions PR workflow runs flutter test (placeholder test passes)

### Automated Versioning

- [x] **VER-01**: mtrust-api-guard integrated into GitHub Actions release workflow
- [x] **VER-02**: Semantic version bumped automatically based on API change detection
- [x] **VER-03**: Changelog generated automatically from API diffs
- [x] **VER-04**: Git tags created automatically on version bump

### Testing

- [x] **TST-01**: Placeholder test file exists and passes with flutter test
- [x] **TST-02**: Test execution gate exists in CI pipeline for future test additions

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Testing Coverage

- **TST-03**: Unit tests for FlutterDataWedge API methods
- **TST-04**: Integration tests for platform channel communication
- **TST-05**: Code coverage tracking and reporting in CI

### CI Enhancements

- **CI-06**: Multi-version Flutter/Dart testing matrix
- **CI-07**: Performance benchmarking for platform channel latency
- **CI-08**: Security scanning (OSSF scorecard)

## Out of Scope

| Feature | Reason |
|---------|--------|
| iOS CI/CD pipeline | Plugin is Android-only by design |
| pub.dev auto-publishing | Package consumed via git dependencies, not pub.dev |
| Full integration test suite | Explicit deferral — placeholder only for now |
| Complex release notes templating | mtrust-api-guard changelog is sufficient |
| Multi-branch release workflows | Single release path from main keeps things simple |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| SDK-01 | 1 | Complete |
| SDK-02 | 1 | Complete |
| SDK-03 | 1 | Complete |
| SDK-04 | 1 | Complete |
| AND-01 | 1 | Complete |
| AND-02 | 1 | Complete |
| AND-03 | 1 | Complete |
| AND-04 | 1 | Complete |
| GEN-01 | 1 | Complete |
| GEN-02 | 1 | Complete |
| GEN-03 | 1 | Complete |
| GEN-04 | 1 | Complete |
| CI-01 | 1 | Complete |
| CI-02 | 1 | Complete |
| CI-03 | 1 | Complete |
| CI-04 | 1 | Complete |
| CI-05 | 1 | Complete |
| TST-01 | 1 | Complete |
| TST-02 | 1 | Complete |
| VER-01 | 2 | Complete |
| VER-02 | 2 | Complete |
| VER-03 | 2 | Complete |
| VER-04 | 2 | Complete |

**Coverage:**
- v1 requirements: 23 total
- Mapped to phases: 23
- Unmapped: 0

---

*Requirements defined: 2026-03-21*
*Traceability updated: 2026-03-21 after roadmap creation*
