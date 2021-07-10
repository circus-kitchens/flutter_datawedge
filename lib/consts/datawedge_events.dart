import 'dart:convert';

const String EVENT_NAME = 'EVENT_NAME';
const String SCANNER_STATUS = 'SCANNER_STATUS';
const String SCAN_RESULT = 'SCAN_RESULT';

enum FlutterDataWedgeEvents {
  scannerStatus,
  scanResult
}

class DataWedgeEvent {
  String? type;

  DataWedgeEvent();

  factory DataWedgeEvent.fromEvent(dynamic event) {
    Map eventObj = jsonDecode(event as String);
    String type = eventObj[EVENT_NAME];

    switch (type) {
      case SCANNER_STATUS:
        
        break;
      default:
    }

    DataWedgeEvent dataWedgeEvent = DataWedgeEvent();
    return dataWedgeEvent;
  }

}