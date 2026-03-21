# Testing Patterns

**Analysis Date:** 2026-03-21

## Test Framework

**Runner:**
- `flutter_test` (Flutter SDK built-in) - Used for widget and unit tests
- No additional test runners configured (e.g., no `test` package)

**Config:** No dedicated test configuration file found
- Tests discovered automatically via convention: `**/test/**/*_test.dart`
- Located in `example/test/` directory

**Assertion Library:**
- Built-in `expect()` from `flutter_test` package
- Finders API for widget testing: `find.text()`, `find.byIcon()`, `find.byType()`

**Run Commands:**
```bash
flutter test              # Run all tests in project/example
flutter test --watch     # Watch mode (if supported)
flutter test --coverage  # Generate coverage report
```

No explicit npm/pub scripts defined for testing in pubspec.yaml.

## Test File Organization

**Location:**
- Tests co-located with widget code, not separated
- Main package: Minimal tests in library itself (code is plugin)
- Example app: Tests in `example/test/` directory
  - `example/test/widget_test.dart` - Widget tests
  - `example/test/flutter_datawedge_test.dart` - Plugin integration tests

**Naming:**
- Suffix: `_test.dart`
- Examples: `widget_test.dart`, `flutter_datawedge_test.dart`

**Structure:**
```
flutter_datawedge/
├── lib/                    # No test directory (plugin library)
├── example/
│   ├── lib/
│   └── test/               # Tests for example app
│       ├── flutter_datawedge_test.dart
│       └── widget_test.dart
```

## Test Structure

**Suite Organization:**

From `example/test/widget_test.dart`:
```dart
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Setup
    await tester.pumpWidget(const MyApp());

    // Assert precondition
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Act
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Assert result
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
```

From `example/test/flutter_datawedge_test.dart`:
```dart
void main() {
  late FlutterDataWedge sut;  // System Under Test

  setUp(() {
    sut = FlutterDataWedge();
  });
}
```

**Patterns:**

- **Test structure**: Arrange-Act-Assert pattern followed implicitly (setup/verify)
- **Setup pattern**: `setUp()` block initializes test subject before each test
- **Naming convention**: `late` keyword used for objects initialized in `setUp()`
- **Variable naming**: `sut` used for "System Under Test" - the main object being tested
- **Async handling**: `async`/`await` used for asynchronous operations
- **Widget pumping**: `tester.pumpWidget()` builds widget tree, `tester.pump()` triggers frame

## Mocking

**Framework:** No explicit mocking library configured
- No `mockito` package
- No `mocktail` package
- Manual mocking would be required or must be implemented via other means

**What's NOT mocked (currently):**
- FlutterDataWedge class instantiation is direct (no mock needed for simple unit tests)
- Would require manual stub implementation if mocking becomes necessary

## Fixtures and Factories

**Test Data:** Minimal test data used currently

From `example/test/flutter_datawedge_test.dart`:
- Simple setup: `sut = FlutterDataWedge()` - direct instantiation
- No complex fixtures or test data factories

**Location:**
- Fixtures would go in same test file or `test/fixtures/` directory (not currently used)
- Test utilities/helpers in test files themselves

## Coverage

**Requirements:** No coverage requirements enforced (not configured)

**View Coverage:**
```bash
flutter test --coverage
# Generates coverage/lcov.info
```

Coverage data not currently tracked in CI/CD or required for PR acceptance.

## Test Types

**Unit Tests:**
- Minimal unit test coverage
- `flutter_datawedge_test.dart` sets up FlutterDataWedge instance but contains no assertions
- Scope: Would test individual methods and functions without platform dependencies
- Approach: Direct instantiation, no mocking, simple assertions

**Widget Tests:**
- `example/test/widget_test.dart` - Smoke test for counter widget
- Scope: Tests UI interactions and rendering
- Approach: Use `WidgetTester` for pump, tap, find operations
- Pattern:
  1. `tester.pumpWidget()` - Build widget tree
  2. `tester.tap()` - Simulate user interaction
  3. `tester.pump()` - Trigger frame rebuild
  4. `expect(find.*)` - Verify UI state

**Integration Tests:**
- Not currently present
- Would test platform channel communication with native Android code
- Should test interaction between Flutter and DataWedge platform implementation

**E2E Tests:**
- Not implemented
- Would test complete user workflows with actual hardware/emulator
- Would verify DataWedge integration end-to-end

## Common Patterns

**Async Testing:**

From `example/test/widget_test.dart`:
```dart
testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  // Build and trigger frame
  await tester.pumpWidget(const MyApp());

  // Interact and wait for rebuild
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  // Verify state
  expect(find.text('1'), findsOneWidget);
});
```

- All test callbacks accept `async` keyword
- Use `await` with platform operations: `tester.pumpWidget()`, `tester.tap()`, `tester.pump()`
- Synchronous assertions after async operations

**Error Testing:**
- Not currently demonstrated
- Would use `expect()` with `.throwsA()` or `.throwsException()` matcher
- Pattern would be:
```dart
expect(
  () => flutterDataWedge.createProfile(''),  // Empty name
  throwsA(isA<ProfileNameEmptyError>()),
);
```

Or for async operations:
```dart
expect(
  () async => await someAsyncOperation(),
  throwsA(isA<SomeException>()),
);
```

## Coverage Analysis

**Test Count:** Very minimal (2 test files)
- `widget_test.dart`: 1 smoke test
- `flutter_datawedge_test.dart`: 0 actual tests (setup only)

**Untested Areas:**
- Core FlutterDataWedge methods: `createProfile()`, `setConfig()`, `enableAllDecoders()`, etc.
- Platform channel communication (pigeon-generated code)
- Stream event handling: `scans`, `status` streams
- Error conditions and exception handling
- Logger functionality
- Model serialization/deserialization

**Coverage Gaps:** No specific coverage enforcement, significant untested code paths in library core.

---

*Testing analysis: 2026-03-21*
