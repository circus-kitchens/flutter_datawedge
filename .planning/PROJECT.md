# flutter_datawedge Upgrade

## What This Is

A Flutter plugin for communicating with Zebra DataWedge barcode scanners via the DataWedge Intent API. This is a maintained fork consumed internally via git dependencies, now with modernized toolchains, automated CI, and semantic release automation via mtrust-api-guard.

## Core Value

The plugin must reliably bridge Flutter apps to Zebra DataWedge scanners with type-safe platform channels — all upgrades must preserve this functionality.

## Requirements

### Validated

- ✓ Scan event streaming from DataWedge to Flutter via broadcast streams — existing
- ✓ Profile creation and configuration via Intent API — existing
- ✓ Decoder management (enable/disable individual and all decoders) — existing
- ✓ Scanner status change event streaming — existing
- ✓ Type-safe Dart-Kotlin communication via Pigeon-generated platform channels — existing
- ✓ Singleton API surface via `FlutterDataWedge.instance` — existing
- ✓ Immutable data models via Freezed code generation — existing
- ✓ Custom exception hierarchy for error handling — existing
- ✓ Bump all Dart/Flutter dependencies to latest stable versions — v3.1.0
- ✓ Update Android SDK targets (compileSdk 36, Kotlin 2.3.20, Gradle 9.4.1) — v3.1.0
- ✓ Add GitHub Actions CI pipeline with lint, android-build, and test gates — v3.1.0
- ✓ Integrate mtrust-api-guard for automated semantic versioning — v3.1.0
- ✓ Add a minimal passing test as placeholder for future test coverage — v3.1.0
- ✓ Regenerate Pigeon platform channel code with updated Pigeon version — v3.1.0
- ✓ Regenerate Freezed models with updated Freezed version — v3.1.0
- ✓ Verify example app builds successfully with updated dependencies — v3.1.0

### Active

(None — next milestone requirements to be defined)

### Out of Scope

- Full test suite — deferred, placeholder test only for now
- iOS support — Android-only plugin by design
- Publishing to pub.dev — consumed via git dependencies
- Changelog automation beyond what mtrust-api-guard provides — keep it simple

## Context

- Fork of [circus-kitchens/flutter_datawedge](https://github.com/circus-kitchens/flutter_datawedge), changes never upstreamed
- Shipped v3.1.0 with Dart SDK >=3.11.0 <4.0.0, Flutter >=3.41.0
- Pigeon 26.2.3, Freezed 3.2.5, compileSdk 36, Kotlin 2.3.20, Gradle 9.4.1
- GitHub Actions CI: 3-job PR workflow (lint, android-build, test) + 4-job release workflow (mtrust-api-guard)
- Placeholder test suite (1 test)
- Consumed by internal projects via git dependency in pubspec.yaml

## Constraints

- **Platform**: Android-only — no iOS implementation exists or is planned
- **Compatibility**: Must remain compatible with Zebra DataWedge Intent API
- **Consumption**: Package installed via git URL, not pub.dev — versioning via git tags
- **Code generation**: Pigeon and Freezed upgrades require regeneration of generated files

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Use mtrust-api-guard for versioning | Automates semver based on API change detection, fits Dart/Flutter ecosystem | ✓ Shipped v3.1.0 |
| Bump to latest stable across the board | Maximize maintainability, avoid incremental upgrade pain later | ✓ Shipped v3.1.0 |
| GitHub Actions for CI | Already using GitHub for hosting, natural fit | ✓ Shipped v3.1.0 |
| Placeholder test only | No existing tests, full suite is separate effort | ✓ Shipped v3.1.0 |
| Gradle Kotlin DSL migration | Modern build config, better IDE support, aligns with Flutter template | ✓ Shipped v3.1.0 |
| v3.0.0 baseline tag on original fork | Phase 1 infrastructure captured in first automated release | ✓ Shipped v3.1.0 |
| Release on push to main + manual fallback | Fully automated releases with workflow_dispatch safety net | ✓ Shipped v3.1.0 |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd:transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd:complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-03-21 after v3.1.0 milestone*
