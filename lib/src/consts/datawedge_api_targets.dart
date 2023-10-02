import 'package:flutter_datawedge/src/consts/value_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum DatawedgeApiTargets with ValueEnum {
  softScanTrigger('com.symbol.datawedge.api.SOFT_SCAN_TRIGGER'),
  scannerPlugin('com.symbol.datawedge.api.SCANNER_INPUT_PLUGIN'),
  getProfiles('com.symbol.datawedge.api.GET_PROFILES_LIST'),
  getActiveProfile('com.symbol.datawedge.api.GET_ACTIVE_PROFILE');

  final String value;

  const DatawedgeApiTargets(this.value);

  static DatawedgeApiTargets fromString(String value) =>
      DatawedgeApiTargets.values.firstWhere((e) => e.value == value);
}
