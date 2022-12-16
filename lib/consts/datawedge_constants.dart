import 'package:strict_json/strict_json.dart';

enum DataWedgeConstants {
  eventName('EVENT_NAME'),
  scannerStatus('SCANNER_STATUS'),
  scanResult('SCAN_RESULT');

  final String value;

  const DataWedgeConstants(this.value);

  static DataWedgeConstants fromString(String value) =>
      DataWedgeConstants.values.firstWhere((e) => e.value == value);

  static DataWedgeConstants fromRawScannerJsonString(String rawJson) {
    String eventType = Json(rawJson).asMap().getString(eventName.value);
    return fromString(eventType);
  }
}
