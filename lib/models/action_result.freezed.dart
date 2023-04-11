// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ActionResult _$ActionResultFromJson(Map<String, dynamic> json) {
  return _ActionResult.fromJson(json);
}

/// @nodoc
mixin _$ActionResult {
  String get result => throw _privateConstructorUsedError;
  String get command => throw _privateConstructorUsedError;
  String get commandIdentifier => throw _privateConstructorUsedError;
  Map<String, dynamic>? get resultInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActionResultCopyWith<ActionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionResultCopyWith<$Res> {
  factory $ActionResultCopyWith(
          ActionResult value, $Res Function(ActionResult) then) =
      _$ActionResultCopyWithImpl<$Res, ActionResult>;
  @useResult
  $Res call(
      {String result,
      String command,
      String commandIdentifier,
      Map<String, dynamic>? resultInfo});
}

/// @nodoc
class _$ActionResultCopyWithImpl<$Res, $Val extends ActionResult>
    implements $ActionResultCopyWith<$Res> {
  _$ActionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? command = null,
    Object? commandIdentifier = null,
    Object? resultInfo = freezed,
  }) {
    return _then(_value.copyWith(
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String,
      command: null == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String,
      commandIdentifier: null == commandIdentifier
          ? _value.commandIdentifier
          : commandIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      resultInfo: freezed == resultInfo
          ? _value.resultInfo
          : resultInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ActionResultCopyWith<$Res>
    implements $ActionResultCopyWith<$Res> {
  factory _$$_ActionResultCopyWith(
          _$_ActionResult value, $Res Function(_$_ActionResult) then) =
      __$$_ActionResultCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String result,
      String command,
      String commandIdentifier,
      Map<String, dynamic>? resultInfo});
}

/// @nodoc
class __$$_ActionResultCopyWithImpl<$Res>
    extends _$ActionResultCopyWithImpl<$Res, _$_ActionResult>
    implements _$$_ActionResultCopyWith<$Res> {
  __$$_ActionResultCopyWithImpl(
      _$_ActionResult _value, $Res Function(_$_ActionResult) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? command = null,
    Object? commandIdentifier = null,
    Object? resultInfo = freezed,
  }) {
    return _then(_$_ActionResult(
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String,
      command: null == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String,
      commandIdentifier: null == commandIdentifier
          ? _value.commandIdentifier
          : commandIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      resultInfo: freezed == resultInfo
          ? _value._resultInfo
          : resultInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ActionResult extends _ActionResult {
  const _$_ActionResult(
      {required this.result,
      required this.command,
      required this.commandIdentifier,
      required final Map<String, dynamic>? resultInfo})
      : _resultInfo = resultInfo,
        super._();

  factory _$_ActionResult.fromJson(Map<String, dynamic> json) =>
      _$$_ActionResultFromJson(json);

  @override
  final String result;
  @override
  final String command;
  @override
  final String commandIdentifier;
  final Map<String, dynamic>? _resultInfo;
  @override
  Map<String, dynamic>? get resultInfo {
    final value = _resultInfo;
    if (value == null) return null;
    if (_resultInfo is EqualUnmodifiableMapView) return _resultInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ActionResult(result: $result, command: $command, commandIdentifier: $commandIdentifier, resultInfo: $resultInfo)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActionResult &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.command, command) || other.command == command) &&
            (identical(other.commandIdentifier, commandIdentifier) ||
                other.commandIdentifier == commandIdentifier) &&
            const DeepCollectionEquality()
                .equals(other._resultInfo, _resultInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, result, command,
      commandIdentifier, const DeepCollectionEquality().hash(_resultInfo));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActionResultCopyWith<_$_ActionResult> get copyWith =>
      __$$_ActionResultCopyWithImpl<_$_ActionResult>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActionResultToJson(
      this,
    );
  }
}

abstract class _ActionResult extends ActionResult {
  const factory _ActionResult(
      {required final String result,
      required final String command,
      required final String commandIdentifier,
      required final Map<String, dynamic>? resultInfo}) = _$_ActionResult;
  const _ActionResult._() : super._();

  factory _ActionResult.fromJson(Map<String, dynamic> json) =
      _$_ActionResult.fromJson;

  @override
  String get result;
  @override
  String get command;
  @override
  String get commandIdentifier;
  @override
  Map<String, dynamic>? get resultInfo;
  @override
  @JsonKey(ignore: true)
  _$$_ActionResultCopyWith<_$_ActionResult> get copyWith =>
      throw _privateConstructorUsedError;
}
