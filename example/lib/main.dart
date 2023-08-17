import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  dwTest();

  runApp(
    MaterialApp(
      title: 'Flutter DataWedge Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(),
    ),
  );
}

Future<void> dwTest() async {
  var dataWedge = FlutterDataWedge.instance;

  print("Creating profile...");
  await dataWedge.createProfile("TestFlutter");
  print("Created profiele...");

  var config = ProfileConfig(
      profileName: "TestFlutter",
      profileEnabled: true,
      configMode: ConfigMode.update,
      barcodeParamters: PluginBarcodeParamters(
          //configureAllScanners: true,
          scannerSelection: ScannerIdentifer.auto,
          enableHardwareTrigger: true,
          enableAimMode: false,
          upcEeanLinearDecode: true,
          dataBarToUpcEan: true));

  await dataWedge.setConfig(config);
}

/*
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
      fdw = FlutterDataWedge();
      await fdw.initialize();
      await fdw.createDefaultProfile(profileName: "Example app profile");
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
}*/
