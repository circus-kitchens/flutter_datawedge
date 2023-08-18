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
  try {
    await dataWedge.createProfile("TestFlutter");
  } catch (e) {
    print("Creating failed...");
  }

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

  void setupListeners() async {
    await FlutterDataWedge.instance.registerForNotifications();

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
      subtitle: Wrap(spacing: 4, children: [
        Chip(
            visualDensity: VisualDensity.compact,
            label: Text(scan.labelType.name.toString())),
        Chip(
            visualDensity: VisualDensity.compact,
            label: Text(scan.decodeMode.name.toString())),
        Chip(
            visualDensity: VisualDensity.compact,
            label: Text(scan.source.name.toString()))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🦓 Flutter DataWedge Example'),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200, boxShadow: [
          BoxShadow(color: Colors.grey.shade400, blurRadius: 10)
        ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTapDown: (details) {
                  FlutterDataWedge.instance.softScanTrigger(true);
                },
                onTapUp: (details) {
                  FlutterDataWedge.instance.softScanTrigger(false);
                },
                onTapCancel: () {
                  FlutterDataWedge.instance.softScanTrigger(false);
                },
                child: ElevatedButton(
                  child: Text("Trigger"),
                  onPressed:
                      _status?.newState == ScannerState.waiting ? () {} : null,
                ),
              ),
              Row(
                children: [
                  Text((_status?.newState.toString() ?? "Unknown"),
                      style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
              SizedBox(
                height: 8,
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
        padding: EdgeInsets.only(top: 8),
        separatorBuilder: (context, n) => Divider(),
        itemBuilder: _buildScan,
        itemCount: _scans.length,
      ),
    );
  }
}
