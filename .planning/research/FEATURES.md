# Feature Landscape: Flutter Plugin CI/CD Pipeline

**Domain:** Flutter plugin continuous integration and delivery
**Researched:** 2026-03-21
**Overall Confidence:** HIGH (Official Flutter docs, pub.dev standards, ecosystem leaders like FlutterFire)

## Table Stakes

Features that any modern Flutter plugin CI/CD pipeline must have. Missing any = pipeline is incomplete for production use.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Automated code analysis (dart analyze) | Standard static analysis; catches errors before runtime | Low | Required in ecosystem. flutter_datawedge already implements via invertase/github-action-dart-analyzer |
| Code formatting enforcement (dart format) | Enforces consistent style across team; pre-merge gate | Low | Already implemented. Must run with --set-exit-if-changed flag |
| Lint rules (lints package) | Enforces code quality patterns; catches anti-patterns | Low | flutter_datawedge uses lints ^6.1.0 and very_good_analysis ^10.2.0 |
| Testing framework execution | Verifies plugin functionality hasn't regressed | Low-Medium | flutter_datawedge has no tests (out of scope for this milestone per PROJECT.md); framework still needed as gate |
| Cross-platform platform channel verification | Validates Pigeon-generated code; ensures Dart-Kotlin communication works | Medium | Critical for plugin correctness; needs at least build verification |
| Artifact build verification (android build) | Ensures plugin compiles for target platforms | Medium | Android-only for this project. Must verify APK/AAB generation succeeds |
| Dependency resolution checks | Ensures pubspec.yaml and gradle deps remain compatible | Low | flutter pub get and gradle sync verify this |
| Human-readable test reports | CI results accessible to developers without terminal access | Low | GitHub Actions provides UI; invertase analyzer action adds inline annotations |

## Differentiators

Features that set a plugin apart. Not required, but valuable for professional plugins.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Automated semantic versioning (mtrust-api-guard) | Removes manual version management; generates changelogs from API diffs | Medium | **Recommended for flutter_datawedge.** Detects breaking changes automatically; saves coordination overhead |
| Git tagging on release | Correlates tags to pub.dev releases; enables rollback via git history | Low-Medium | mtrust-api-guard handles this as part of version command |
| Automated changelog generation | Documents API changes without manual tracking | Low-Medium | mtrust-api-guard generates structured changelog entries |
| Code coverage tracking | Visibility into test coverage gaps; trends over time | Medium | Not implemented; likely future phase |
| Generated coverage badges | Visual indicator of code quality in README | Low | Nice-to-have; lower priority than coverage itself |
| Performance benchmarking | Tracks platform channel latency; catches regressions | High | Not needed for v1 of CI/CD; would be phase 2+ |
| Security scanning (OSSF scorecard) | Third-party trust metric; compliance verification | Low-Medium | FlutterFire uses this; good practice but not critical for plugin correctness |
| Multi-platform testing (iOS simulation) | Ensures plugin concept works on other platforms | High | Out of scope: flutter_datawedge is Android-only |
| Version matrix testing | Tests against multiple Flutter/Dart versions | Medium | Good practice; can be added later if needed |

## Anti-Features

Deliberately NOT building these. Attempting them would waste effort or violate project constraints.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| Full integration test suite | PROJECT.md explicitly defers full test coverage to later phase; only placeholder test needed now | Implement placeholder test; plan real suite for Phase 2 |
| iOS CI/CD pipeline | Plugin is Android-only by design (per PROJECT.md); iOS support explicitly not planned | Keep Android-only. If iOS ever added, extend workflow then |
| Pub.dev publishing automation on every tag | Currently consumed via git dependencies, not pub.dev; publishing is manual/rare | Keep manual release workflow. mtrust-api-guard version command creates tags; publishing remains manual step |
| Complex release notes generation | mtrust-api-guard changelog is sufficient; don't over-engineer | Use mtrust-api-guard changelog output; no custom markdown templating |
| Dependency version pinning CI checks | Freezing dependencies defeats the purpose of the "bump to latest stable" initiative | Use semver ranges as intended; flag major incompats via CI, don't mandate pins |
| Multi-branch release workflows | Only main branch releases; keeps versioning simple | Single release path from main; feature branches merge to main before release |

## Feature Dependencies

Dependencies between CI/CD features (what must exist before other features can work).

```
Automated code analysis (dart analyze)
  ↓
Code formatting enforcement (dart format)
  ↓
Lint rules + human-readable test reports
  ↓
Android build verification
  ↓
THEN: Semantic versioning (mtrust-api-guard) can run
  ↓
THEN: Automated changelog + git tagging
```

**Ordering rationale:**
1. **Analysis + formatting** run first; they're fast and catch obvious errors
2. **Build verification** confirms the plugin actually compiles before considering version bump
3. **Semantic versioning** only makes sense after code quality gates pass
4. **Changelog + tagging** happen last, as final commit/release actions

## MVP Recommendation

For flutter_datawedge's current milestone (CI/CD + dependency upgrade):

### Tier 1: Implement Now (Table Stakes + Primary Differentiator)
1. ✓ **Dart analyze** (already implemented)
2. ✓ **Dart format** (already implemented)
3. ✓ **Lint rules** (already implemented)
4. **Add: Android build verification** (compile plugin to verify no breaking changes)
5. **Add: mtrust-api-guard for semantic versioning** (primary differentiator; automates version management)
6. **Add: Placeholder test** (minimal test file; gate exists for future coverage)

### Tier 2: Document but Defer
- Code coverage tracking (mentioned in tests; full suite is Phase 2)
- Performance benchmarking (future enhancement)
- Multi-version testing matrix (future enhancement)

### Defer Completely (Out of Scope)
- iOS CI/CD (not planned)
- Pub.dev auto-publishing (consumed via git deps; publishing is rare/manual)
- Full integration test suite (Phase 2+)

## Feature Interactions

**mtrust-api-guard integration points:**
- Runs AFTER android build verification succeeds
- Compares previous version's API (from git tags) to current code
- Automatically bumps version in pubspec.yaml
- Generates changelog entry
- Creates git tag
- Returns exit code 0 on success; CI can then trigger pub.dev publish if desired

**Placeholder test interaction:**
- Runs as part of normal `flutter test` in CI
- Doesn't block; allows future test additions without changing CI config
- Gate exists; enforcement is zero until real tests are added

## Sources

- [Flutter: Testing plugins](https://docs.flutter.dev/testing/testing-plugins) — Plugin-specific testing guidance
- [Dart: Testing](https://dart.dev/guides/testing) — Unit/integration test best practices
- [Dart: Creating libraries](https://dart.dev/guides/libraries/creating-libraries) — Package creation standards
- [Dart: dart format](https://dart.dev/tools/dart-format) — Formatting tool and CI integration
- [Dart: Static analysis](https://dart.dev/tools/analysis) — Analysis configuration and CI usage
- [pub.dev: Semantic Versioning](https://dart.dev/guides/libraries/versioning) — Dart semver practices
- [mtrust_api_guard: pub.dev](https://pub.dev/packages/mtrust_api_guard) — Tool capabilities and commands
- [FlutterFire: GitHub workflows](https://github.com/firebase/flutterfire) — Industry-standard plugin CI setup
- [Flutter packages: CI practices](https://github.com/flutter/packages) — Official Flutter team standards
