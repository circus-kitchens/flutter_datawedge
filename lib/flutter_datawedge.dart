import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_datawedge/models/flutter_datawedge_exception.dart';
import 'package:flutter_datawedge/models/scan_result.dart';
import 'package:flutter_datawedge/models/scanner_status.dart';
import 'package:flutter_datawedge/src/consts/datawedge_api_targets.dart';
import 'package:flutter_datawedge/src/consts/datawedge_constants.dart';
import 'package:flutter_datawedge/src/consts/method_channel_methods.dart';
import 'package:flutter_datawedge/src/consts/scanner_control_states.dart';
import 'package:flutter_datawedge/src/consts/scanner_plugin_command.dart';
import 'package:strict_json/strict_json.dart';

class FlutterDataWedge {
  /// Name of the DatawedgeProfile, that will be created or used
  final String profileName;

  late final Stream<ScanResult> _scanResultStream;
  late final Stream<ScannerStatus>? _scannerStatusStream;

  final EventChannel _eventChannel = EventChannel('channels/scan');
  final MethodChannel _methodChannel = MethodChannel('channels/command');

  FlutterDataWedge({
    required this.profileName,
  }) {
    _createProfile(profileName);
    _enableListeningScannerStatus();
    _setUpStreams();
  }

  /// Subscribe to a stream of [ScanResult]s
  Stream<ScanResult> get onScanResult => _scanResultStream;

  /// Subscribe to a stream of [ScannerStatus]s
  Stream<ScannerStatus> get onScannerStatus => _scannerStatusStream!;

  /// Manually trigger scanning or stop scanning
  /// activate: true to trigger scanner, false to stop
  Future<void> scannerControl(bool activate) => _sendDataWedgeCommand(
        DatawedgeApiTargets.softScanTrigger.value,
        activate
            ? ScannerControlStates.startScanning.value
            : ScannerControlStates.stopScanning.value,
      );

  /// Enable or Disable the scanner temporarily
  /// Can be called anytime, but slower than [activateScanner]
  /// see also: [activateScanner], Zebra API Doc: https://zebra-techdocs-archive.netlify.app/datawedge/11-3/guide/api/scannerinputplugin/
  Future<void> enableScanner(bool enable) => _sendDataWedgeCommand(
        DatawedgeApiTargets.scannerPlugin.value,
        enable
            ? ScannerPluginCommand.enablePlugin.value
            : ScannerPluginCommand.disablePlugin.value,
      );

  /// Enable or Disable the scanner temporarily
  /// Way quicker then [enableScanner] but can only be called when ScannerStatus in SCANNING or WAITING state
  /// Use [onScannerStatus] to listen to the current state
  /// see also: [enableScanner], Zebra API Doc: https://zebra-techdocs-archive.netlify.app/datawedge/11-3/guide/api/scannerinputplugin/
  Future<void> activateScanner(bool activate) => _sendDataWedgeCommand(
        DatawedgeApiTargets.scannerPlugin.value,
        activate
            ? ScannerPluginCommand.resumePlugin.value
            : ScannerPluginCommand.suspendPlugin.value,
      );

  /// Returns the version of the Android OS
  /// example: Android 4.4, Android 10
  /// see also: https://developer.android.com/reference/android/os/Build.VERSION#RELEASE
  Future<String?> platformVersion() => _methodChannel.invokeMethod<String>(
        MethodChannelMethods.getPlatformVersion.value,
      );

  Future<void> _createProfile(String profileName) =>
      _methodChannel.invokeMethod<String>(
        MethodChannelMethods.createDataWedgeProfile.value,
        profileName,
      );

  Future<void> _enableListeningScannerStatus() =>
      _methodChannel.invokeMethod<String>(
        MethodChannelMethods.listenScannerStatus.value,
      );

  void _setUpStreams() {
    // Create two streams based on the source stream to individually handle
    // scan_results and scanner_status events
    final sourceStream = _eventChannel
        .receiveBroadcastStream()
        .where((event) => event is String)
        .cast<String>();

    _scanResultStream = sourceStream
        .where((event) =>
            DataWedgeConstants.fromRawScannerJsonString(event) ==
            DataWedgeConstants.scanResult)
        .map((event) => Json(event).asMap())
        .map(ScanResult.fromEventPayload);

    _scannerStatusStream = sourceStream
        .where((event) =>
            DataWedgeConstants.fromRawScannerJsonString(event) ==
            DataWedgeConstants.scannerStatus)
        .map((event) => Json(event).asMap())
        .map(ScannerStatus.fromEventPayload);
  }

  Future<void> _sendDataWedgeCommand(String command, String parameter) async {
    try {
      String argumentAsJson =
          jsonEncode({"command": command, "parameter": parameter});
      await _methodChannel.invokeMethod<String>(
          MethodChannelMethods.sendDataWedgeCommandStringParameter.value,
          argumentAsJson);
    } catch (e) {
      throw FlutterDatawedgeException(
          "Error while sending command to DataWedge. caused by: $e");
    }
  }
}
