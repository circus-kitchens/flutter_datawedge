import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_result.g.dart';
part 'action_result.freezed.dart';

// https://techdocs.zebra.com/datawedge/latest/guide/api/resultinfo/#example
@freezed
abstract class ActionResult with _$ActionResult {
  const factory ActionResult({
    required String result,
    required String command,
    required String commandIdentifier,
    required Map<String, dynamic>? resultInfo,
  }) = _ActionResult;

  const ActionResult._();

  bool get success => result == 'SUCCESS';

  factory ActionResult.fromJson(Map<String, dynamic> json) =>
      _$ActionResultFromJson(json);
}
