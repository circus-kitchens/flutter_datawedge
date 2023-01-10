import 'package:strict_json/strict_json.dart';

class ScannerStatus {
  ScannerStatusType status = ScannerStatusType.IDLE;
  String profile = '';

  ScannerStatus({required String status, required this.profile}) {
    this.status = ScannerStatusType.fromString(status);
  }

  /// Returns a [ScannerStatus] object from a JSON map returned by the native code
  factory ScannerStatus.fromEventPayload(JsonMap jsonMap) {
    return ScannerStatus(
      status: jsonMap.getString('status'),
      profile: jsonMap.getString('profile'),
    );
  }
}

enum ScannerStatusType {
  /// Scanner is enabled and ready to scan
  WAITING('WAITING'),

  /// Scanner has emitted the scan beam and scanning is in progress
  SCANNING('SCANNING'),

  /// Scanner is in one of the following states: enabled but not yet in the waiting state, in the suspended state by an intent (e.g. SUSPEND_PLUGIN) or disabled due to the hardware trigger
  IDLE('IDLE'),

  /// Scanner is disabled. This is broadcasted by the scanner plug-in when the active profile becomes disabled manually or the scanner is disabled with an intent
  DISABLED('DISABLED');

  final String value;

  const ScannerStatusType(this.value);

  static ScannerStatusType fromString(String value) =>
      ScannerStatusType.values.firstWhere((e) => e.value == value);
}
