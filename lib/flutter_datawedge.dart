import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_datawedge/consts/datawedge_events.dart';
import 'package:flutter_datawedge/consts/method_channel_methods.dart';
import 'package:flutter_datawedge/models/scan_result.dart';
import 'package:flutter_datawedge/models/scanner_control_states.dart';

import 'models/flutter_datawedge_exception.dart';
import 'models/scanner_plugin_command.dart';

export 'package:flutter_datawedge/consts/scanner_status_type.dart';

class FlutterDataWedge {
  /// Name of the DatawedgeProfile, that will be created or used
  String profileName;
  late Stream _stream;

  final EventChannel _eventChannel = EventChannel('channels/scan');

  final MethodChannel _methodChannel = MethodChannel('channels/command');

  final String _softScanTrigger = 'com.symbol.datawedge.api.SOFT_SCAN_TRIGGER';

  final String _scannerPlugin = 'com.symbol.datawedge.api.SCANNER_INPUT_PLUGIN';

  FlutterDataWedge({required this.profileName}) {
    createProfile(profileName);
    _stream = _eventChannel.receiveBroadcastStream();
  }

  Stream<ScanResult> get onScanResult => _stream.map((event) {
        Map eventObj = jsonDecode(event as String);
        String type = eventObj['EVENT_NAME'];
        return (type == SCAN_RESULT) ? ScanResult.fromEvent(event) : ScanResult(data: "", labelType: "", source: "");
      });

  Future<void> createProfile(String profileName) =>
      _methodChannel.invokeMethod(MethodChannelMethods.createDataWedgeProfile.toString(), profileName);

  Future<String?> platformVersion() => _methodChannel.invokeMethod(MethodChannelMethods.getPlatformVersion.toString());

  Future<void> scannerControl(bool activate) => _sendDataWedgeCommand(_softScanTrigger,
      activate ? ScannerControlStates.startScanning.toString() : ScannerControlStates.stopScanning.toString());

  Future<void> enableScanner(bool enable) => _sendDataWedgeCommand(_scannerPlugin,
      enable ? ScannerPluginCommand.enablePlugin.toString() : ScannerPluginCommand.disablePlugin.toString());

  Future<void> activateScanner(bool activate) => _sendDataWedgeCommand(_scannerPlugin,
      activate ? ScannerPluginCommand.resumePlugin.toString() : ScannerPluginCommand.suspendPlugin.toString());

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
