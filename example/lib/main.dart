import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  dwTest();

  runApp(
    MaterialApp(
      title: 'Flutter DataWedge Example',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyApp(),
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<ScanEvent> scanSub;

  List<ScanEvent> _scans = [];

  StatusChangeEvent? _status;

  late StreamSubscription<StatusChangeEvent> statusSub;

  @override
  void initState() {
    setupListeners();
    super.initState();
  }

  void setupListeners() {
    scanSub = FlutterDataWedge.instance.scans.listen((event) {
      setState(() {
        _scans.add(event);
      });
    });
    statusSub = FlutterDataWedge.instance.status.listen((event) {
      setState(() {
        _status = event;
      });
    });
  }

  @override
  void dispose() {
    statusSub.cancel();
    scanSub.cancel();
    super.dispose();
  }

  Widget _buildScan(BuildContext context, int index) {
    final scan = _scans[index];

    return ListTile(
      title: Text(
        scan.dataString,
        maxLines: 2,
      ),
      subtitle: Text(scan.labelType.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🦓 Flutter DataWedge Example'),
      ),
      bottomNavigationBar: Material(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                        "Scanner status: " +
                            (_status?.newState.toString() ?? "Unknown"),
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _status?.newState != ScannerState.disabled
                          ? null
                          : () async =>
                              FlutterDataWedge.instance.enablePlugin(),
                      child: Text('Enable Scanner'),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _status?.newState == ScannerState.disabled
                          ? null
                          : () async =>
                              FlutterDataWedge.instance.disablePlugin(),
                      child: Text('Disable Scanner'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_status?.newState == ScannerState.idle)
                          ? () => FlutterDataWedge.instance.resumePlugin()
                          : null,
                      child: Text('Activate Scanner'),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_status?.newState == ScannerState.waiting)
                          ? () => FlutterDataWedge.instance.suspendPlugin()
                          : null,
                      child: Text('Deactivate Scanner'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, n) => Divider(),
        itemBuilder: _buildScan,
        itemCount: _scans.length,
      ),
    );
  }
}
