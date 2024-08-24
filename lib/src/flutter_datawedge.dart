import 'dart:async';
import 'dart:convert';

import 'package:flutter_datawedge/src/consts/empty_command.dart';
import 'package:flutter_datawedge/src/consts/value_enum.dart';
import 'package:freezed_result/freezed_result.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datawedge/src/models/scanner_status.dart';
import 'package:flutter_datawedge/src/consts/datawedge_api_targets.dart';
import 'package:flutter_datawedge/src/consts/datawedge_event_type.dart';
import 'package:flutter_datawedge/src/consts/method_channel_methods.dart';
import 'package:flutter_datawedge/src/consts/scanner_control_states.dart';
import 'package:flutter_datawedge/src/consts/scanner_plugin_command.dart';
import 'package:uuid/uuid.dart';

import 'models/action_result.dart';
import 'models/flutter_datawedge_exception.dart';
import 'models/scan_result.dart';

class FlutterDataWedge {
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
  FlutterDataWedge() {
    _setUpStreams();
  }

  /// Initialize the plugin
  /// This will enable onScannerStatus stream
  Future<void> initialize({String? commandIdentifier}) async {
    final String identifier = commandIdentifier ?? Uuid().v4();
    await _enableListeningScannerStatus(identifier);
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
      if (event.command == DatawedgeApiTargets.getProfiles.value) {
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
      if (event.command == DatawedgeApiTargets.getActiveProfile.value) {
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
      {required String profileName, String? commandIdentifier}) async {
    final identifier = commandIdentifier ?? Uuid().v4();
    _methodChannel.invokeMethod<void>(
      MethodChannelMethods.createDataWedgeProfile.value,
      jsonEncode({
        "name": profileName,
        'commandIdentifier': identifier,
      }),
    );
  }

  /// update existing Datawedge profile and the specified plugin config
  /// Returns when the Command is executed NOT when DataWedge is ready to be operated again
  /// For that use [onScannerEvent] to listen for the Result of the Command
  /// Check out the official documentation https://techdocs.zebra.com/datawedge/13-0/guide/api/setconfig/
  /// to know which config attributes are supported
  Future<void> updateProfile(
      {required String profileName,
      required String pluginName,
      Map<String, dynamic> config = const {},
      String? commandIdentifier}) async {
    final identifier = commandIdentifier ?? Uuid().v4();
    _methodChannel.invokeMethod<void>(
      MethodChannelMethods.updateDataWedgeProfile.value,
      jsonEncode({
        "profileName": profileName,
        "pluginName": pluginName,
        "commandIdentifier": identifier,
        "config": config,
      }),
    );
  }

  Future<void> _enableListeningScannerStatus(String commandIdentifier) {
    return _methodChannel.invokeMethod<void>(
      MethodChannelMethods.listenScannerStatus.value,
      jsonEncode({'commandIdentifier': commandIdentifier}),
    );
  }

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
        .map((event) {
          try {
            return ActionResult.fromJson(event);
          } catch (e) {
            print('Invalid `ActionResult`: $event caused by: $e');
            return null;
          }
        })
        .where((event) => event is ActionResult)
        .cast();

    _scanResultStream = sourceStream
        .where((event) =>
            DataWedgeEventType.fromMap(event) == DataWedgeEventType.scanResult)
        .map((event) {
          try {
            return ScanResult.fromJson(event);
          } catch (e) {
            print('Invalid `ScanResult`: $event caused by: $e');
            return null;
          }
        })
        .where((event) => event is ScanResult)
        .cast();

    _scannerStatusStream = sourceStream
        .where((event) =>
            DataWedgeEventType.fromMap(event) ==
            DataWedgeEventType.scannerStatus)
        .map((event) {
          try {
            return ScannerStatus.fromJson(event);
          } catch (e) {
            print('Invalid `ScannerStatus`: $event caused by: $e');
            return null;
          }
        })
        .where((event) => event is ScannerStatus)
        .cast();
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

      final identifier = commandIdentifier ?? Uuid().v4();

      await _methodChannel.invokeMethod<void>(
        MethodChannelMethods.sendDataWedgeCommandStringParameter.value,
        jsonEncode({
          "command": command.value,
          "parameter": parameter.value,
          'commandIdentifier': identifier,
        }),
      );
      return Result.success(null);
    } catch (e) {
      return Result.failure(FlutterDatawedgeException(
          "Error while sending command to DataWedge. caused by: $e"));
    }
  }
}
