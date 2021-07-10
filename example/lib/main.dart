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
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
        ),
        primarySwatch: Colors.blue,
        accentColor: Colors.pinkAccent
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter DataWedge'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Last code:'),
                  Text(_lastCode, style: Theme.of(context).textTheme.headline5),
                ],
              ),
              SizedBox(height: 10.0),
              Column(
                children: [
                  Text('Status:'),
                  Text(_scannerStatus, style: Theme.of(context).textTheme.headline6),
                ],
              ),
              SizedBox(height: 10.0),
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
