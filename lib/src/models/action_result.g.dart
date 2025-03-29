// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActionResult _$ActionResultFromJson(Map<String, dynamic> json) =>
    _ActionResult(
      result: json['result'] as String,
      command: json['command'] as String,
      commandIdentifier: json['commandIdentifier'] as String,
      resultInfo: json['resultInfo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ActionResultToJson(_ActionResult instance) =>
    <String, dynamic>{
      'result': instance.result,
      'command': instance.command,
      'commandIdentifier': instance.commandIdentifier,
      'resultInfo': instance.resultInfo,
    };
