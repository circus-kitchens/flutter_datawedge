# flutter_datawedge

[![pub package](https://img.shields.io/pub/v/flutter_datawedge.svg)](https://pub.dev/packages/flutter_datawedge)

A Flutter package communicate with Zebra DataWedge scanners.

## Getting Started

Add flutter_datawedge to your project

```sh
    dart pub add flutter_datawedge
```

You can access DataWedge through the singleton

```dart

    var dataWedge = FlutterDataWedge.instance;

```

If you don't have a profile for your app, you can use

```dart
    await FlutterDataWedge.instance.createProfile("MyProfile",autoActivate: true);
```

If you want to make further adjustments to your profile you can use `setConfig`

```dart

    var config = ProfileConfig(
        profileName: "MyProfile",
        profileEnabled: true,
        configMode: ConfigMode.update,
        barcodeParamters: PluginBarcodeParamters(
            scannerSelection: ScannerIdentifer.auto,
            enableHardwareTrigger: true,
            enableAimMode: false,
        )
    );
  await FlutterDataWedge.instance.setConfig(config);
```

The parameter auto activate will configure your profile to automatically activate when your application
is in the foreground and enables intent output to receive scans.

You can then simply listen for barcodes:

```dart

    var scanSub = FlutterDataWedge.instance.scans.listen((event) {
      // Do something with a ScanEvent
      print(event.dataString);
    });

    // later

    scanSub.cancel()

```

To receive the current status of the scanner you will have to register for notifications

```dart
    await FlutterDataWedge.instance.registerForNotifications();
```

You can then listen on the stream of events

```dart
     FlutterDataWedge.instance.status.listen(....)
```

### Controlling the scanner

```dart
    await FlutterDataWedge.instance.suspendPlugin(); // Temporarily suspend scanning
    await FlutterDataWedge.instance.resumePlugin(); // Resume after suspending
    await FlutterDataWedge.instance.enablePlugin(); // Enable dw
    await FlutterDataWedge.instance.disablePlugin(); // Disable dw
```

You can also create a soft trigger:

```dart
    FlutterDataWedge.instance.softScanTrigger(true); // Starts scanning
    ...
    FlutterDataWedge.instance.softScanTrigger(false); // Stops scanning
```

## Acknowledgements

The package was started by [rafaeljustinox](https://github.com/rafaeljustinox) and and contains
contributions by [LenhartStephan](https://github.com/LenhartStephan).
It is now maintained by [Circus Kitchens](https://github.com/circus-kitchens).
