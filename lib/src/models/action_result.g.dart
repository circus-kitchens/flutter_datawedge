// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActionResultImpl _$$ActionResultImplFromJson(Map<String, dynamic> json) =>
    _$ActionResultImpl(
      result: json['result'] as String,
      command: json['command'] as String,
      commandIdentifier: json['commandIdentifier'] as String,
      resultInfo: json['resultInfo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ActionResultImplToJson(_$ActionResultImpl instance) =>
    <String, dynamic>{
      'result': instance.result,
      'command': instance.command,
      'commandIdentifier': instance.commandIdentifier,
      'resultInfo': instance.resultInfo,
    };
