import 'package:strict_json/strict_json.dart';

const String EVENT_NAME = 'EVENT_NAME';
const String SCANNER_STATUS = 'SCANNER_STATUS';
const String SCAN_RESULT = 'SCAN_RESULT';

enum FlutterDataWedgeEvents { scannerStatus, scanResult }

class DataWedgeEvent {
  String? type;

  DataWedgeEvent();

  factory DataWedgeEvent.fromEvent(String event) {
    //TODO
    JsonMap eventObj = Json(event).asMap();
    String type = eventObj.getString(EVENT_NAME);

    switch (type) {
      case SCANNER_STATUS:
        break;
      default:
    }

    DataWedgeEvent dataWedgeEvent = DataWedgeEvent();
    return dataWedgeEvent;
  }
}
