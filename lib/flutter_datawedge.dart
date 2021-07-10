
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_datawedge/consts/datawedge_events.dart';
import 'package:flutter_datawedge/models/scan_result.dart';
import 'package:flutter_datawedge/models/scanner_status.dart';
export 'package:flutter_datawedge/consts/scanner_status_type.dart';

class FlutterDataWedge {
  
  static const EventChannel _eventChannel = EventChannel('channels/scan');

  static const MethodChannel _methodChannel = MethodChannel('channels/command');
  
  static const String _softScanTrigger = 'com.symbol.datawedge.api.SOFT_SCAN_TRIGGER';
  
  static const String _scannerPlugin = 'com.symbol.datawedge.api.SCANNER_INPUT_PLUGIN';

  static Future<String?>  platformVersion() async {
    final String? version = await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> _sendDataWedgeCommand(String command, String parameter) async {
    try {
      
      String argumentAsJson = jsonEncode({"command": command, "parameter": parameter});

      await _methodChannel.invokeMethod('sendDataWedgeCommandStringParameter', argumentAsJson);

    } on PlatformException {
      //  Error invoking Android method
    }
  }

  static Future<void> _createProfile(String profileName) async {
    try {
      await _methodChannel.invokeMethod('createDataWedgeProfile', profileName);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  static Future<void> _listenScannerStatus() async {
    try {
      await _methodChannel.invokeMethod('listenScannerStatus');
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  static scannerControl(bool activate) {
    _sendDataWedgeCommand(_softScanTrigger, activate ? 'START_SCANNING' : 'STOP_SCANNING');
  }
  
  static void enableScanner(bool enable){
    /**
      DISABLE_PLUGIN: disables the plug-in; scanner becomes inactive. 
                      SCANNER_STATUS notification broadcasts DISABLED state.
                      
      ENABLE_PLUGIN: enables the plug-in; scanner becomes active. SCANNER_STATUS
                     notification broadcasts WAITING and SCANNING states,
                     rotating between each depending on whether scanning is 
                     taking place.
    */
    String command = enable ? 'ENABLE_PLUGIN' : 'DISABLE_PLUGIN';
    _sendDataWedgeCommand(_scannerPlugin, command);
  }

  static void activateScanner(bool activate){
    /**
      SUSPEND_PLUGIN: suspends the scanner so it is temporarily inactive when 
                      switching from the WAITING or SCANNING state.
                      SCANNER_STATUS notification broadcasts IDLE state

      RESUME_PLUGIN:  resumes the scanner when changing from the SUSPEND_PLUGIN 
                      suspended state.
                      SCANNER_STATUS notification broadcasts WAITING and 
                      SCANNING states, rotating between each depending on 
                      whether scanning is taking place. In the WAITING state 
                      it is expecting an action from the user such as a trigger 
                      press. In the SCANNING state it is actively performing a 
                      scan resulting from an action such as a trigger press

    */
    String command = activate ? 'RESUME_PLUGIN' : 'SUSPEND_PLUGIN';
    _sendDataWedgeCommand(_scannerPlugin, command);
  }

  static initScanner({
    required String profileName,
    required void Function(ScanResult result) onScan,
    void Function(ScannerStatus result)? onStatusUpdate,
    void Function(dynamic)? onError 
  }) {
    
    _createProfile(profileName);

    _eventChannel.receiveBroadcastStream().listen(
      (dynamic event) {
        Map eventObj = jsonDecode(event as String);
        String type = eventObj['EVENT_NAME'];

        switch (type) {
          case SCAN_RESULT:
            onScan( ScanResult.fromEvent(event) );
            break;
          case SCANNER_STATUS:
            if (onStatusUpdate != null)
              onStatusUpdate( ScannerStatus.fromEvent(event) );
            break;
          default:
        }
      }, 
      onError: onError
    );

    _listenScannerStatus();
  }

}
