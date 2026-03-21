# Architecture Patterns: Flutter Plugin CI/CD

**Domain:** Flutter plugin continuous integration and delivery
**Researched:** 2026-03-21

## Recommended Architecture

```
┌─────────────────────────────────────────────────────────────┐
│ Developer pushes code to GitHub                            │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
        ┌─────────────────┐
        │ Pull Request    │
        │ Triggered       │
        └────────┬────────┘
                 │
    ┌────────────┴────────────┐
    │                         │
    ▼                         ▼
┌────────────────┐    ┌──────────────────┐
│ Lint Job       │    │ Format Job       │  (< 2min each)
│ - dart analyze │    │ - dart format    │  (Fast feedback)
│ - inline annot │    │ - exit if change │
└────────┬───────┘    └────────┬─────────┘
         │                     │
         └──────────┬──────────┘
                    │ (both pass)
                    ▼
         ┌──────────────────────┐
         │ Android Build Job    │  (10-15min)
         │ - gradle build       │  (Platform validation)
         │ - verify Kotlin      │
         └──────────┬───────────┘
                    │
                    ▼
         ┌──────────────────────┐
         │ Test Job             │  (< 2min)
         │ - flutter test       │  (Placeholder now)
         └──────────┬───────────┘
                    │
         ┌──────────▼──────────┐
         │ All Jobs Pass?      │
         └──────────┬──────────┘
                    │ YES
                    ▼
         ┌──────────────────────┐
         │ PR Can Be Merged     │
         │ Green Status Check   │
         └──────────────────────┘

───────────────────────────────────────────────────────────────

        After PR Merge to Main

┌─────────────────────────────────────────────────────────────┐
│ Code Pushed to main Branch                                 │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
        ┌─────────────────────┐
        │ Release Job Starts   │
        │ (if configured)     │
        └────────┬────────────┘
                 │
                 ▼
        ┌─────────────────────┐
        │ mtrust-api-guard    │
        │ - generate current  │  (< 1min)
        │ - compare to tag    │
        │ - detect changes    │
        └────────┬────────────┘
                 │
                 ▼
        ┌─────────────────────┐
        │ Version Bumped      │
        │ Changelog Generated │
        │ Git Tag Created     │
        │ (automated)         │
        └────────┬────────────┘
                 │
                 ▼
        ┌─────────────────────┐
        │ Optional: Publish   │
        │ (manual or auto)    │
        └─────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Communicates With | Failure Handling |
|-----------|---------------|-------------------|-----------------|
| Pull Request Job (Lint + Format) | Enforce code style, catch static errors early | Developer (via inline PR annotations) | Blocks PR merge if failed |
| Android Build Job | Verify plugin Kotlin compiles, no platform incompatibilities | Build artifacts (logs), Status checks | Blocks PR merge if failed |
| Test Job | Execute tests (placeholder now; real tests future), verify no regressions | Test reports, Status checks | Blocks PR merge if failed |
| Release Job | Trigger on main merge; compute next version, generate changelog, create tags | mtrust-api-guard, git, GitHub API | Fails gracefully; doesn't block main branch |

### Data Flow

1. **PR Phase:**
   - Developer pushes feature branch → GitHub detects PR
   - PR triggers pull_request.yml workflow
   - All jobs run in parallel (or in dependency order if configured)
   - Results post to PR as status checks + inline annotations
   - PR can only merge if all checks pass

2. **Release Phase:**
   - Merged code reaches main
   - Release workflow starts (if configured)
   - mtrust-api-guard compares current code to last git tag
   - Version and changelog written to files
   - New commit created with updated version/changelog
   - New git tag created
   - Optional: publish trigger or manual gate

3. **Error Recovery:**
   - If PR job fails: developer fixes locally, pushes update, workflow runs again
   - If release job fails: git state is checked; workflow can be manually re-run
   - mtrust-api-guard includes safety checks (won't proceed if uncommitted changes)

## Patterns to Follow

### Pattern 1: Sequential Job Gating
**What:** Run fast jobs first (lint, format), then slower jobs (build, test)

**When:** Always; optimizes CI feedback loop

**Example:**
```yaml
jobs:
  lint:        # 1-2 min
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: dart analyze

  format:      # 1-2 min
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: dart format --set-exit-if-changed --output none lib test

  build:       # 10-15 min (depends on lint/format if needed)
    needs: [lint, format]  # Wait for fast jobs
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: cd android && ./gradlew build
```

**Benefit:** Developers get fast feedback on style issues (2min) before waiting for slow builds (15min)

### Pattern 2: Idempotent Version Bumping
**What:** mtrust-api-guard analyzes diffs deterministically; same code = same version bump

**When:** Always use for automated versioning; eliminates human error

**Example:**
```bash
# First run on commit ABC123
mtrust-api-guard version --base-ref v1.0.0
# Detects breaking change: bumps 1.0.0 → 2.0.0

# Same commit ABC123, run again
mtrust-api-guard version --base-ref v1.0.0
# Same result: 2.0.0 (idempotent; safe to rerun)
```

**Benefit:** Version bumps are deterministic; rerunning CI jobs doesn't create multiple versions

### Pattern 3: Git Tag as Release Anchor
**What:** mtrust-api-guard creates git tag matching version; tag is source of truth

**When:** Always; enables rollback and cross-references pub.dev releases

**Example:**
```bash
# Release workflow creates:
# - Updated pubspec.yaml (version: 2.0.0)
# - Updated CHANGELOG.md (2.0.0 section with changes)
# - Git tag: v2.0.0

# Downstream can publish to pub.dev with confidence:
# "publish code at tag v2.0.0 to pub.dev as 2.0.0"
```

**Benefit:** Correlates git commits to exact versions; enables precise rollback

### Pattern 4: Placeholder Test Gateway
**What:** Empty/placeholder test file exists in CI; future tests added without workflow changes

**When:** Always maintain test job, even if placeholder; gates test infrastructure

**Example:**
```dart
// test/flutter_datawedge_test.dart - PLACEHOLDER
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeholder - replace with real tests', () {
    // This test does nothing but maintains the test gateway
    expect(true, true);
  });
}
```

**Benefit:** Future test additions (Phase 2) don't require workflow edits; gate is ready

### Pattern 5: Matrix-Free (Single Platform) Build
**What:** Build only for Android (project constraint); no matrix needed

**When:** When plugin is single-platform; simplifies CI config

**Example:**
```yaml
# DO THIS (simple):
build:
  runs-on: ubuntu-latest
  steps:
    - run: cd android && ./gradlew build

# DON'T DO THIS (unnecessary complexity):
build:
  strategy:
    matrix:
      platform: [android, ios]  # ios not supported
  runs-on: ubuntu-latest
  steps:
    - if: matrix.platform == 'android'
      run: cd android && ./gradlew build
```

**Benefit:** Simpler YAML; faster CI (no iOS setup overhead); easier maintenance

## Anti-Patterns to Avoid

### Anti-Pattern 1: Manual Version Tracking
**What goes wrong:** Developer manually edits version in pubspec.yaml; can forget, can conflict, can release wrong version

**Why it happens:** Tempting to do manually; seems simple until it causes production issues

**Consequences:** Version mismatches between code and pub.dev; confusing git history; impossible to auto-generate changelogs

**Instead:** Use mtrust-api-guard; version is always derived from API diffs; never manual

**Detection:** PR review catches manual version bumps; flag them as "should be automated"

### Anti-Pattern 2: Changelog Templating Complexity
**What goes wrong:** Custom markdown templating, complex parsing logic, tone/style decisions

**Why it happens:** "Let's make changelogs beautiful"

**Consequences:** Maintenance burden; bugs in template rendering; inconsistent formatting

**Instead:** Use mtrust-api-guard's generated changelog; it's structured and clean; sufficient for pub.dev

**Detection:** If you're writing complex string formatting for changelog, stop

### Anti-Pattern 3: Skipping Platform Build Verification
**What goes wrong:** Plugin code passes Dart analysis but Kotlin doesn't compile; discovered only when user builds

**Why it happens:** "Let's just lint and test Dart; platform code is native developer's problem"

**Consequences:** Broken releases; user frustration; erosion of trust

**Instead:** Add gradle build step to CI; takes 10-15 min; catches incompatibilities early

**Detection:** Any plugin release without platform build verification is incomplete

### Anti-Pattern 4: Test Job Without Tests
**What goes wrong:** CI runs `flutter test` but no test files exist; job always passes vacuously

**Why it happens:** "We don't have tests yet, so let's skip this job"

**Consequences:** When tests are eventually added, job failures surprise developers; workflow must be edited

**Instead:** Add placeholder test; job exists and passes; future tests added without workflow changes

**Detection:** CI job runs successfully but test file count is zero

### Anti-Pattern 5: Merging to main Without PR Checks
**What goes wrong:** Developer skips PR, pushes directly to main; broken code reaches default branch

**Why it happens:** "Just a quick fix; let's bypass the pipeline"

**Consequences:** Default branch is not tested; releases from broken code; cascading failures

**Instead:** Enforce "all code to main via PR"; protect branch in GitHub settings; require status checks

**Detection:** Check GitHub branch protection rules; main should require status checks + review

### Anti-Pattern 6: Separate Release Process
**What goes wrong:** Release workflow requires manual env setup, credentials, scripts; error-prone

**Why it happens:** "Release is special; do it locally"

**Consequences:** CI/CD is only for PRs; releases are manual; inconsistent tooling

**Instead:** Release workflow lives in .github/workflows; same GitHub Actions runner; deterministic

**Detection:** If release steps aren't automated, you have a manual process to automate

### Anti-Pattern 7: iOS Simulation in Android-Only Plugin
**What goes wrong:** Add iOS build step to CI for "completeness"; slow, unnecessary, diverges from project scope

**Why it happens:** "What if someone wants iOS later?"

**Consequences:** 5+ min slower CI per PR; maintenance burden; diverges from "Android-only" constraint

**Instead:** Don't add iOS CI; if iOS support is ever added, add CI then; PROJECT.md clearly scopes Android-only

**Detection:** CI job that serves no purpose; not tested locally; not in scope

## Scalability Considerations

| Concern | At 1 PR/day | At 10 PRs/day | At 100+ PRs/day |
|---------|------------|---------------|-----------------|
| CI runtime | Total: ~10 min per PR; acceptable | Total: ~100 min/day; acceptable | Queue depth if runners limited; not a concern for flutter_datawedge |
| Lint/format jobs | Single runner; no issue | Single runner; no issue | Could parallelize lint + format; not needed now |
| Build job | Gradle caching helps; ~10-15 min | Gradle caching; still ~10-15 min | Use GitHub Actions cache; Gradle can cache downloads |
| Storage (logs, artifacts) | Negligible | Negligible | GitHub Actions provides 400GB per repo; not a constraint |
| Version conflicts | Not an issue (sequential releases) | Not an issue (sequential releases) | Not an issue (mtrust-api-guard is deterministic) |
| Release window (after merge) | mtrust-api-guard: <2 min | Same | Same (doesn't scale poorly) |

**Recommendation:** Current architecture scales fine for flutter_datawedge. No changes needed for projected growth. If PR volume exceeds 50/day, consider job parallelization; not needed now.

## Sources

- [GitHub Actions: Jobs and steps](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [GitHub Actions: Parallel jobs](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idneeds)
- [pub.dev: mtrust_api_guard](https://pub.dev/packages/mtrust_api_guard)
- [Flutter: Plugin development](https://docs.flutter.dev/packages-and-plugins/developing-packages)
- [GitHub: Branch protection rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
