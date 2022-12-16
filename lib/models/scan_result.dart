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

  factory ScanResult.fromEvent(String event) {
    JsonMap eventObj = Json(event).asMap();
    return ScanResult(
      data: eventObj.getString('scanData'),
      labelType: eventObj.getString('labelType'),
      source: eventObj.getString('source'),
    );
  }
}
