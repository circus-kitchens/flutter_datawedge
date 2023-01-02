import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:flutter_datawedge/models/scan_result.dart';
import 'package:flutter_datawedge/models/scanner_status.dart';

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
  late StreamSubscription<ScanResult> onScanResultListener;
  late StreamSubscription<ScannerStatus> onScannerStatusListener;
  List<ScanResult> scanResults = [];
  String _lastStatus = '';
  late FlutterDataWedge fdw;

  @override
  void initState() {
    super.initState();
    initScanner();
  }

  void initScanner() {
    if (Platform.isAndroid) {
      fdw = FlutterDataWedge(profileName: 'FlutterDataWedge');
      onScanResultListener = fdw.onScanResult
          .listen((result) => setState(() => scanResults.add(result)));
      onScannerStatusListener = fdw.onScannerStatus.listen(
          (status) => setState(() => _lastStatus = status.status.value));
    }
  }

  @override
  void dispose() {
    onScanResultListener.cancel();
    onScannerStatusListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter DataWedge Example'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('Last codes:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.separated(
                reverse: true,
                itemCount: scanResults.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text('$index: ${scanResults[index].data}'),
                ),
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text('Last status:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                Expanded(
                  child: Text(_lastStatus,
                      style: Theme.of(context).textTheme.headline5),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => fdw.enableScanner(true),
                    child: Text('Enable Scanner'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => fdw.enableScanner(false),
                    child: Text('Disable Scanner'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => fdw.activateScanner(true),
                    child: Text('Activate Scanner'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => fdw.activateScanner(false),
                    child: Text('Deactivate Scanner'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => fdw.scannerControl(true),
                    child: Text('Scanner Control Activate'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => fdw.scannerControl(false),
                    child: Text('Scanner Control DeActivate'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
