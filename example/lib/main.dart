import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initScanner();
  }

  void initScanner() {
    FlutterDataWedge.initScanner(
      profileName: 'FlutterDataWedge',
      onEvent: (event){

        Map barcodeScan = jsonDecode(event as String);
        print("Barcode: " + barcodeScan['scanData']);
        print("LabelType: " + barcodeScan['labelType']);
        print("Source: " + barcodeScan['source']);

      }
    );
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion =
          await FlutterDataWedge.platformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            ElevatedButton(
              onPressed: () {
                FlutterDataWedge.enableScanner(true);
              },
              child: Text('Testar')
            )
          ],
        ),
      ),
    );
  }

  
}
