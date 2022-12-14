
# flutter_datawedge

[![pub package](https://img.shields.io/pub/v/flutter_datawedge.svg)](https://pub.dev/packages/flutter_datawedge)

A Flutter package communicate with Zebra DataWedge scanners.

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

*Also checkout the example application.*

## Acknowledgements
The package was started by [rafaeljustinox](https://github.com/rafaeljustinox) and and contains contributions by [LenhartStephan](https://github.com/LenhartStephan).
It is now maintained by [Circus Kitchens](https://github.com/circus-kitchens).
