# Domain Pitfalls: Flutter Plugin Upgrade and CI/CD

**Domain:** Flutter platform plugin dependency modernization + GitHub Actions CI/CD integration
**Project:** flutter_datawedge (Zebra DataWedge barcode scanner bridge)
**Researched:** 2026-03-21
**Scope:** Pigeon, Freezed, Android SDK/Gradle/Kotlin upgrades, mtrust-api-guard integration

---

## Critical Pitfalls

### Pitfall 1: Forgotten Pigeon Code Regeneration After Schema Changes

**What goes wrong:**
- Developer updates `.dart` or `.kt` Pigeon definitions but forgets to run `./generate.sh`
- Generated `lib/src/pigeon.dart` and `android/.../Pigeon.kt` files become stale
- At runtime, Dart platform channel calls don't match Kotlin implementations
- Results in cryptic MethodChannel exceptions or method-not-found errors
- Changes silently break functionality (no compile-time warning)

**Why it happens:**
- Pigeon generation is manual via shell script (`./generate.sh`)
- No automatic detection of schema drift or out-of-date generated files
- New developers may not know the generation step exists
- CI/CD doesn't enforce regeneration yet

**Consequences:**
- Runtime crashes in production when Dart calls unrecognized platform methods
- Breaks mobile app integrations using the plugin via git dependency
- Difficult to debug (appears to be Pigeon or platform channel issue)
- May require downtime if deployed before discovered

**Prevention:**
- Add pre-commit hook that runs `./generate.sh` and validates generated files are up-to-date
- Add Git-tracked marker file (e.g., `.pigeon-generated-timestamp`) and diff against schema files
- Migrate from shell script to `build_runner` integration if Pigeon supports it
- Add CI check: run generate.sh and fail if generated files differ from committed files
- Document Pigeon regeneration step in contribution guide and onboarding

**Detection:**
- Method channel logs: "Unknown method" or "MissingMethodException"
- Schema file timestamp newer than generated file timestamp
- Build fails with type mismatch when upgrading Pigeon

**Phase:** Dependency upgrade phase + CI/CD setup phase

---

### Pitfall 2: Misaligned Generated Code Between Pigeon Versions

**What goes wrong:**
- Pigeon version bumped in pubspec.yaml (e.g., 26.2.3 → 35.0.0)
- Generated code format changes (new patterns, field ordering, codec behavior)
- Existing hand-written `DWInterface.kt` becomes incompatible with newly generated `Pigeon.kt`
- Type mismatches or interface contract violations cause compilation errors
- Breaking changes in HostApi/FlutterApi signatures not caught until build time

**Why it happens:**
- Pigeon is active development tool; breaking changes appear in minor/major version bumps
- Generated code is committed to repo; requires full regeneration during upgrade
- No analysis of breaking changes between versions before regeneration

**Consequences:**
- Android build fails with compile errors in Pigeon.kt
- Requires manual reconciliation of hand-written Kotlin code with new API
- May need to refactor Android implementation to match new Pigeon patterns
- Delays release cycle

**Prevention:**
- Review Pigeon changelog BEFORE upgrading: check for "BREAKING" or "API change" sections
- Generate into a temporary branch first; review diff of Pigeon.kt changes
- Test Android build AFTER regeneration (don't assume Dart-side build passes means Android compiles)
- Keep hand-written Kotlin minimal and close to generated patterns for easier migration
- Document any Pigeon API quirks or workarounds in ARCHITECTURE.md for future maintainers

**Detection:**
- Android build fails with "unresolved reference" errors in Pigeon.kt usage
- Type mismatch in HostApi/FlutterApi implementations
- Kotlin compiler errors on generated code import statements
- Test failures when Dart calls platform methods

**Phase:** Dependency upgrade phase (before merging)

---

### Pitfall 3: Freezed Code Generation Breakage During Model Refactors

**What goes wrong:**
- Developer modifies Dart model class (e.g., adds/removes field, changes type)
- Forgets to run `dart run build_runner build` after the change
- `.freezed.dart` and `.g.dart` files become stale
- Serialization/deserialization silently fails or uses old schema
- Crash when platform channel tries to deserialize platform method result

**Why it happens:**
- Freezed code generation is not automatic; requires manual `build_runner` invocation
- No compile-time validation that `.freezed.dart` matches source `.dart` file
- Easy to commit source without regenerating in a hurry

**Consequences:**
- JSON deserialization silently fails or returns incomplete objects
- Runtime crash when `ScanEvent` or `StatusChangeEvent` from Kotlin is deserialized
- Event stream receives malformed objects
- Difficult to debug (appears to be platform channel or DataWedge issue)

**Prevention:**
- Add pre-commit hook: run `dart run build_runner build` and fail if generated files are stale
- CI/CD check: run build_runner, diff against committed files, reject if mismatched
- Use `dart fix --apply` to automate some schema migrations automatically
- Document model changes require code generation in dev guide
- Consider moving to inline class generation if Dart future versions support it

**Detection:**
- `_PigeonCodec` deserialization exception or "Unknown JSON key" errors
- `ScanEvent` or `StatusChangeEvent` fields are null when they shouldn't be
- Type error when casting deserialized JSON to model class
- Dart runtime error: "NoSuchMethodError: onScanResult"

**Phase:** Dependency upgrade phase + CI/CD setup phase

---

### Pitfall 4: Android compileSdk vs minSdkVersion Version Mismatch After Upgrade

**What goes wrong:**
- Android compileSdk bumped (e.g., 34 → 35 or 36) to stay current
- minSdkVersion left at 19 (Android 4.4) for broad device support
- New Android APIs from compileSdk targeted code used directly without runtime checks
- App crashes on older devices that don't have those APIs
- Or: gradle build fails with "uses-sdk minSdkVersion (19) < targetSdkVersion (35)" conflicts

**Why it happens:**
- Bumping compileSdk appears to be a simple version number change
- Developers assume higher compileSdk doesn't affect runtime compatibility
- Kotlin compiler may optimize to use newer APIs if minSdkVersion appears satisfied
- Missing `@RequiresApi()` annotations on code using new APIs

**Consequences:**
- App crashes on devices running Android 4.4-9 (minSdkVersion 19-28) with ClassNotFoundException
- Runtime exception: "Call requires API level X (current min is 19)"
- Breaks compatibility guarantee for plugin consumers
- May cause rejections in internal app deployments if they target older devices

**Prevention:**
- Before bumping compileSdk, audit Android code for `android.os.Build.VERSION` checks
- Ensure all new API usages wrapped in `if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.X)`
- Add build-time lint check for unsupported API calls (Lint.xml rules)
- Test build output with gradle lint warnings enabled
- Document minimum supported Android API level for compileSdk version in ARCHITECTURE.md
- Keep minSdkVersion fixed; don't increment just because compileSdk increased

**Detection:**
- Gradle build warning: "targetSdkVersion requires higher minSdkVersion"
- Runtime crash: `java.lang.ClassNotFoundException: android.content.SomeNewClass`
- Lint report: "Call requires API level X"
- App crashes on test device running older Android version

**Phase:** Android SDK upgrade phase (before testing)

---

### Pitfall 5: Gradle/Kotlin Version Incompatibility During Upgrade

**What goes wrong:**
- Gradle bumped from 7.3.0 → 8.x to support latest Android plugin
- Kotlin bumped from 1.7.10 → 2.0+ for modern features
- Gradle plugin version in `build.gradle` becomes incompatible with new Kotlin version
- Build fails with "Unsupported class-file format" or plugin compatibility error
- Android and example app have mismatched Gradle/Kotlin versions, causing conflicts

**Why it happens:**
- Gradle, Kotlin, and Android Gradle Plugin have complex compatibility matrix
- Version constraints not obvious; require checking compatibility table
- Upgrading one triggers cascading requirements on others
- Plugin file (`buildscript { classpath ... }`) version often hardcoded, not automatically managed

**Consequences:**
- Complete build failure; unable to compile plugin or example app
- Requires manual resolution of version constraints
- May need to downgrade one component or upgrade to pre-release version
- Delays entire milestone

**Prevention:**
- Before upgrading Gradle or Kotlin, consult official compatibility matrix:
  - Gradle: https://docs.gradle.org/current/userguide/compatibility.html
  - Kotlin: https://kotlinlang.org/docs/releases.html (changelog section)
  - Android Gradle Plugin: https://developer.android.com/tools/gradle-plugin-release-notes
- Create test branch, upgrade one component at a time, verify build succeeds after each
- Use Gradle's dependency constraint system to enforce compatible versions
- Document exact versions in build.gradle comments with rationale
- CI/CD should build both plugin AND example app to catch plugin-level incompatibilities

**Detection:**
- Gradle build fails with version mismatch error
- "Unsupported class-file format" during Kotlin compilation
- Plugin compatibility warnings in Gradle output
- Example app build fails while plugin build succeeds (or vice versa)

**Phase:** Android SDK upgrade phase (first thing to test)

---

### Pitfall 6: Generated Pigeon Files Become Stale in Merge Conflicts

**What goes wrong:**
- Two branches both modify Pigeon schema independently
- Merge creates conflict in committed Pigeon schema files
- Developer resolves conflict manually but forgets to regenerate
- Committed `Pigeon.kt` and `pigeon.dart` don't match either branch's schema
- Creates latent bug that appears after merge, causing runtime failures

**Why it happens:**
- Generated files are committed to repo for version control
- Manual conflict resolution on generated files is error-prone
- No automatic post-merge hook to regenerate files
- CI/CD doesn't validate generated files match schema AFTER merge commit

**Consequences:**
- Build succeeds locally (if regenerated after manual merge), but fails in CI/CD
- Merge commit introduces broken state that's hard to trace
- May require force push or revert to fix if discovered after merge
- Breaks trunk reliability

**Prevention:**
- Generate Pigeon and Freezed code into `.gitignore` if possible (requires build_runner integration)
- If committed, add post-merge hook that runs `./generate.sh` and stages changes
- PR check: merge locally, regenerate, fail if generated files differ
- Document merge conflict resolution process: resolve schema, regenerate, commit generated files together
- Consider generating files into build output directory and committing only schema files

**Detection:**
- Build fails with type errors in generated code after merge
- CI/CD build fails but local build succeeds (indicates post-merge generation needed)
- Git diff shows merge conflict markers in `.dart` or `.kt` generated files
- Runtime crash after merge when platform methods called

**Phase:** CI/CD setup phase (add merge validation check)

---

### Pitfall 7: mtrust-api-guard Misconfiguration Breaking Release Automation

**What goes wrong:**
- mtrust-api-guard configured incorrectly in GitHub Actions workflow
- Tool fails silently or with cryptic error; version bump not created
- Release continues without version increment, causing duplicate version on pub.dev or git tag conflict
- Or: tool is overly aggressive and semver bump doesn't match actual API changes
- Version scheme becomes unreliable; consumers can't trust semver for compatibility decisions

**Why it happens:**
- mtrust-api-guard is relatively new/niche tool; configuration patterns not well-documented
- Requires specific file paths, commit message format, branch configuration
- Tool output is minimal; failures hard to diagnose
- Dart/Flutter ecosystem has fragmented versioning approaches (not standardized like Node.js Lerna)

**Consequences:**
- Release automation fails silently; manual intervention needed
- Duplicate versions on pub.dev break consumers
- Git tags conflict; pipeline hangs during push
- Erodes trust in release process; team manually overrides automation

**Prevention:**
- Before configuring, review mtrust-api-guard documentation AND any Dart examples (if available)
- Test on a staging/test branch FIRST; don't run on main branch initially
- Add explicit logging to GitHub Actions: echo tool outputs and version detection logic
- Validate mtrust-api-guard correctly detects breaking changes by testing against known scenarios
- Add post-release check: verify git tag was created, version was incremented, commit message is correct
- Document configuration assumptions in .github/workflows/release.yml comments
- Consider alternatives: manual versioning, simpler tools (Melos), if mtrust-api-guard unreliable

**Detection:**
- GitHub Actions workflow shows "release" step complete but no tag/version bump appears
- Multiple git tags with same version number
- pub.dev upload fails due to duplicate version
- Release workflow logs show tool exit code 0 but no changes made

**Phase:** CI/CD setup phase (mtrust-api-guard integration)

---

### Pitfall 8: Android BroadcastReceiver Registration Flags Not Updated for Target SDK

**What goes wrong:**
- Android compileSdk bumped to 34+ or targetSdk bumped to 35+
- Android requires RECEIVER_EXPORTED or RECEIVER_NOT_EXPORTED flags in registerReceiver() (API 33+)
- Code uses older Context.registerReceiver() without flags
- App crashes on Android 13+ with "exporting receiver component without permission"
- Or: receiver works but throws compiler warning, causing CI linting failure

**Why it happens:**
- Flag requirement added in Android 13; older code doesn't use it
- When compileSdk upgrades past API 33, Kotlin compiler enforces flag requirement
- Easy to miss if upgrading without reviewing Android-specific requirements

**Consequences:**
- App crashes on any Android 13+ device immediately after installation
- Release blocked by CI/CD lint check
- May require urgent patch if deployed to production

**Prevention:**
- When compileSdk bumped to 33+, audit all registerReceiver() calls
- Replace `context.registerReceiver(receiver, filter)` with `context.registerReceiver(receiver, filter, Context.RECEIVER_EXPORTED)`
- Add lint rule to catch undecorated registerReceiver() calls in custom lint.xml
- Document flag choice rationale in code comments (EXPORTED vs NOT_EXPORTED based on security model)
- Test app install and launch on Android 13+ emulator after compileSdk bump

**Detection:**
- Gradle lint warning: "Receiver component not registered with appropriate flags"
- App crash on Android 13+ with exception mentioning "exporting receiver"
- CI/CD build fails with lint warning if fatal-warnings enabled
- Android Studio inspection: "Missing intent filter export permission"

**Phase:** Android SDK upgrade phase (verify with lint check in CI/CD)

---

## Moderate Pitfalls

### Pitfall 9: Code Generation Caching Issues After Tool Version Upgrade

**What goes wrong:**
- Pigeon, Freezed, or build_runner upgraded to new version
- Tool caches are not cleared before regeneration
- Old cache entries cause code generation to skip certain files or use stale output format
- Generated code has mixed formats (old style + new style) causing unexpected behavior
- Or: specific generated files completely missing due to caching bug

**Why it happens:**
- Dart build_runner uses `.dart_tool/` cache directory
- Tool version changes may invalidate cache entries but don't auto-clear
- Developers assume "clean rebuild" clears code generation cache
- Cache invalidation issues are common in build tools

**Consequences:**
- Code generation produces incorrect or incomplete output
- Subtle runtime failures (missing methods, incorrect serialization format)
- Difficult to diagnose (works after clean checkout, fails in incremental CI build)
- May cause flaky CI/CD builds depending on cache state

**Prevention:**
- When upgrading Pigeon, Freezed, or build_runner, add explicit cache clear step
- Add to workflow: `rm -rf .dart_tool/` before running `pub get` and `build_runner build`
- Document in upgrade notes: "ALWAYS delete .dart_tool and .dart_tool/build/ after version changes"
- CI/CD runner should use clean environment (no cache carryover between builds)
- Test on fresh checkout after upgrade (new CI job, new container image)

**Detection:**
- Code generation produces output with mixed formatting (old+new styles)
- Some generated files missing or incomplete
- Build succeeds on clean checkout but fails on incremental build
- Generated code type mismatches after tool upgrade

**Phase:** Dependency upgrade phase (test step verification)

---

### Pitfall 10: Package Constraint Version Ranges Causing Silent Incompatibility

**What goes wrong:**
- Freezed dependency specified as `freezed: ^3.2.5` (any 3.x version after 3.2.5)
- Freezed 3.5.0 released with subtle code generation format change
- CI/CD or local `pub get` upgrades to 3.5.0 automatically via caret constraint
- Generated `.freezed.dart` format changes incompatibly with deployed code
- Runtime error or serialization failure only appears in production

**Why it happens:**
- Dart packages use semantic versioning; `^` allows patch and minor version auto-upgrade
- Code generation tools (Freezed, Pigeon) may have breaking changes in minor versions
- Generated code format changes can cause runtime incompatibilities
- Dependency lock file (pubspec.lock) not always committed for plugins

**Consequences:**
- Code generation produces incompatible output without developer awareness
- Application crashes or behaves incorrectly at runtime
- Hard to reproduce locally if local pubspec.lock is different
- Breaks consumers of plugin via git dependency if they use different pubspec.lock

**Prevention:**
- Pin exact versions for code generation tools in pubspec.yaml: `pigeon: 26.2.3` (no caret)
- For regular utilities, use tighter constraints: `async: ^2.11.0` is acceptable
- Commit pubspec.lock alongside pubspec.yaml for plugins (ensures reproducible builds)
- Add CI check: validate installed versions match expected versions
- Test upgrade scenarios before allowing auto-upgrade (test new minor version in staging)

**Detection:**
- Generated code format differs between developer machines (different Freezed versions)
- Runtime error: "Unknown JSON key" or type mismatch after pub get
- CI/CD build succeeds but example app crashes at runtime
- pubspec.lock has different version than expected

**Phase:** Dependency upgrade phase (when modifying version constraints)

---

### Pitfall 11: Kotlin Compiler Null Safety Assumption After Language Feature Upgrade

**What goes wrong:**
- Kotlin bumped from 1.7.10 to 2.0+
- New Kotlin version enables stricter null-safety analysis by default
- Android code has unsafe null assertions (`!!` operators) that were previously warnings
- Build fails with "Type mismatch" errors or null-safety violations on code that compiled before
- Requires rewriting null handling across Android codebase

**Why it happens:**
- Kotlin 2.0 will tighten null-safety requirements as part of language evolution
- Existing code uses `!!` operators and assumes non-null values without proper checking
- Compiler settings may enable stricter checks in newer versions
- Existing Android code not written to new null-safety standards

**Consequences:**
- Android build fails after Kotlin upgrade
- Requires non-trivial refactoring of null-safety handling
- May introduce performance overhead if using safe calls instead of assertions
- Delays release cycle

**Prevention:**
- Before upgrading Kotlin, review changelog for "null-safety" or "strict null checks" changes
- Test Kotlin upgrade in a branch; expect and plan for null-safety refactoring
- Audit Android code for `!!` operators and replace with proper null coalescing
- Enable strictness warnings in kotlinOptions.freeCompilerArgs before upgrade (e.g., `-Werror`)
- Consider refactoring null-unsafe code NOW (during 1.7.10) to prepare for 2.0+

**Detection:**
- Kotlin compiler error: "Type mismatch: inferred type is X? but X was expected"
- Build fails with null-safety violations after Kotlin upgrade
- Compiler warning that becomes error in stricter version

**Phase:** Android SDK upgrade phase (Kotlin version bump)

---

### Pitfall 12: GitHub Actions Flutter Action Cache Invalidation

**What goes wrong:**
- GitHub Actions Flutter action (subosito/flutter-action) caches Flutter SDK and dependencies
- Flutter version cached, then later version released with critical fix
- CI/CD builds use old cached version, doesn't pick up fix
- Or: cache becomes corrupted; builds fail with obscure errors in random jobs

**Why it happens:**
- GitHub Actions action caches by Flutter version string
- If flutter-version pinned to "3.13.1" and cache exists, action reuses cached version
- Cache is not automatically invalidated when new patch releases
- Cache corruption can happen if network interruption during cache write

**Consequences:**
- CI/CD builds unreliably use old Flutter version
- Performance regression or security fix from new version not applied
- Flaky tests that fail intermittently (depends on cache state)
- Difficult to debug (works locally, fails in CI or vice versa)

**Prevention:**
- Add explicit cache invalidation step: `flutter clean` before `flutter pub get`
- Use exact Flutter version with patch: `FLUTTER_VERSION: "3.13.1"` (not "3.13" or "stable")
- Periodically review Flutter release notes for security/critical fixes
- Add "clean cache" manual workflow trigger for emergencies (bypass cache)
- Test workflow with cache disabled (GitHub Actions has debugging option)
- Document Flutter version pinning strategy in CI/CD README

**Detection:**
- Build passes locally but fails in GitHub Actions CI
- Different Flutter version reported in CI vs local setup
- Intermittent CI failures that succeed on second run
- build_runner or dartanalyze behavior differs between CI and local

**Phase:** CI/CD setup phase (test caching behavior)

---

## Minor Pitfalls

### Pitfall 13: Generated File .gitignore Entries Incomplete After Tool Addition

**What goes wrong:**
- Add Pigeon to pubspec.yaml
- Generate files, add `*.freezed.dart`, `*.g.dart` to .gitignore
- Forget to add `lib/src/pigeon.dart` and `android/.../Pigeon.kt` to .gitignore
- Generated files are committed to repo by mistake
- Later CI/CD tries to regenerate; get merge conflicts with committed generated files

**Why it happens:**
- Multiple code generation tools (Pigeon, Freezed, json_serializable) have different output paths
- Each tool generates files in different locations
- .gitignore additions not made consistently

**Consequences:**
- Generated files committed and tracked
- Merge conflicts on generated files (difficult to resolve)
- Large file diffs hide real code changes in PRs
- Potential for stale generated code to be accidentally used

**Prevention:**
- Document all generated file paths in project README
- Add comprehensive .gitignore for all code generation outputs:
  - `**/*.freezed.dart` (Freezed)
  - `**/*.g.dart` (json_serializable)
  - `lib/src/pigeon.dart` (Pigeon - Dart side)
  - `android/src/main/kotlin/.../Pigeon.kt` (Pigeon - Android side)
- Use .gitignore generator or verify complete list before initial commit
- CI check: `git clean -fdx --dry-run` to ensure generated files would be ignored

**Detection:**
- Accidentally committed `pigeon.dart` or `Pigeon.kt` appears in git history
- PR shows large diffs in generated files
- .gitignore rules missing for some generated outputs
- `git status` shows "Untracked" for generated files despite ignore rules

**Phase:** Dependency upgrade phase (when adding Pigeon)

---

### Pitfall 14: Forgetting to Update Platform Channel Handlers After Pigeon Schema Change

**What goes wrong:**
- Pigeon schema updated (add new method to HostApi)
- Dart code regenerated and calls new method
- Android Kotlin implementation not updated with new method handler
- Dart call to platform method succeeds in deserialization but Android handler not found
- Catch-all error handler in Kotlin silently fails or returns generic error

**Why it happens:**
- Pigeon generates both Dart and Kotlin, but developer may assume generation is complete
- Kotlin implementation code is separate from generation
- Easy to test Dart code without running Android app
- No type-checking between Dart calls and Kotlin handlers

**Consequences:**
- Platform method call fails at runtime with "Unknown method" error
- Silent failure if exception not properly propagated to Dart
- Feature doesn't work without clear error message
- Difficult to debug (appears to be platform channel issue)

**Prevention:**
- Add CI check: regenerate Pigeon, validate both Dart and Kotlin compile without warnings
- Add pre-push hook: if Pigeon schema changed, verify Android build includes handler for all HostApi methods
- Document Pigeon workflow: schema → generate → implement handlers (both sides) → test
- Code review checklist: all HostApi methods have Kotlin implementations
- Run example app build on Android emulator as part of CI/CD

**Detection:**
- Method channel exception "Unknown method" at runtime
- Kotlin compiler warnings about unimplemented interface methods
- Dart logs show MethodChannel call succeeding but no response data
- Example app crashes when testing new platform feature

**Phase:** Dependency upgrade phase + CI/CD setup phase

---

### Pitfall 15: Missing Generated File in Example App Build

**What goes wrong:**
- Plugin builds and tests pass locally
- Example app uses Pigeon-generated `lib/src/pigeon.dart` from plugin
- Example app build fails because pigeon.dart not found or is stale
- Plugin and example app generated files are out of sync

**Why it happens:**
- Plugin and example app have separate pubspec.yaml files
- Example app depends on plugin as `path:` dependency in pubspec.yaml
- Code generation can run for plugin OR example app, not both
- If only plugin regenerated, example app may use old generated code

**Consequences:**
- Example app build fails even though plugin build succeeded
- Example tests fail due to type mismatches with stale generated code
- CI/CD test step may not run example app build (oversight in configuration)
- Release blocked if example app is tested in CI/CD

**Prevention:**
- CI/CD script must regenerate code for BOTH plugin and example app
- Test script should build example app, not just plugin
- Document: "Always run ./generate.sh AND test example app before commit"
- Add explicit example app build step to CI/CD before publishing
- Validate generated files exist in both plugin/ and example/ directories

**Detection:**
- Plugin tests pass, example app build fails
- "File not found: lib/src/pigeon.dart" in example app build
- Type mismatch errors in example app code when importing from plugin
- CI/CD passes plugin checks but fails example app build step

**Phase:** CI/CD setup phase (add example app build test)

---

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|---|---|---|
| **Pigeon upgrade (26.2.3 → latest)** | Generated code format changes incompatibly; HostApi/FlutterApi signatures differ | Review Pigeon changelog for breaking changes BEFORE upgrade; regenerate in test branch; review Kotlin diffs; test Android build |
| **Freezed upgrade (3.2.5 → latest)** | Code generation format changes; `.freezed.dart` incompatible with old serialization | Test new Freezed version locally first; check generated code for format changes; validate serialization still works |
| **Android compileSdk bump (34 → 35+)** | New API requirements; RECEIVER_EXPORTED flag; newer lint rules | Audit for Build.VERSION checks; ensure RECEIVER_EXPORTED used; enable lint warnings in CI; test on Android 13+ device |
| **Kotlin upgrade (1.7.10 → 2.0+)** | Null-safety tightening; `!!` operators become errors | Replace null assertions with safe calls; enable strict null-safety checks early; refactor null-unsafe code |
| **Gradle upgrade (7.3.0 → 8.x)** | Version compatibility with Kotlin and Android Gradle Plugin | Check compatibility matrix BEFORE upgrade; upgrade one component at a time; test both plugin and example app build |
| **mtrust-api-guard integration** | Misconfiguration breaking release automation; version bumps unreliable | Test on non-main branch first; add explicit logging; validate breaking change detection; post-release verification |
| **CI/CD GitHub Actions setup** | Flutter action cache issues; generated files not regenerated; example app not built/tested | Add `flutter clean` before build; disable cache during testing; build example app in CI; validate generated files in CI check |
| **Generated file management** | Stale files not regenerated; merge conflicts; incompatible versions | Add pre-commit hook for regeneration; CI check for generated file freshness; pin exact versions for code generation tools |

---

## Validation Checklist for Phases

### Before Dependency Upgrade Phase Merges
- [ ] Pigeon regenerated; Android build succeeds without warnings
- [ ] Freezed regenerated; `.freezed.dart` and `.g.dart` formats validated
- [ ] build_runner cache cleared before regeneration
- [ ] Example app builds and runs on Android emulator
- [ ] No `!!` operators in new Android code; null-safety reviewed
- [ ] RECEIVER_EXPORTED used if compileSdk >= 33
- [ ] Generated files compared between branches (no mix of old/new formats)

### Before CI/CD Setup Phase Merges
- [ ] mtrust-api-guard tested on staging branch (not main)
- [ ] GitHub Actions workflow builds plugin AND example app
- [ ] Generated files are up-to-date check added to CI
- [ ] Lint warnings enabled; build fails on warnings
- [ ] Flutter version cached correctly; cache invalidation tested
- [ ] Release automation logs visible; debugging possible
- [ ] Post-release version/tag validation in place

---

## Sources & References

**Analysis based on:**
- Existing codebase concerns audit (.planning/codebase/CONCERNS.md)
- Current stack: Pigeon 26.2.3, Freezed 3.2.5, Kotlin 1.7.10, Gradle 7.3.0, compileSdk 34
- Flutter breaking changes documentation: https://docs.flutter.dev/release/breaking-changes
- Android API level requirements: https://developer.android.com/guide/topics/manifest/uses-sdk-element
- Kotlin compiler documentation: https://kotlinlang.org/docs/compiler-options.html
- Gradle compatibility matrix: https://docs.gradle.org/current/userguide/compatibility.html

**Why this format:**
- Each pitfall includes "Why it happens" (root cause), "Prevention" (actionable), and "Detection" (diagnostic signs)
- Phase mapping indicates which milestone/phase addresses this risk
- Validation checklist provides concrete gates to prevent pitfalls before merge

---

*Pitfall analysis: 2026-03-21*
