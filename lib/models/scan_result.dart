import 'package:strict_json/strict_json.dart';

class ScanResult {
  /// The content of the code scanned
  String data;

  /// The type of code scanned
  String labelType;
  String source;

  /// Timestamp when the scan was performed
  DateTime dateTime = DateTime.now();

  ScanResult({
    this.data = '',
    this.labelType = '',
    this.source = '',
  });

  /// Returns a [ScannerStatus] object from a JSON map returned by the native code
  factory ScanResult.fromEventPayload(JsonMap jsonMap) {
    return ScanResult(
      data: jsonMap.getString('scanData'),
      labelType: jsonMap.getString('labelType'),
      source: jsonMap.getString('source'),
    );
  }
}
