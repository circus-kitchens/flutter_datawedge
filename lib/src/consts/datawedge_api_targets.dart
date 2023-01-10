enum DatawedgeApiTargets {
  softScanTrigger('com.symbol.datawedge.api.SOFT_SCAN_TRIGGER'),
  scannerPlugin('com.symbol.datawedge.api.SCANNER_INPUT_PLUGIN');

  final String value;

  const DatawedgeApiTargets(this.value);
}
