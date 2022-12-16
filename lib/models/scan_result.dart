import 'package:strict_json/strict_json.dart';

class ScanResult {
  String data;
  String labelType;
  String source;
  DateTime dateTime = DateTime.now();

  ScanResult({
    this.data = '',
    this.labelType = '',
    this.source = '',
  });

  factory ScanResult.fromEventPayload(JsonMap jsonMap) {
    return ScanResult(
      data: jsonMap.getString('scanData'),
      labelType: jsonMap.getString('labelType'),
      source: jsonMap.getString('source'),
    );
  }
}
