import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_datawedge/consts/datawedge_api_targets.dart';
import 'package:flutter_datawedge/consts/datawedge_events.dart';
import 'package:flutter_datawedge/consts/method_channel_methods.dart';
import 'package:flutter_datawedge/consts/scanner_control_states.dart';
import 'package:flutter_datawedge/models/scan_result.dart';

import 'consts/scanner_plugin_command.dart';
import 'models/flutter_datawedge_exception.dart';

class FlutterDataWedge {
  String profileName;
  late Stream _scanResultStream;

  final EventChannel _eventChannel = EventChannel('channels/scan');

  final MethodChannel _methodChannel = MethodChannel('channels/command');

  /// profileName: name of the DatawedgeProfile, that will be created or used
  FlutterDataWedge({required this.profileName}) {
    createProfile(profileName);
    _scanResultStream = _eventChannel.receiveBroadcastStream();
  }

  Stream<ScanResult> get onScanResult => _scanResultStream.map((event) {
        Map eventObj = jsonDecode(event as String);
        String type = eventObj['EVENT_NAME'];
        return (type == SCAN_RESULT) ? ScanResult.fromEvent(event) : ScanResult();
      });

  Future<void> createProfile(String profileName) => _methodChannel.invokeMethod(
        MethodChannelMethods.createDataWedgeProfile.toString(),
        profileName,
      );

  Future<String?> platformVersion() => _methodChannel.invokeMethod(
        MethodChannelMethods.getPlatformVersion.toString(),
      );

  Future<void> scannerControl(bool activate) => _sendDataWedgeCommand(
        DatawedgeApiTargets.softScanTrigger.toString(),
        activate ? ScannerControlStates.startScanning.toString() : ScannerControlStates.stopScanning.toString(),
      );

  Future<void> enableScanner(bool enable) => _sendDataWedgeCommand(
        DatawedgeApiTargets.scannerPlugin.toString(),
        enable ? ScannerPluginCommand.enablePlugin.toString() : ScannerPluginCommand.disablePlugin.toString(),
      );

  Future<void> activateScanner(bool activate) => _sendDataWedgeCommand(
        DatawedgeApiTargets.scannerPlugin.toString(),
        activate ? ScannerPluginCommand.resumePlugin.toString() : ScannerPluginCommand.suspendPlugin.toString(),
      );

  Future<void> _sendDataWedgeCommand(String command, String parameter) async {
    try {
      String argumentAsJson = jsonEncode({"command": command, "parameter": parameter});
      await _methodChannel.invokeMethod(
          MethodChannelMethods.sendDataWedgeCommandStringParameter.toString(), argumentAsJson);
    } catch (e) {
      throw FlutterDatawedgeException("Error while sending command to DataWedge. caused by: $e");
    }
  }
}
