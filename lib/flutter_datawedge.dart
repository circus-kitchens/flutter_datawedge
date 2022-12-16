import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datawedge/consts/datawedge_api_targets.dart';
import 'package:flutter_datawedge/consts/datawedge_constants.dart';
import 'package:flutter_datawedge/consts/method_channel_methods.dart';
import 'package:flutter_datawedge/consts/scanner_control_states.dart';
import 'package:flutter_datawedge/models/scan_result.dart';
import 'package:flutter_datawedge/models/scanner_status.dart';
import 'package:strict_json/strict_json.dart';

import 'consts/scanner_plugin_command.dart';
import 'models/flutter_datawedge_exception.dart';

class FlutterDataWedge {
  String profileName;
  late StreamSplitter<String> _sourceStream;
  late Stream<ScanResult> _scanResultStream;
  late Stream<ScannerStatus> _scannerStatusStream;

  final EventChannel _eventChannel = EventChannel('channels/scan');

  final MethodChannel _methodChannel = MethodChannel('channels/command');

  /// profileName: name of the DatawedgeProfile, that will be created or used
  FlutterDataWedge({required this.profileName}) {
    _createProfile(profileName);
    setUpStreams();
  }

  void setUpStreams() {
    // Create two streams based on the source stream to individually handle  scan_results and  scanner_status events
    _sourceStream = StreamSplitter<String>(_eventChannel.receiveBroadcastStream().cast<String>());
    _scanResultStream = _sourceStream
        .split()
        .where((event) => DataWedgeConstants.fromRawScannerJsonString(event) == DataWedgeConstants.scanResult)
        .map((event) => Json(event).asMap())
        .map(ScanResult.fromEventPayload);
    _scannerStatusStream = _sourceStream
        .split()
        .where((event) => DataWedgeConstants.fromRawScannerJsonString(event) == DataWedgeConstants.scannerStatus)
        .map((event) => Json(event).asMap())
        .map(ScannerStatus.fromEventPayload);
    _sourceStream.split().forEach(print);
    // Closing the source stream indicates, that no new streams will be created and buffer is released
    // important for memory management
    _sourceStream.close();
  }

  Stream<ScanResult> get onScanResult => _scanResultStream;

  Stream<ScannerStatus> get onScannerStatus => _scannerStatusStream;

  Future<void> _createProfile(String profileName) => _methodChannel.invokeMethod<String>(
        MethodChannelMethods.createDataWedgeProfile.value,
        profileName,
      );

  Future<String?> platformVersion() => _methodChannel.invokeMethod<String>(
        MethodChannelMethods.getPlatformVersion.value,
      );

  Future<void> scannerControl(bool activate) => _sendDataWedgeCommand(
        DatawedgeApiTargets.softScanTrigger.value,
        activate ? ScannerControlStates.startScanning.value : ScannerControlStates.stopScanning.value,
      );

  Future<void> enableScanner(bool enable) => _sendDataWedgeCommand(
        DatawedgeApiTargets.scannerPlugin.value,
        enable ? ScannerPluginCommand.enablePlugin.value : ScannerPluginCommand.disablePlugin.value,
      );

  Future<void> activateScanner(bool activate) => _sendDataWedgeCommand(
        DatawedgeApiTargets.scannerPlugin.value,
        activate ? ScannerPluginCommand.resumePlugin.value : ScannerPluginCommand.suspendPlugin.value,
      );

  Future<void> _sendDataWedgeCommand(String command, String parameter) async {
    try {
      String argumentAsJson = jsonEncode({"command": command, "parameter": parameter});
      await _methodChannel.invokeMethod<String>(
          MethodChannelMethods.sendDataWedgeCommandStringParameter.value, argumentAsJson);
    } catch (e) {
      throw FlutterDatawedgeException("Error while sending command to DataWedge. caused by: $e");
    }
  }
}
