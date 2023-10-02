// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanner_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScannerStatusImpl _$$ScannerStatusImplFromJson(Map<String, dynamic> json) =>
    _$ScannerStatusImpl(
      status: $enumDecode(_$ScannerStatusTypeEnumMap, json['status']),
      profile: json['profile'] as String,
    );

Map<String, dynamic> _$$ScannerStatusImplToJson(_$ScannerStatusImpl instance) =>
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
