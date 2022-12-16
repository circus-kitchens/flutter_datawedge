import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_datawedge/consts/datawedge_api_targets.dart';
import 'package:flutter_datawedge/consts/datawedge_events.dart';
import 'package:flutter_datawedge/consts/method_channel_methods.dart';
import 'package:flutter_datawedge/consts/scanner_control_states.dart';
import 'package:flutter_datawedge/models/scan_result.dart';
import 'package:strict_json/strict_json.dart';

import 'consts/scanner_plugin_command.dart';
import 'models/flutter_datawedge_exception.dart';

class FlutterDataWedge {
  String profileName;
  late Stream<String> _scanResultStream;

  final EventChannel _eventChannel = EventChannel('channels/scan');

  final MethodChannel _methodChannel = MethodChannel('channels/command');

  /// profileName: name of the DatawedgeProfile, that will be created or used
  FlutterDataWedge({required this.profileName}) {
    createProfile(profileName);
    _scanResultStream = _eventChannel.receiveBroadcastStream().cast<String>();
  }

  Stream<ScanResult> get onScanResult => _scanResultStream.map((event) {
        JsonMap eventObj = Json(event).asMap();
        String type = eventObj.getString('EVENT_NAME');
        return (type == SCAN_RESULT) ? ScanResult.fromEvent(event) : ScanResult();
      });

  Future<void> createProfile(String profileName) => _methodChannel.invokeMethod<String>(
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
