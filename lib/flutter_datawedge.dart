import 'dart:async';
import 'dart:convert';

import 'package:flutter_datawedge/src/consts/empty_command.dart';
import 'package:flutter_datawedge/src/consts/value_enum.dart';
import 'package:freezed_result/freezed_result.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datawedge/models/action_result.dart';
import 'package:flutter_datawedge/models/flutter_datawedge_exception.dart';
import 'package:flutter_datawedge/models/scan_result.dart';
import 'package:flutter_datawedge/models/scanner_status.dart';
import 'package:flutter_datawedge/src/consts/datawedge_api_targets.dart';
import 'package:flutter_datawedge/src/consts/datawedge_event_type.dart';
import 'package:flutter_datawedge/src/consts/method_channel_methods.dart';
import 'package:flutter_datawedge/src/consts/scanner_control_states.dart';
import 'package:flutter_datawedge/src/consts/scanner_plugin_command.dart';

class FlutterDataWedge {
  final String profileName;

  late final Stream<ScanResult> _scanResultStream;
  late final Stream<ScannerStatus>? _scannerStatusStream;
  late final Stream<ActionResult>? _scannerEventStream;

  final EventChannel _eventChannel = EventChannel('channels/scan');
  final MethodChannel _methodChannel = MethodChannel('channels/command');

  bool _isInitialized = false;

  /// Subscribe to a stream of [ScanResult]s
  Stream<ScanResult> get onScanResult => _scanResultStream;

  /// Subscribe to a stream of [ScannerStatus]s
  Stream<ScannerStatus> get onScannerStatus => _scannerStatusStream!;

  /// Subscribe to a stream of [EventName]s
  Stream<ActionResult> get onScannerEvent => _scannerEventStream!;

  /// Create a new instance of [FlutterDataWedge]
  /// [profileName] is the name of the profile which will be created
  FlutterDataWedge({
    required this.profileName,
  }) {
    _setUpStreams();
  }

  /// Initialize the plugin
  /// This will enable onScannerStatus stream
  Future<void> initialize({String? commandIdentifier}) async {
    await _enableListeningScannerStatus(commandIdentifier: commandIdentifier);
    _isInitialized = true;
  }

  /// Manually trigger scanning or stop scanning
  /// activate: true to trigger scanner, false to stop
  ///  Zebra API Doc: https://zebra-techdocs-archive.netlify.app/datawedge/13-0/guide/api/softscantrigger/
  Future<Result<void, FlutterDatawedgeException>> scannerControl(bool activate,
          {String? commandIdentifier}) =>
      _sendDataWedgeCommand(
        DatawedgeApiTargets.softScanTrigger,
        activate
            ? ScannerControlStates.startScanning
            : ScannerControlStates.stopScanning,
        commandIdentifier: commandIdentifier,
      );

  /// Enable or Disable the scanner temporarily
  /// Can be called anytime, but slower than [activateScanner]
  /// see also: [activateScanner]
  /// Zebra API Doc: https://zebra-techdocs-archive.netlify.app/datawedge/13-0/guide/api/scannerinputplugin/
  Future<Result<void, FlutterDatawedgeException>> enableScanner(
    bool enable, {
    String? commandIdentifier,
  }) =>
      _sendDataWedgeCommand(
        DatawedgeApiTargets.scannerPlugin,
        enable
            ? ScannerPluginCommand.enablePlugin
            : ScannerPluginCommand.disablePlugin,
        commandIdentifier: commandIdentifier,
      );

  /// Enable or Disable the scanner temporarily
  /// Way quicker then [enableScanner] but can only be called when ScannerStatus in SCANNING or WAITING state
  /// Use [onScannerStatus] to listen to the current state
  /// see also: [enableScanner]
  /// Zebra API Doc: https://zebra-techdocs-archive.netlify.app/datawedge/13-0/guide/api/scannerinputplugin/
  Future<Result<void, FlutterDatawedgeException>> activateScanner(
    bool activate, {
    String? commandIdentifier,
  }) =>
      _sendDataWedgeCommand(
        DatawedgeApiTargets.scannerPlugin,
        activate
            ? ScannerPluginCommand.resumePlugin
            : ScannerPluginCommand.suspendPlugin,
        commandIdentifier: commandIdentifier,
      );

  /// Request the list of DataWedge Profiles on the device.
  /// Answers using the [onScannerEvent] stream
  /// [waitForProfiles] can be used to wait for the answer and returns a [List<String>]
  /// https://zebra-techdocs-archive.netlify.app/datawedge/13-0/guide/api/getprofileslist/
  Future<Result<void, FlutterDatawedgeException>> requestProfiles(
          {String? commandIdentifier}) =>
      _sendDataWedgeCommand(
        DatawedgeApiTargets.getProfiles,
        EmptyCommand.empty,
        commandIdentifier: commandIdentifier,
      );

  /// This function for the result of the [requestProfiles] function and return it as a [List<String>]
  /// [requestProfiles] has to be called before calling this function
  Future<List<String>> waitForProfiles() {
    final completer = Completer<List<String>>();
    final subscription = onScannerEvent.listen((event) {
      if (event.command == DatawedgeApiTargets.getProfiles) {
        final profiles = event.resultInfo!['profiles'] as List<String>;
        completer.complete(profiles);
      }
    });
    return completer.future.whenComplete(() => subscription.cancel());
  }

  /// Gets the name of the Profile currently in use by DataWedge.
  /// Answers using the [onScannerEvent] stream
  /// [waitForActiveProfile] can be used to wait for the answer and returns a [String]
  /// https://zebra-techdocs-archive.netlify.app/datawedge/13-0/guide/api/getactiveprofile/
  Future<Result<void, FlutterDatawedgeException>> requestActiveProfile(
          {String? commandIdentifier}) =>
      _sendDataWedgeCommand(
        DatawedgeApiTargets.getActiveProfile,
        EmptyCommand.empty,
        commandIdentifier: commandIdentifier,
      );

  /// This function for the result of the [requestActiveProfile] function and return it as a [String]
  /// [requestActiveProfile] has to be called before calling this function
  Future<String> waitForActiveProfile() {
    final completer = Completer<String>();
    final subscription = onScannerEvent.listen((event) {
      if (event.command == DatawedgeApiTargets.getActiveProfile) {
        final profile = event.resultInfo!['activeProfile'] as String;
        completer.complete(profile);
      }
    });
    return completer.future.whenComplete(() => subscription.cancel());
  }

  /// Create and configure a default Datawedge profile with the given name
  /// Returns when the Command is executed NOT when DataWedge is ready to be operated again
  /// For that use [onScannerEvent] to listen for the Result of the Command
  Future<void> createDefaultProfile(
          {required String profileName, String? commandIdentifier}) async =>
      _methodChannel.invokeMethod<void>(
        MethodChannelMethods.createDataWedgeProfile.value,
        jsonEncode({
          "name": profileName,
          'commandIdentifier': commandIdentifier ?? 'createProfile_$profileName'
        }),
      );

  /// Returns the version of the Android OS
  /// example: Android 4.4, Android 10
  /// see also: https://developer.android.com/reference/android/os/Build.VERSION#RELEASE
  Future<String?> platformVersion() => _methodChannel.invokeMethod<String>(
        MethodChannelMethods.getPlatformVersion.value,
      );

  Future<void> _enableListeningScannerStatus({String? commandIdentifier}) =>
      _methodChannel.invokeMethod<void>(
        MethodChannelMethods.listenScannerStatus.value,
        jsonEncode({
          'commandIdentifier':
              commandIdentifier ?? 'enableListeningStatus_$profileName'
        }),
      );

  void _setUpStreams() {
    final sourceStream = _eventChannel
        .receiveBroadcastStream()
        .where((event) => event is String)
        .cast<String>()
        .map((event) => jsonDecode(event) as Map<String, dynamic>);

    _scannerEventStream = sourceStream
        .where((event) =>
            DataWedgeEventType.fromMap(event) ==
            DataWedgeEventType.actionResult)
        .map(ActionResult.fromJson);

    _scanResultStream = sourceStream
        .where((event) =>
            DataWedgeEventType.fromMap(event) == DataWedgeEventType.scanResult)
        .map(ScanResult.fromJson);

    _scannerStatusStream = sourceStream
        .where((event) =>
            DataWedgeEventType.fromMap(event) ==
            DataWedgeEventType.scannerStatus)
        .map(ScannerStatus.fromJson);
  }

  Future<Result<void, FlutterDatawedgeException>> _sendDataWedgeCommand(
    ValueEnum command,
    ValueEnum parameter, {
    String? commandIdentifier,
  }) async {
    try {
      if (!_isInitialized) {
        return Result.failure(NotInitializedException());
      }

      await _methodChannel.invokeMethod<void>(
        MethodChannelMethods.sendDataWedgeCommandStringParameter.value,
        jsonEncode({
          "command": command.value,
          "parameter": parameter.value,
          'commandIdentifier':
              commandIdentifier ?? '${command.value}_$profileName'
        }),
      );
      return Result.success(null);
    } catch (e) {
      return Result.failure(FlutterDatawedgeException(
          "Error while sending command to DataWedge. caused by: $e"));
    }
  }
}
