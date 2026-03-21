# flutter_datawedge Upgrade

## What This Is

A Flutter plugin for communicating with Zebra DataWedge barcode scanners via the DataWedge Intent API. This is a maintained fork consumed internally via git dependencies. The project needs its dependencies modernized to latest stable versions, Android SDK targets updated, and a GitHub Actions CI/CD pipeline added with automated semantic versioning via mtrust-api-guard.

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

### Active

- [ ] Bump all Dart/Flutter dependencies to latest stable versions (Pigeon, Freezed, etc.)
- [ ] Update Android SDK targets (compileSdk, Kotlin version, Gradle)
- [ ] Add GitHub Actions CI pipeline with analyze/lint step
- [ ] Integrate mtrust-api-guard for automated semantic versioning
- [ ] Add a minimal passing test as placeholder for future test coverage
- [ ] Regenerate Pigeon platform channel code with updated Pigeon version
- [ ] Regenerate Freezed models with updated Freezed version
- [ ] Verify example app builds successfully with updated dependencies

### Out of Scope

- Full test suite — deferred, placeholder test only for now
- iOS support — Android-only plugin by design
- Publishing to pub.dev — consumed via git dependencies
- Changelog automation beyond what mtrust-api-guard provides — keep it simple

## Context

- Fork of [circus-kitchens/flutter_datawedge](https://github.com/circus-kitchens/flutter_datawedge), changes never upstreamed
- Currently at v3.0.0 with Dart SDK >=3.0.0 <4.0.0, Flutter >=3.13.1
- Pigeon 26.2.3, Freezed 3.2.5, compileSdk 34, Kotlin 1.7.10
- No existing CI/CD pipeline — all builds and checks are manual
- No existing test suite
- Consumed by internal projects via git dependency in pubspec.yaml

## Constraints

- **Platform**: Android-only — no iOS implementation exists or is planned
- **Compatibility**: Must remain compatible with Zebra DataWedge Intent API
- **Consumption**: Package installed via git URL, not pub.dev — versioning via git tags
- **Code generation**: Pigeon and Freezed upgrades require regeneration of generated files

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Use mtrust-api-guard for versioning | Automates semver based on API change detection, fits Dart/Flutter ecosystem | — Pending |
| Bump to latest stable across the board | Maximize maintainability, avoid incremental upgrade pain later | — Pending |
| GitHub Actions for CI | Already using GitHub for hosting, natural fit | — Pending |
| Placeholder test only | No existing tests, full suite is separate effort | — Pending |

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
*Last updated: 2026-03-21 after initialization*
