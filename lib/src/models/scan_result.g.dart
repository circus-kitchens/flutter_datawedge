// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanResult _$ScanResultFromJson(Map<String, dynamic> json) => _ScanResult(
  data: json['scanData'] as String,
  labelType: json['labelType'] as String,
  source: json['source'] as String,
);

Map<String, dynamic> _$ScanResultToJson(_ScanResult instance) =>
    <String, dynamic>{
      'scanData': instance.data,
      'labelType': instance.labelType,
      'source': instance.source,
    };
