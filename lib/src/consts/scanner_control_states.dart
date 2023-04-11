import 'package:flutter_datawedge/src/consts/value_enum.dart';

enum ScannerControlStates with ValueEnum {
  startScanning("START_SCANNING"),
  stopScanning("STOP_SCANNING");

  final String value;

  const ScannerControlStates(this.value);
}
