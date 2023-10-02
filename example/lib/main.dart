import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:flutter_datawedge_example/button_tab_view.dart';

import 'log_tab_view.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter DataWedge Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterDataWedge fdw;
  Future<void>? initScannerResult;

  @override
  void initState() {
    super.initState();
    initScannerResult = initScanner();
  }

  Future<void> initScanner() async {
    if (Platform.isAndroid) {
      fdw = FlutterDataWedge(profileName: 'FlutterDataWedge');
      await fdw.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initScannerResult,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Flutter DataWedge Example'),
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Scan'),
                    Tab(text: 'Event Log'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  ButtonTabView(this.fdw),
                  LogTabView(this.fdw),
                ],
              ),
            ),
          );
        });
  }
}
