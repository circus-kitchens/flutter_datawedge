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
  late StreamSubscription<ScanResult> onScanResultListener;
  late StreamSubscription<ScannerStatus> onScannerStatusListener;
  late StreamSubscription<ActionResult> onScannerEventListener;

  List<ScanResult> scanResults = [];
  String _lastStatus = '';
  late FlutterDataWedge fdw;
Future<void>? initScannerResult;
  @override
  void initState() {
    super.initState();
    initScannerResult=initScanner();
  }

  Future<void> initScanner() async {
    if (Platform.isAndroid) {
      fdw = FlutterDataWedge(profileName: 'FlutterDataWedge');
      onScanResultListener = fdw.onScanResult
          .listen((result) => setState(() => scanResults.add(result)));
      onScannerStatusListener = fdw.onScannerStatus.listen(
          (status) => setState(() => _lastStatus = status.status.toString()));
      await fdw.initialize();
    }
  }

  @override
  void dispose() {
    onScanResultListener.cancel();
    onScannerStatusListener.cancel();
    onScannerEventListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter DataWedge Example'),
      ),
      body: FutureBuilder(
        future: initScannerResult,
        builder: (context,snapshot) {
          if(snapshot.connectionState!=ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(
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
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async => fdw.enableScanner(true),
                        child: Text('Enable Scanner'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async =>  fdw.enableScanner(false),
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
          );
        }
      ),
    );
  }
}*/
