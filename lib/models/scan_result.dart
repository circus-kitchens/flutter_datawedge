import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_result.g.dart';

part 'scan_result.freezed.dart';

@freezed
class ScanResult with _$ScanResult {
  const factory ScanResult({
    @JsonKey(name: 'scanData') required String data,
    required String labelType,
    required String source,
  }) = _ScanResult;

  factory ScanResult.fromJson(Map<String, dynamic> json) => _$ScanResultFromJson(json);
}
