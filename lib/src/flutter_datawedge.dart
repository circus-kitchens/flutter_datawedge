import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:flutter_datawedge/logger.dart';
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
    assert(profileName.isNotEmpty, 'Profile name cannot be empty');

    await _hostApi.createProfile(profileName);

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
  }

  /// Disables all decoders
  Future<List<Decoder>> disableAllDecoders(String profileName) async {
    return _setAllDecoders(false, profileName);
  }

  /// Get the apps package identifier
  Future<String> getPackageIdentifer() {
    return _hostApi.getPackageIdentifer();
  }

  /// Enables all decoders
  Future<List<Decoder>> enableAllDecoders(String profileName) async {
    return _setAllDecoders(true, profileName);
  }

  Future<List<Decoder>> _setAllDecoders(
    bool enabled,
    String profileName,
  ) async {
    final availableDecoders = <Decoder>[];
    for (final decoder in Decoder.values) {
      try {
        await _hostApi.setDecoder(decoder, enabled, profileName);
        availableDecoders.add(decoder);
      } catch (e) {
        logger.info('Decoder $decoder not available');
      }
    }

    return availableDecoders;
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
  @protected
  void onProfileChange() {
    logger.debug('Profile has changed');
  }

  @override
  @protected
  void onConfigUpdate() {
    logger.debug('Data wedge notified of configuration change');
  }

  @override
  @protected
  void onScanResult(ScanEvent scanEvent) {
    logger.debug('Scan result: $scanEvent');
    _scanEvents.add(scanEvent);
  }

  @override
  @protected
  void onScannerStatusChanged(StatusChangeEvent statusEvent) {
    logger.debug('Scanner status changed: ${statusEvent.newState}');
    _statusChangeEvents.add(statusEvent);
  }

  /// Register for notifications from DataWedge. This is required to receive
  /// scan events and status change events
  Future<void> registerForNotifications() async {
    await _hostApi.registerForNotifications();
  }

  /// Set the soft scan trigger
  Future<void> softScanTrigger({required bool on}) async {
    await _hostApi.softScanTrigger(on);
  }

  // Plugin controls

  /// Resumes the scanning from suspended state

  Future<void> resumePlugin() async {
    logger.debug('Resuming plugin');
    final resCode = await _hostApi.resumePlugin();
  }

  /// Suspends scanning temporarily
  Future<void> suspendPlugin() async {
    logger.debug('Suspending plugin');
    final resCode = await _hostApi.suspendPlugin();
  }

  /// Disables scanning
  Future<void> disablePlugin() async {
    logger.debug('Disabling plugin');
    final resCode = await _hostApi.disablePlugin();
  }

  /// Enables scanning
  Future<void> enablePlugin() async {
    logger.debug('Enabling plugin');
    final resCode = await _hostApi.enablePlugin();
  }
}
