// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanner_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScannerStatus _$ScannerStatusFromJson(Map<String, dynamic> json) =>
    _ScannerStatus(
      status: $enumDecode(_$ScannerStatusTypeEnumMap, json['status']),
      profile: json['profile'] as String,
    );

Map<String, dynamic> _$ScannerStatusToJson(_ScannerStatus instance) =>
    <String, dynamic>{
      'status': _$ScannerStatusTypeEnumMap[instance.status]!,
      'profile': instance.profile,
    };

const _$ScannerStatusTypeEnumMap = {
  ScannerStatusType.WAITING: 'WAITING',
  ScannerStatusType.SCANNING: 'SCANNING',
  ScannerStatusType.IDLE: 'IDLE',
  ScannerStatusType.DISABLED: 'DISABLED',
};
