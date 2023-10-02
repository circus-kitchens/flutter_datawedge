// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActionResultImpl _$$ActionResultImplFromJson(Map<String, dynamic> json) =>
    _$ActionResultImpl(
      result: json['result'] as String,
      command: $enumDecode(_$DatawedgeApiTargetsEnumMap, json['command']),
      commandIdentifier: json['commandIdentifier'] as String,
      resultInfo: json['resultInfo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ActionResultImplToJson(_$ActionResultImpl instance) =>
    <String, dynamic>{
      'result': instance.result,
      'command': _$DatawedgeApiTargetsEnumMap[instance.command]!,
      'commandIdentifier': instance.commandIdentifier,
      'resultInfo': instance.resultInfo,
    };

const _$DatawedgeApiTargetsEnumMap = {
  DatawedgeApiTargets.softScanTrigger:
      'com.symbol.datawedge.api.SOFT_SCAN_TRIGGER',
  DatawedgeApiTargets.scannerPlugin:
      'com.symbol.datawedge.api.SCANNER_INPUT_PLUGIN',
  DatawedgeApiTargets.getProfiles: 'com.symbol.datawedge.api.GET_PROFILES_LIST',
  DatawedgeApiTargets.getActiveProfile:
      'com.symbol.datawedge.api.GET_ACTIVE_PROFILE',
};
