// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActionResult {

 String get result; String get command; String get commandIdentifier; Map<String, dynamic>? get resultInfo;
/// Create a copy of ActionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionResultCopyWith<ActionResult> get copyWith => _$ActionResultCopyWithImpl<ActionResult>(this as ActionResult, _$identity);

  /// Serializes this ActionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionResult&&(identical(other.result, result) || other.result == result)&&(identical(other.command, command) || other.command == command)&&(identical(other.commandIdentifier, commandIdentifier) || other.commandIdentifier == commandIdentifier)&&const DeepCollectionEquality().equals(other.resultInfo, resultInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,result,command,commandIdentifier,const DeepCollectionEquality().hash(resultInfo));

@override
String toString() {
  return 'ActionResult(result: $result, command: $command, commandIdentifier: $commandIdentifier, resultInfo: $resultInfo)';
}


}

/// @nodoc
abstract mixin class $ActionResultCopyWith<$Res>  {
  factory $ActionResultCopyWith(ActionResult value, $Res Function(ActionResult) _then) = _$ActionResultCopyWithImpl;
@useResult
$Res call({
 String result, String command, String commandIdentifier, Map<String, dynamic>? resultInfo
});




}
/// @nodoc
class _$ActionResultCopyWithImpl<$Res>
    implements $ActionResultCopyWith<$Res> {
  _$ActionResultCopyWithImpl(this._self, this._then);

  final ActionResult _self;
  final $Res Function(ActionResult) _then;

/// Create a copy of ActionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? result = null,Object? command = null,Object? commandIdentifier = null,Object? resultInfo = freezed,}) {
  return _then(_self.copyWith(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,command: null == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String,commandIdentifier: null == commandIdentifier ? _self.commandIdentifier : commandIdentifier // ignore: cast_nullable_to_non_nullable
as String,resultInfo: freezed == resultInfo ? _self.resultInfo : resultInfo // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionResult].
extension ActionResultPatterns on ActionResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionResult value)  $default,){
final _that = this;
switch (_that) {
case _ActionResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionResult value)?  $default,){
final _that = this;
switch (_that) {
case _ActionResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String result,  String command,  String commandIdentifier,  Map<String, dynamic>? resultInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionResult() when $default != null:
return $default(_that.result,_that.command,_that.commandIdentifier,_that.resultInfo);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String result,  String command,  String commandIdentifier,  Map<String, dynamic>? resultInfo)  $default,) {final _that = this;
switch (_that) {
case _ActionResult():
return $default(_that.result,_that.command,_that.commandIdentifier,_that.resultInfo);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String result,  String command,  String commandIdentifier,  Map<String, dynamic>? resultInfo)?  $default,) {final _that = this;
switch (_that) {
case _ActionResult() when $default != null:
return $default(_that.result,_that.command,_that.commandIdentifier,_that.resultInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionResult extends ActionResult {
  const _ActionResult({required this.result, required this.command, required this.commandIdentifier, required final  Map<String, dynamic>? resultInfo}): _resultInfo = resultInfo,super._();
  factory _ActionResult.fromJson(Map<String, dynamic> json) => _$ActionResultFromJson(json);

@override final  String result;
@override final  String command;
@override final  String commandIdentifier;
 final  Map<String, dynamic>? _resultInfo;
@override Map<String, dynamic>? get resultInfo {
  final value = _resultInfo;
  if (value == null) return null;
  if (_resultInfo is EqualUnmodifiableMapView) return _resultInfo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ActionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionResultCopyWith<_ActionResult> get copyWith => __$ActionResultCopyWithImpl<_ActionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionResult&&(identical(other.result, result) || other.result == result)&&(identical(other.command, command) || other.command == command)&&(identical(other.commandIdentifier, commandIdentifier) || other.commandIdentifier == commandIdentifier)&&const DeepCollectionEquality().equals(other._resultInfo, _resultInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,result,command,commandIdentifier,const DeepCollectionEquality().hash(_resultInfo));

@override
String toString() {
  return 'ActionResult(result: $result, command: $command, commandIdentifier: $commandIdentifier, resultInfo: $resultInfo)';
}


}

/// @nodoc
abstract mixin class _$ActionResultCopyWith<$Res> implements $ActionResultCopyWith<$Res> {
  factory _$ActionResultCopyWith(_ActionResult value, $Res Function(_ActionResult) _then) = __$ActionResultCopyWithImpl;
@override @useResult
$Res call({
 String result, String command, String commandIdentifier, Map<String, dynamic>? resultInfo
});




}
/// @nodoc
class __$ActionResultCopyWithImpl<$Res>
    implements _$ActionResultCopyWith<$Res> {
  __$ActionResultCopyWithImpl(this._self, this._then);

  final _ActionResult _self;
  final $Res Function(_ActionResult) _then;

/// Create a copy of ActionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? result = null,Object? command = null,Object? commandIdentifier = null,Object? resultInfo = freezed,}) {
  return _then(_ActionResult(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,command: null == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String,commandIdentifier: null == commandIdentifier ? _self.commandIdentifier : commandIdentifier // ignore: cast_nullable_to_non_nullable
as String,resultInfo: freezed == resultInfo ? _self._resultInfo : resultInfo // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
