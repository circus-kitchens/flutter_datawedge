enum DataWedgeEventType {
  eventName('EVENT_NAME'),
  scannerStatus('SCANNER_STATUS'),
  actionResult('ACTION_RESULT'),
  scanResult('SCAN_RESULT');

  final String value;

  const DataWedgeEventType(this.value);

  static DataWedgeEventType fromMap(Map<String, dynamic> event) =>
      DataWedgeEventType.values
          .firstWhere((type) => type.value == event['EVENT_NAME']);
}
