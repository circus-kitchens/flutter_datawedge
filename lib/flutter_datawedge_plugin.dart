
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class FlutterDatawedgePlugin {

  //  This example implementation is based on the sample implementation at
  //  https://github.com/flutter/flutter/blob/master/examples/platform_channel/lib/main.dart
  //  That sample implementation also includes how to return data from the method

  static const String PLUGIN_PREFIX = 'com.justino.flutter_datawedge';
  static const String DATAWEDGE_PREFIX = 'com.symbol.datawedge.api';
  
  static const MethodChannel commandChannel = 
    MethodChannel('$PLUGIN_PREFIX/command');
  
  static const EventChannel scanChannel =
    EventChannel('$PLUGIN_PREFIX/scan');

  static const String _softScanTrigger = '$DATAWEDGE_PREFIX.SOFT_SCAN_TRIGGER';
  
  static const String _scannerPlugin = '$DATAWEDGE_PREFIX.SCANNER_INPUT_PLUGIN';

  static Future<String?>  platformVersion() async {
    final String? version = await commandChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> sendDataWedgeCommand(String command, String parameter) async {
    try {
      String argumentAsJson =
          jsonEncode({"command": command, "parameter": parameter});

      await commandChannel.invokeMethod(
          'sendDataWedgeCommandStringParameter', argumentAsJson);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  static Future<void> createProfile(String profileName) async {
    try {
      await commandChannel.invokeMethod('createDataWedgeProfile', profileName);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  static scannerControl(bool activate) {
    sendDataWedgeCommand(_softScanTrigger, activate ? 'START_SCANNING' : 'STOP_SCANNING');
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
    sendDataWedgeCommand(_scannerPlugin, command);
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
    sendDataWedgeCommand(_scannerPlugin, command);
  }
}
