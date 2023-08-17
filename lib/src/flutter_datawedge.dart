import 'package:flutter_datawedge/src/pigeon.dart';

/// Thrown if the profile we try to create already exists
class ProfileExistsError extends Error {}

/// Thrown if the profile name passed during creation is empty
class ProfileNameEmptyError extends Error {}

/// Main class used to interact with DataWedge. Use [FlutterDataWedge.instance]
/// to access a singleton instance
class FlutterDataWedge extends DataWedgeFlutterApi {
  /// Used to create a new [FlutterDataWedge]
  FlutterDataWedge()
      : assert(
          _instCount == 0,
          'Dont construct this class. Use .instance instead',
        ) {
    _instCount++;
  }
  final DataWedgeHostApi _hostApi = DataWedgeHostApi();

  static int _instCount = 0;
  static final _flutterDataWedge = FlutterDataWedge();

  /// Get the singleton instance to this class
  static FlutterDataWedge get instance => _flutterDataWedge;

  /// create a new profile in data wedge with the name [profileName]
  /// if [autoActivate] is true, current app is added as an activation app
  /// to the profile.
  Future<void> createProfile(
    String profileName, {
    bool autoActivate = true,
  }) async {
    if (profileName.isEmpty) {
      throw ProfileNameEmptyError();
    }
    final res = await _hostApi.createProfile(profileName);

    switch (res.responseType) {
      case CreateProfileResponseType.profileAlreadyExists:
        throw ProfileExistsError();
      case CreateProfileResponseType.profileNameEmpty:
        throw ProfileNameEmptyError();
      case CreateProfileResponseType.profileCreated:
        if (autoActivate) {
          final packageName = await _hostApi.getPackageIdentifer();

          final config = ProfileConfig(
            profileEnabled: true,
            profileName: profileName,
            configMode: ConfigMode.update,
            appList: [
              AppEntry(
                packageName: packageName,
                activityList: ['*'],
              ),
            ],
          );

          await setConfig(config);
        }

        break;
    }
  }

  /// Update a profile config
  Future<void> setConfig(
    ProfileConfig config,
  ) async {
    await _hostApi.setProfileConfig(config);
  }

  @override
  void onProfileChange() {}

  @override
  void onScanResult() {}

  @override
  void onScannerStatusChanged() {}
}
