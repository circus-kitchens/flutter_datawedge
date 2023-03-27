import 'package:flutter_datawedge/src/consts/value_enum.dart';

enum DatawedgeApiTargets with ValueEnum{
  softScanTrigger('com.symbol.datawedge.api.SOFT_SCAN_TRIGGER'),
  scannerPlugin('com.symbol.datawedge.api.SCANNER_INPUT_PLUGIN');

  final String value;

  const DatawedgeApiTargets(this.value);
}
