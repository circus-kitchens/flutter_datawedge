enum ScannerControlStates {
  startScanning("START_SCANNING"),
  stopScanning("STOP_SCANNING");

  final String value;

  const ScannerControlStates(this.value);
}
