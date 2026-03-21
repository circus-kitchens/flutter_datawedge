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
        primarySwatch: Colors.cyan,
      ),
      home: _MyApp(),
    ),
  );
}

Future<void> dwTest() async {
  var dataWedge = FlutterDataWedge.instance;

  var config = ProfileConfig(
    profileName: "TestFlutter",
    profileEnabled: true,
    configMode: ConfigMode.update,
    barcodeParamters: PluginBarcodeParamters(
      scannerSelection: ScannerIdentifer.auto,
      enableHardwareTrigger: true,
      enableAimMode: false,
      upcEeanLinearDecode: true,
      dataBarToUpcEan: true,
    ),
  );

  await dataWedge.setConfig(config);

  await dataWedge.enableAllDecoders("TestFlutter");
}

class _MyApp extends StatefulWidget {
  const _MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> {
  late StreamSubscription<ScanEvent> scanSub;

  final List<ScanEvent> _scans = [];

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
        Chip(visualDensity: VisualDensity.compact, label: Text(scan.labelType.name.toString())),
        Chip(visualDensity: VisualDensity.compact, label: Text(scan.decodeMode.name.toString())),
        Chip(visualDensity: VisualDensity.compact, label: Text(scan.source.name.toString()))
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
        decoration: BoxDecoration(
            color: Colors.grey.shade200, boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 10)]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTapDown: (details) {
                  FlutterDataWedge.instance.softScanTrigger(on: true);
                },
                onTapUp: (details) {
                  FlutterDataWedge.instance.softScanTrigger(on: false);
                },
                onTapCancel: () {
                  FlutterDataWedge.instance.softScanTrigger(on: false);
                },
                child: ElevatedButton(
                  onPressed: _status?.newState == ScannerState.waiting ? () {} : null,
                  child: Text("Trigger"),
                ),
              ),
              Row(
                children: [
                  Text((_status?.newState.toString() ?? "Unknown"), style: Theme.of(context).textTheme.labelLarge),
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
                          : () async => FlutterDataWedge.instance.enablePlugin(),
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
                          : () async => FlutterDataWedge.instance.disablePlugin(),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('LED Light Bar Controls', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () => FlutterDataWedge.instance.led.setLight(
                            Colors.green.shade700,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Green'),
                        ),
                        ElevatedButton(
                          onPressed: () => FlutterDataWedge.instance.led.setLight(
                            Colors.red.shade700,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Red'),
                        ),
                        ElevatedButton(
                          onPressed: () => FlutterDataWedge.instance.led.setLightSequence(
                            color1: Colors.red.shade700,
                            period1: const Duration(milliseconds: 500),
                            color2: Colors.blue.shade700,
                            period2: const Duration(milliseconds: 500),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Police Sequence'),
                        ),
                        ElevatedButton(
                          onPressed: () => FlutterDataWedge.instance.led.setLedSequenceOff(
                            Colors.green,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Green Sequence Off'),
                        ),
                        ElevatedButton(
                          onPressed: () => FlutterDataWedge.instance.led.setLedOff(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade800,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Turn Off'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 8),
              separatorBuilder: (context, n) => const Divider(),
              itemBuilder: _buildScan,
              itemCount: _scans.length,
            ),
          ),
        ],
      ),
    );
  }
}
