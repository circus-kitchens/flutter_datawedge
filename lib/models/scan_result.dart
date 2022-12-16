import 'dart:convert';

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

  factory ScanResult.fromEvent(dynamic event) {
    Map eventObj = jsonDecode(event as String);
    ScanResult scanResult =
        ScanResult(data: eventObj['scanData'], labelType: eventObj['labelType'], source: eventObj['source']);
    return scanResult;
  }
}
