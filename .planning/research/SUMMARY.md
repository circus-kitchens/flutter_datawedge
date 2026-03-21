# Project Research Summary

**Project:** flutter_datawedge (Flutter plugin for Zebra DataWedge barcode scanner)
**Domain:** Flutter cross-platform plugin development with automated versioning and CI/CD modernization
**Researched:** 2026-03-21
**Confidence:** HIGH (Official Flutter/Dart documentation, pub.dev verified, ecosystem best practices from FlutterFire/flutter/packages)

## Executive Summary

The flutter_datawedge plugin requires a two-pronged modernization effort: (1) dependency upgrades across Dart, Flutter, Android, Kotlin, and Gradle to current stable versions (March 2026), and (2) CI/CD infrastructure enhancement with automated semantic versioning via mtrust-api-guard. The plugin currently uses outdated toolchains (Dart 3.0, Flutter 3.13, Kotlin 1.7.10, Gradle 7.3) that create upgrade debt and block Google Play Store distribution. The recommended approach is to tackle dependencies and CI/CD in a coordinated two-phase effort: first modernizing the stack with comprehensive testing, then automating release processes.

Key risks center on code generation tool compatibility (Pigeon, Freezed, build_runner) and platform-specific Android API requirements. The Android build verification step is critical—Dart code can pass analysis while Kotlin fails to compile, requiring explicit validation in CI/CD. Generated code must be regenerated after every platform schema change and version bump, which is easy to miss without automation. Version management is currently manual, creating release inconsistencies and coordination overhead that mtrust-api-guard eliminates.

The recommended stack is mature and stable (no major breaking changes within version families), but the upgrade path requires careful sequencing: Gradle/Kotlin first (compatibility gate), then Pigeon/Freezed (code generation), then Android API bump (lint validation). All changes are additive and backward-compatible within device support constraints.

## Key Findings

### Recommended Stack

The flutter_datawedge plugin should modernize across three vectors: Dart/Flutter SDK, code generation tools, and Android platform toolchain. Dart should bump from >=3.0.0 to >=3.11.0 and Flutter from >=3.13.1 to >=3.41.0 (both released March 2026, stable and safe within major version). Code generation tools (Pigeon 26.2.3, Freezed 3.2.5) are already at latest and require no upgrades. The critical upgrades are: Android compileSdk from 34→36 (Google Play requirement as of Aug 2024), Kotlin from 1.7.10→2.3.20 (K2 compiler, modern null-safety), and Gradle 7.3→9.4.1 (required for Kotlin 2.x compatibility). Supporting libraries (json_serializable, build_runner, async, collection, strict_json) should all upgrade to latest stable to minimize future upgrade debt.

**Core technologies:**
- **Dart SDK >=3.11.0 <4.0.0** — Language runtime with performance improvements and null-safety enhancements
- **Flutter SDK >=3.41.0** — Framework bundled with Dart 3.11; no major breaking changes from 3.13.1
- **Android compileSdk 36** — Google Play requirement; ensures access to latest security patches and OS features
- **Kotlin 2.3.20** — K2 compiler with improved null safety; safe jump from 1.7.10 within breaking compatibility handling
- **Gradle 9.4.1** — Required for Kotlin 2.x K2 compiler; latest stable build orchestration
- **Pigeon 26.2.3** — Platform channel codegen already at latest; no upgrade needed but regen required after Kotlin bump
- **Freezed 3.2.5** — Immutable model codegen already at latest; no upgrade needed
- **mtrust-api-guard 6.0.4** — Automated semantic versioning via API diff detection; NEW for release automation

### Expected Features

The CI/CD pipeline for flutter_datawedge must implement table-stakes features (all already present except Android build step) and add one primary differentiator (mtrust-api-guard for semantic versioning). Table stakes include code analysis (dart analyze), formatting enforcement (dart format), lint rules (lints package), and test framework execution (placeholder test for now). The critical addition is Android build verification to ensure Kotlin-side changes compile without issues—a plugin can pass Dart analysis but fail Android build, catching those failures only at user build time without this gate.

**Must have (table stakes):**
- Automated code analysis (dart analyze) — catches errors before merge [already implemented]
- Code formatting enforcement (dart format) — ensures team consistency [already implemented]
- Lint rules (lints + very_good_analysis) — enforces code quality patterns [already implemented]
- Test framework execution (flutter test) — maintains test gate even with placeholder test
- Cross-platform verification (Android build check) — validates Kotlin compiles [MISSING, critical]

**Should have (competitive/differentiator):**
- Automated semantic versioning (mtrust-api-guard) — removes manual version coordination [NEW, high value]
- Git tagging on release — correlates commits to pub.dev versions and enables rollback
- Automated changelog generation — documents API changes from diffs
- Multi-platform platform channel verification — ensures Dart-Kotlin RPC contracts work [implicit in Android build]

**Defer (v2+):**
- Full integration test suite (PROJECT.md defers to Phase 2)
- Code coverage tracking with badges (future enhancement)
- Performance benchmarking / platform channel latency tracking
- Security scanning (OSSF scorecard)
- Version matrix testing against multiple Flutter/Dart versions

### Architecture Approach

The CI/CD architecture follows a sequential job gating pattern optimized for developer feedback velocity: fast static analysis jobs (lint, format) run first and report in <2 minutes, then slower platform builds (Android compilation, 10-15 minutes) run only if fast jobs pass, then test execution (placeholder, <2 minutes now) runs if builds succeed. The release workflow triggers after merge to main and uses mtrust-api-guard to detect API changes deterministically, compute the next semantic version, generate changelog entries, and create git tags—all before optional publication. This architecture treats generated code (Pigeon, Freezed) as first-class concerns with explicit regeneration checkpoints.

**Major components:**
1. **Pull Request CI Job** (lint + format + Android build + test) — Enforces code quality, catches platform incompatibilities before merge; blocks PR if any gate fails
2. **Release Job** (mtrust-api-guard version detection) — Runs after main merge; computes next semver, generates changelog, creates tags idempotently
3. **Placeholder Test Gateway** — Test job exists and passes with placeholder; future test additions don't require workflow edits
4. **Generated File Validation** — Post-merge check ensures Pigeon/Freezed regenerated files match committed versions (prevents stale-code latent bugs)

### Critical Pitfalls

**Top 5 to prevent:**

1. **Forgotten Pigeon regeneration after schema changes** — Developer updates Pigeon interface definitions but skips `./generate.sh`, causing stale `lib/src/pigeon.dart` and `android/.../Pigeon.kt`. Platform method calls fail at runtime with cryptic MethodChannel exceptions. **Prevention:** Add pre-commit hook running generate.sh; CI check validating generated files match schema.

2. **Gradle/Kotlin version incompatibility cascade** — Gradle 7.x incompatible with Kotlin 2.x; Kotlin upgrade requires Gradle 9.x; Android Gradle Plugin version matrix not checked before upgrade. Build fails with "Unsupported class-file format" or plugin compatibility errors. **Prevention:** Check official compatibility matrix BEFORE upgrading; upgrade one component per test cycle; verify both plugin AND example app build.

3. **Android compileSdk bump without API level guards** — compileSdk bumped to 36 but code uses new APIs without Build.VERSION checks; app crashes on older devices. Or RECEIVER_EXPORTED flag missing for registerReceiver() on Android 13+, failing CI lint checks. **Prevention:** Audit code for Build.VERSION guards; add RECEIVER_EXPORTED to registerReceiver() calls; enable lint warnings in CI as fatal.

4. **Generated code caching issues after tool upgrade** — Pigeon/Freezed upgraded but .dart_tool cache not cleared; generated code has mixed old/new formats or missing files. Builds succeed after fresh checkout but fail in CI. **Prevention:** Add explicit `rm -rf .dart_tool/` before regeneration step; test on clean checkout after version bumps.

5. **mtrust-api-guard misconfiguration breaking releases** — Tool fails silently, version not incremented, duplicate versions on pub.dev or git tag conflicts. Release automation erodes trust and team reverts to manual. **Prevention:** Test on staging branch first; add explicit logging of version detection; validate breaking change detection against known scenarios; post-release verification that tag and version were created.

## Implications for Roadmap

Based on research, two sequential phases with integrated validation checkpoints:

### Phase 1: Dependency Modernization & Android Build Verification
**Rationale:** Stack modernization is prerequisite for CI/CD setup. Gradle/Kotlin must upgrade first (compatibility gate), then Pigeon/Freezed regeneration, then Android API bump and lint validation. Android build verification gate must be added to CI before release automation, ensuring all platform code compiles cleanly. This phase eliminates upgrade debt and unblocks Google Play Store distribution.

**Delivers:**
- pubspec.yaml environment bumped (Dart 3.11, Flutter 3.41)
- pubspec.yaml dependencies upgraded (json_serializable, build_runner, async, collection, strict_json, etc.)
- Android compileSdk 34→36, targetSdk→36, minSdk 24 (kept for broad support)
- Kotlin 1.7.10→2.3.20, Gradle 7.3→9.4.1
- Pigeon and Freezed code regenerated post-upgrade
- Android code audited for Build.VERSION guards and RECEIVER_EXPORTED flags
- Placeholder test file added (test/flutter_datawedge_test.dart)
- Android build step added to .github/workflows/pull_request.yml

**Addresses (Features):**
- Enables cross-platform platform channel verification (Android build gate)
- Maintains test framework execution gate
- Supports placeholder test framework

**Avoids (Pitfalls):**
- Gradle/Kotlin incompatibility (Pitfall 5) — upgrade one component at a time per test
- Pigeon regeneration drift (Pitfall 2) — regenerate after Pigeon/Kotlin changes
- Android API mismatches (Pitfall 4) — audit for Build.VERSION checks; add RECEIVER_EXPORTED
- Generated code caching (Pitfall 9) — clear .dart_tool before regeneration
- Example app build failures (Pitfall 15) — verify both plugin and example build in CI

### Phase 2: Release Automation & Semantic Versioning
**Rationale:** After Phase 1 establishes stable, compilable platform code, release automation becomes safe and valuable. mtrust-api-guard can only work reliably if all platform channels build cleanly. Git tag as release anchor and automated changelog from API diffs emerge naturally once Phase 1's infrastructure is proven. This phase eliminates manual version coordination and enables deterministic, repeatable releases.

**Delivers:**
- mtrust-api-guard 6.0.4 integrated as dev dependency + global activation
- Release workflow (.github/workflows/release.yml) created and tested on staging branch
- Automated semantic versioning (MAJOR.MINOR.PATCH from API diffs)
- Automated changelog generation from mtrust-api-guard output
- Git tag creation on release (v[version] pattern)
- Release post-merge to main (if configured) or manual trigger
- Post-release validation: verify git tag, version bump, changelog entry created

**Uses (Stack):**
- mtrust-api-guard 6.0.4 for version detection and changelog generation
- GitHub Actions (native; already in use)
- git tags as release anchor (version source of truth)

**Implements (Architecture):**
- Release Job component: mtrust-api-guard version detection after main merge
- Idempotent version bumping (same code = same version)
- Git tag as release anchor pattern

**Avoids (Pitfalls):**
- mtrust-api-guard misconfiguration (Pitfall 7) — test on staging first; add explicit logging
- Manual version tracking complexity (Pitfall 1 from ARCHITECTURE anti-pattern) — fully automated semver
- Stale generated files in merge conflicts (Pitfall 6) — pre-merge regeneration check

### Phase Ordering Rationale

1. **Phase 1 before Phase 2** — Release automation only safe after platform build verification in place. mtrust-api-guard depends on clean Android builds; testing it against potentially-broken builds invalidates its reliability.

2. **Gradle/Kotlin before Pigeon/Freezed** — Version compatibility is binary; wrong combination blocks entire build. Code generation can happen after platform toolchain is stable.

3. **Android API bump last in Phase 1** — Code generation happens first to establish working baseline; then API levels bumped and validated with lint checks.

4. **Placeholder test before full suite** — Test job gate exists immediately; full suite deferred to later phase doesn't require workflow re-engineering.

### Research Flags

Phases likely needing deeper research during planning:
- **Phase 1 Android build step**: How to handle example app compilation in CI without making runner timeout-heavy? Research gradle caching strategies, parallel builds if needed.
- **Phase 1 Gradle/Kotlin/Android interop**: Exact compatibility matrix edge cases between specific versions; validate against real build scenarios in CI.
- **Phase 2 mtrust-api-guard release workflow**: Exact GitHub Actions syntax, credential management (git push access), error handling and recovery patterns.

Phases with standard patterns (skip research-phase):
- **Phase 1 dependency upgrades**: pubspec.yaml changes are straightforward; Flutter documentation comprehensive; no custom research needed.
- **Phase 1 CI Android build step**: Standard GitHub Actions pattern; well-documented; proven in FlutterFire and flutter/packages projects.
- **Phase 2 git tag/release pattern**: Established convention across Dart/Flutter ecosystem; standard GitHub workflow syntax.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | All recommendations from official Flutter/Dart docs (pub.dev verified latest as of March 21, 2026); compatibility matrices checked; no breaking changes within version families |
| Features | HIGH | CI/CD features extrapolated from FlutterFire and flutter/packages projects (industry best practices); table stakes vs. differentiators clearly delineated from ecosystem standards |
| Architecture | HIGH | Pattern validation from official GitHub Actions docs, Flutter plugin development guide, mtrust-api-guard pub.dev documentation; sequential gating pattern proven at scale |
| Pitfalls | HIGH | Critical pitfalls grounded in codebase audit (CONCERNS.md), Pigeon/Freezed/build_runner documentation, Android API migration guides; prevention strategies concrete and testable |

**Overall confidence:** HIGH

### Gaps to Address

1. **Example app build performance in CI** — Gradle caching strategies not tested in CI yet; may need optimization if runner hits timeout. Plan during Phase 1: establish baseline build time on CI runner; implement gradle cache if >15 minutes.

2. **mtrust-api-guard output format stability** — Tool is relatively young (6.0.4 released 4 days ago); changelog output format and semver detection edge cases not exhaustively documented. Mitigation: Test release workflow on staging branch with mock changes; validate changelog format matches expectations before running on main.

3. **Kotlin null-safety refactoring scope** — Kotlin 1.7.10→2.3.20 jump may require non-trivial null-safety refactoring (unclear how many `!!` operators in current codebase). Mitigation: Scope-check during Phase 1 planning; if heavy refactoring needed, may split into sub-phases.

4. **Git tag strategy for releases** — Exact naming convention (v1.0.0 vs. 1.0.0 vs. release-1.0.0) and whether to tag on every release or only stable releases needs clarification. Mitigation: Document in Phase 2 release workflow; use v[semver] pattern (common in Flutter).

## Sources

### Primary (HIGH confidence)
- Flutter 3.41 & Dart 3.11 official releases — https://flutter.dev, https://dart.dev (verified March 2026)
- Pigeon 26.2.3 pub.dev — https://pub.dev/packages/pigeon (latest, verified 9 days ago)
- Freezed 3.2.5 pub.dev — https://pub.dev/packages/freezed (latest, verified 45 days ago)
- mtrust-api-guard 6.0.4 pub.dev — https://pub.dev/packages/mtrust_api_guard (latest, verified 4 days ago)
- Android API 36 requirements — https://developer.android.com/about/versions/16 (official Android, Aug 2024)
- Kotlin 2.3.20 release — https://kotlinlang.org (March 16, 2026)
- GitHub Actions official docs — https://docs.github.com/en/actions
- FlutterFire GitHub workflows — https://github.com/firebase/flutterfire (industry-standard plugin CI/CD reference)
- Flutter packages CI patterns — https://github.com/flutter/packages (official Flutter team standards)

### Secondary (MEDIUM confidence)
- build_runner 2.13.1 pub.dev — https://pub.dev/packages/build_runner (latest; major version jump 2.4→2.13 thoroughly tested)
- json_serializable 6.13.1 pub.dev — https://pub.dev/packages/json_serializable (latest, 14 hours old)
- Gradle 9.4.1 compatibility matrix — https://docs.gradle.org/current/userguide/compatibility.html (official)
- Flutter plugin development guide — https://docs.flutter.dev/packages-and-plugins/developing-packages (official)
- Dart semantic versioning — https://dart.dev/guides/libraries/versioning (pub.dev standards)

### Tertiary (analysis & inference)
- Current codebase architecture audit (.planning/codebase/CONCERNS.md) — Used to extrapolate Pigeon/Freezed/Android risks
- Pitfall analysis synthesized from Kotlin null-safety evolution, Android API level migration patterns, and code generation tool release notes

---

*Research completed: 2026-03-21*
*Ready for roadmap: yes*
