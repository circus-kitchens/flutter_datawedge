# 3.1.0

- Update gradle
- (This contains all changes of previous dev builds)

# 3.1.0-dev.3

- Update freezed, json_serializable, kotlin and gradle

# 3.1.0-dev.2

- Add compatibly with Android 14. Contributed by [AhmadHusein5853](https://github.com/AhmadHusein5853)
- Update gradle, lints and kotlin
- Filter out unsupported events and add logs

# 3.1.0-dev.1

- Added a `updateProfile` function to update the configuration of a profile. Contribution by [Bobekos](https://github.com/bobekos)

# 3.0.0

- Added functions `requestProfiles` and `requestActiveProfile` to query the available profiles and the active profile
- Creating a default profile will not be automatically done when calling initialize anymore. Instead the user has to call `createDefaultProfile` manually.

# 2.1.0

- Update to Gradle 8
- Update to Kotlin 1.9
- Update to Flutter3.13

# 2.0.0

- Prerelease with breaking API changes. It enables the user to properly await until a command was send to the underlying Zebra API as well as specifying command identifiers to listen on the result of any action.

# 1.2.0

- Include changes from [LenhartStephan](https://github.com/LenhartStephan) to prevent crosstalk when several instances of package are running on one system
- Change signature of `FlutterDataWedge` constructor to always enable listening ot ScannerStatus
- Remove pubspec.lock files to match [recommendations](https://dart.dev/guides/libraries/private-files#pubspeclock)

# 1.1.0

- Add documentation for `enableScanner(bool)`,`activateScanner(bool)`,`startScanning(bool)`
- Add stream to listen to `ScannerStatus` changes
- Refactor code, emphasizing use of enums of strings etc.

# 1.0.1

- Fix wrongly named class

## 1.0.0

- Maintainer switched from [rafaeljustinox](https://github.com/rafaeljustinox) to [Circus Kitchens](https://github.com/circus-kitchens)
- Include changes from [LenhartStephan](https://github.com/LenhartStephan) which based the package on Streams
- Update Gradle to Versions 7.4

## 0.0.3

- Feature: Scanner status

## 0.0.2

- Updated className

## 0.0.1

- First version
