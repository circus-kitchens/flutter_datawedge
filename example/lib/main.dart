import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? fdwListener;
  String _lastCode = '';

  @override
  void initState() {
    super.initState();
    initScanner();
  }

  void initScanner() {
    if (Platform.isAndroid) {
      var fdw = FlutterDataWedge(profileName: 'FlutterDataWedge');
      fdwListener = fdw.onScanResult
          .listen((code) => setState(() => _lastCode = code.data));
    }
  }

  @override
  void dispose() {
    super.dispose();
    fdwListener?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter DataWedge'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Last code:'),
              Text(_lastCode, style: Theme.of(context).textTheme.headline5),
            ],
          ),
        ),
      ),
    );
  }
}
