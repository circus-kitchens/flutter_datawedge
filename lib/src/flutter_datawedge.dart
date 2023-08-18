import 'dart:async';

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
    DataWedgeFlutterApi.setup(this);
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
            intentParamters: PluginIntentParamters(
              intentOutputEnabled: true,
              intentAction: '$packageName.SCAN_EVENT',
              intentDelivery: IntentDelivery.broadcast,
            ),
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

  final _scanEvents = StreamController<ScanEvent>.broadcast();
  final _statusChangeEvents = StreamController<StatusChangeEvent>.broadcast();

  /// The stream of [ScanEvent]s that are produced by DataWedge
  Stream<ScanEvent> get scans => _scanEvents.stream;

  /// The stream of [StatusChangeEvent]s that are produced by DataWedge
  Stream<StatusChangeEvent> get status => _statusChangeEvents.stream;

  @override
  void onProfileChange() {
    print('Profile has changed');
  }

  @override
  void onConfigUpdate() {
    print('Data wedge notified of configuration change');
  }

  @override
  void onScanResult(ScanEvent scanEvent) {
    print('GOt a scan');
    _scanEvents.add(scanEvent);
  }

  @override
  void onScannerStatusChanged(StatusChangeEvent statusEvent) {
    print('Status changed');
    _statusChangeEvents.add(statusEvent);
  }

  Future<void> registerForNotifications() async {
    await _hostApi.registerForNotifications();
  }

  Future<void> softScanTrigger(bool on) async {
    await _hostApi.softScanTrigger(on);
  }

  // Plugin controls

  /// Resumes the scanning from suspended state
  Future<void> resumePlugin() async {
    final resCode = await _hostApi.resumePlugin();
  }

  /// Suspends scanning temporarily
  Future<void> suspendPlugin() async {
    final resCode = await _hostApi.suspendPlugin();
  }

  /// Disables scanning
  Future<void> disablePlugin() async {
    final resCode = await _hostApi.disablePlugin();
  }

  /// Enables scanning
  Future<void> enablePlugin() async {
    final resCode = await _hostApi.enablePlugin();
  }
}
