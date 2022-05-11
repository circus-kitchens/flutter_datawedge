# flutter_datawedge

[![pub package](https://img.shields.io/pub/v/flutter_datawedge.svg)](https://pub.dev/packages/flutter_datawedge)

A Flutter plugin communicate with DataWedge scanners

<p align="center">
 <img width="220px" src="https://raw.githubusercontent.com/rafaeljustinox/flutter_datawedge/main/.github/images/app.png" align="center" alt="Example" />
</p>

## Getting Started (under development)
#### Example with Streams
Initialize the FlutterDataWedge Object and attach a listener to the onScanResult Stream. 
``` dart
import 'package:image_picker/image_picker.dart';

    FlutterDataWedge dw = FlutterDataWedge(profileName: "Example Profile");
    StreamSubscription onScanSubscription = dw.onScanResult.listen((ScanResult result) {
        print(result.data);
    });
    
    [...]
    
    // Stop listening for new scans.
    onScanSubscription.cancel();
    dw.dispose();
```

`dispose()` will close all Streams.
