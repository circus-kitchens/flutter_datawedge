import 'dart:convert';

import 'package:flutter_datawedge_plus/consts/scanner_status_type.dart';

class ScannerStatus {
  ScannerStatusType status = ScannerStatusType.IDLE;
  String profile = '';

  ScannerStatus({required String status, required this.profile}) {
    switch (status) {
      case 'WAITING':
        this.status = ScannerStatusType.WAITING;
        break;
      case 'SCANNING':
        this.status = ScannerStatusType.SCANNING;
        break;
      case 'IDLE':
        this.status = ScannerStatusType.IDLE;
        break;
      case 'DISABLED':
        this.status = ScannerStatusType.DISABLED;
        break;
      default:
        this.status = ScannerStatusType.DISABLED;
        break;
    }
  }

  factory ScannerStatus.fromEvent(dynamic event) {
    Map eventObj = jsonDecode(event as String);
    ScannerStatus scanResult = ScannerStatus(
      status: eventObj['status'],
      profile: eventObj['profile'],
    );
    return scanResult;
  }
}
