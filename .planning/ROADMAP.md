# Roadmap: flutter_datawedge Upgrade

**Version:** 1.0
**Created:** 2026-03-21
**Phases:** 2
**Granularity:** Coarse (2 phases: core dependency modernization + release automation)
**Coverage:** 23/23 v1 requirements mapped

---

## Phases

- [ ] **Phase 1: Dependency Modernization & Android Build Verification** - Upgrade Dart/Flutter/Android toolchain, regenerate platform code, add Android build CI gate
- [ ] **Phase 2: Release Automation & Semantic Versioning** - Integrate mtrust-api-guard for automated version management and changelog generation

---

## Phase Details

### Phase 1: Dependency Modernization & Android Build Verification

**Goal:** Modernize Dart, Flutter, Android, and Kotlin toolchains to current stable versions; regenerate platform code; add Android build verification to CI so releases are safe.

**Depends on:** Nothing (foundation phase)

**Requirements:** SDK-01, SDK-02, SDK-03, SDK-04, AND-01, AND-02, AND-03, AND-04, GEN-01, GEN-02, GEN-03, GEN-04, CI-01, CI-02, CI-03, CI-04, CI-05, TST-01, TST-02

**Success Criteria** (what must be TRUE when this phase completes):

1. **Dart and Flutter environment constraints updated** - pubspec.yaml declares Dart >=3.11.0 <4.0.0 and Flutter >=3.41.0; developer environment confirms no downgrade conflicts
2. **All Dart dependencies upgraded to latest stable** - pubspec.yaml lists async, collection, stream_transform, freezed_annotation, json_annotation, mason_logger, strict_json at latest published versions; `flutter pub get` succeeds
3. **All dev dependencies upgraded and tools installed** - pubspec.yaml lists build_runner, freezed, json_serializable, lints, pigeon, very_good_analysis at latest; `flutter pub get` succeeds; `pigeon` and `freezed` CLIs available locally
4. **Pigeon platform channel code regenerated** - `./generate.sh` completes without errors; both `lib/src/pigeon.dart` (Dart side) and `android/src/main/kotlin/com/circuskitchens/flutter_datawedge/pigeon/Pigeon.kt` (Kotlin side) are updated to match current Pigeon 26.2.3 output; no manual edits to platform channel interfaces exist outside generated files
5. **Freezed models regenerated** - `./generate.sh` regenerates `lib/src/*.freezed.dart` files without errors; immutable data models match current Freezed 3.2.5 output format
6. **Android compileSdk, Kotlin, and Gradle modernized** - `android/build.gradle.kts` declares compileSdk 36, Kotlin 2.3.20, Gradle 9.4.1 with compatible Android Gradle Plugin; example app `android/settings.gradle.kts` matches plugin versions
7. **Android API guards and flags audited** - Kotlin code checked for Build.VERSION guards on API 34+ features; `registerReceiver()` calls include RECEIVER_EXPORTED flag (Android 13+ requirement); no deprecation warnings from lint checks
8. **Generated code compiles on Kotlin side** - `./gradlew build` succeeds in android directory; no "Unsupported class-file format" or plugin compatibility errors; generated Pigeon.kt has no compilation errors
9. **Example app builds successfully** - `flutter build apk --release` (or equivalent) succeeds on example app; all Dart analysis passes (`dart analyze`); example app APK is generated without build errors
10. **GitHub Actions PR workflow enforces code quality** - `.github/workflows/pull_request.yml` exists and runs dart analyze, dart format check, and lints on pull requests; PR cannot merge if any check fails
11. **Android build verification gate active in CI** - `.github/workflows/pull_request.yml` includes `flutter build apk` step for example app; PR cannot merge if Android build fails; Kotlin compilation errors surface in GitHub UI
12. **Test placeholder exists and passes in CI** - `test/flutter_datawedge_test.dart` exists with at least one passing test; `flutter test` executes in CI workflow and passes; test gate blocks PR merge if any test fails

**Plans:** 3 plans

Plans:
- [ ] 01-01-PLAN.md — Update pubspec.yaml SDK constraints and all dependency versions
- [ ] 01-02-PLAN.md — Migrate android/build.gradle to Kotlin DSL, update Gradle 9.4.1 and Kotlin 2.3.20, update generate.sh, regenerate Pigeon and Freezed code
- [ ] 01-03-PLAN.md — Extend pull_request.yml with Android build and test jobs; create placeholder test; remove pub.dev publish workflow

---

### Phase 2: Release Automation & Semantic Versioning

**Goal:** Automate semantic version bumping, changelog generation, and git tagging via mtrust-api-guard so releases are deterministic and repeatable.

**Depends on:** Phase 1 (Android build verification must be proven working before release automation)

**Requirements:** VER-01, VER-02, VER-03, VER-04

**Success Criteria** (what must be TRUE when this phase completes):

1. **mtrust-api-guard integrated as dev dependency** - pubspec.yaml lists mtrust_api_guard as dev dependency at version 6.0.4; `flutter pub global activate mtrust_api_guard` succeeds; `mtrust-api-guard` CLI available from command line
2. **Release workflow created and tested** - `.github/workflows/release.yml` exists and triggers automatically after merge to main branch (or manually if preferred); workflow runs mtrust-api-guard to detect API changes, compute next semantic version, and generate changelog
3. **Semantic version computed automatically from API diffs** - mtrust-api-guard analyzes current main vs. previous version; detects breaking changes (MAJOR), new public APIs (MINOR), or fixes only (PATCH); version bumped in pubspec.yaml and git tag created automatically; version matches semver spec
4. **Changelog generated automatically from API diffs** - mtrust-api-guard generates CHANGELOG.md entries documenting API additions/removals/changes; changelog entries describe what changed from user perspective (not implementation details); developer can read changelog and understand version bump reason
5. **Git tags created automatically for every release** - Release workflow creates annotated git tag with pattern `v[semver]` (e.g., `v3.1.0`); tag push succeeds to remote; tag visible in GitHub releases page; tag matches pubspec.yaml version
6. **Release workflow is idempotent and safe** - Running release workflow twice on same commit produces same version and same git tag (no duplicates); workflow fails safely if tag already exists; developer can safely re-run without fear of version conflicts

**Plans:** TBD

---

## Progress

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Dependency Modernization & Android Build Verification | 0/3 | Not started | — |
| 2. Release Automation & Semantic Versioning | 0/N | Not started | — |

---

## Coverage Summary

**v1 Requirements:** 23 total

| Requirement | Phase | Category |
|-------------|-------|----------|
| SDK-01 | 1 | Dart/Flutter SDK |
| SDK-02 | 1 | Dart/Flutter SDK |
| SDK-03 | 1 | Dart/Flutter SDK |
| SDK-04 | 1 | Dart/Flutter SDK |
| AND-01 | 1 | Android Platform |
| AND-02 | 1 | Android Platform |
| AND-03 | 1 | Android Platform |
| AND-04 | 1 | Android Platform |
| GEN-01 | 1 | Code Generation |
| GEN-02 | 1 | Code Generation |
| GEN-03 | 1 | Code Generation |
| GEN-04 | 1 | Code Generation |
| CI-01 | 1 | CI Pipeline |
| CI-02 | 1 | CI Pipeline |
| CI-03 | 1 | CI Pipeline |
| CI-04 | 1 | CI Pipeline |
| CI-05 | 1 | CI Pipeline |
| TST-01 | 1 | Testing |
| TST-02 | 1 | Testing |
| VER-01 | 2 | Automated Versioning |
| VER-02 | 2 | Automated Versioning |
| VER-03 | 2 | Automated Versioning |
| VER-04 | 2 | Automated Versioning |

**Coverage:** 23/23 (100%) ✓
