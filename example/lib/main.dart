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
  String _scannerStatus = "Scanner status";
  String _lastCode = '';
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();
    initScanner();
  }

  void initScanner() {
    FlutterDataWedge.initScanner(
      profileName: 'FlutterDataWedge',
      onScan: (result){
        setState(() {
          _lastCode = result.data;
        }); 
      },
      onStatusUpdate: (result){
        ScannerStatusType status = result.status;
        setState(() {
          _scannerStatus = status.toString().split('.')[1];
        });
      }
    );

    FlutterDataWedge.listenScannerStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Last code: $_lastCode'),
              Text('Status: $_scannerStatus'),
              ElevatedButton(
                child: Text(_isEnabled ? 'Desactivate' : 'Activate'),
                onPressed: () {
                  FlutterDataWedge.enableScanner(!_isEnabled);
                  setState(() {
                    _isEnabled = !_isEnabled;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  
}
