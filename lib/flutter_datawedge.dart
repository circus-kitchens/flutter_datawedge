
import 'package:flutter_datawedge/flutter_datawedge_plugin.dart';

class FlutterDatawedge {

  static Future<void> createProfile(String profileName) async {
    return await FlutterDatawedgePlugin.createProfile(profileName);
  }

  static Future<String?> platformVersion() {
    return FlutterDatawedgePlugin.platformVersion();
  }

  static initScanner({
    required String profileName,
    required void Function(dynamic) onEvent,
    void Function(dynamic)? onError 
  }) {
    FlutterDatawedgePlugin.scanChannel.receiveBroadcastStream()
      .listen(onEvent, onError: onError);
    
    FlutterDatawedgePlugin.createProfile(profileName);
  }

}