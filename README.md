# flutter_datawedge

[![pub package](https://img.shields.io/pub/v/flutter_datawedge.svg)](https://pub.dev/packages/flutter_datawedge)

A Flutter package to communicate with Zebra DataWedge scanners.

Internally, this package useses the [DataWedge APIs](https://techdocs.zebra.com/datawedge/latest/guide/api/overview/) and therefore is on compatible with Android.

## Getting Started

#### Example

Initialize the FlutterDataWedge Object and attach a listener to the onScanResult Stream.

``` dart

    FlutterDataWedge dw = FlutterDataWedge();
    await dw.initialize();
    await createDefaultProfile(profileName: "Example Profile");
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

### Profiles 
Unlike previous versions, this version of the package won't create a profile and configure it while calling `initialize`.
Instead a profile can be created using the `createDefaultProfile` method.
To query all available profiles use `requestProfiles`, to query the active profile use `requestActiveProfile`.
The functions `waitForProfiles` and `waitForActiveProfile` can be used to wait results after the requesting function has been called.

#### async/await

Event though the public methods enableScanner(), activateScanner() and scannerControl() are
asynchronous they return as soon as the command is executed.
Each of these methods (as well as initialize()) will cause ActionResult objects to be emitted on the
onScannerEvent Stream.
Those can be used to determine the outcome of a command and properly wait for it.
Here is a short example:

``` dart
    FlutterDataWedge dw = FlutterDataWedge();
    await dw.initialize();
    
    // This would be a properly awaited version of enableScanner
    Future<ActionResult> enableScanner() {
        final completer = Completer<ActionResult>();
        final myIdentifier = "someIdentifier";
        
        StreamSubscription onScannerEventSubscription = dw.onScannerEvent.listen((ActionResult result) {
            if (result.commandIdentifier == myIdentifier) {
                completer.complete(result);
            }
        });
        
        
        dw.enablescanner(true,commandIdentifier: myIdentifier);
        
        return completer.future;
    }

```

## Acknowledgements

The package was started by [rafaeljustinox](https://github.com/rafaeljustinox) and and contains
contributions by [LenhartStephan](https://github.com/LenhartStephan).
It is now maintained by [Circus Kitchens](https://github.com/circus-kitchens).
