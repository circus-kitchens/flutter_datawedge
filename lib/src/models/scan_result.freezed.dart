// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScanResult {

@JsonKey(name: 'scanData') String get data; String get labelType; String get source;
/// Create a copy of ScanResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanResultCopyWith<ScanResult> get copyWith => _$ScanResultCopyWithImpl<ScanResult>(this as ScanResult, _$identity);

  /// Serializes this ScanResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanResult&&(identical(other.data, data) || other.data == data)&&(identical(other.labelType, labelType) || other.labelType == labelType)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data,labelType,source);

@override
String toString() {
  return 'ScanResult(data: $data, labelType: $labelType, source: $source)';
}


}

/// @nodoc
abstract mixin class $ScanResultCopyWith<$Res>  {
  factory $ScanResultCopyWith(ScanResult value, $Res Function(ScanResult) _then) = _$ScanResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'scanData') String data, String labelType, String source
});




}
/// @nodoc
class _$ScanResultCopyWithImpl<$Res>
    implements $ScanResultCopyWith<$Res> {
  _$ScanResultCopyWithImpl(this._self, this._then);

  final ScanResult _self;
  final $Res Function(ScanResult) _then;

/// Create a copy of ScanResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? labelType = null,Object? source = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,labelType: null == labelType ? _self.labelType : labelType // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanResult].
extension ScanResultPatterns on ScanResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanResult value)  $default,){
final _that = this;
switch (_that) {
case _ScanResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanResult value)?  $default,){
final _that = this;
switch (_that) {
case _ScanResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'scanData')  String data,  String labelType,  String source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanResult() when $default != null:
return $default(_that.data,_that.labelType,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'scanData')  String data,  String labelType,  String source)  $default,) {final _that = this;
switch (_that) {
case _ScanResult():
return $default(_that.data,_that.labelType,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'scanData')  String data,  String labelType,  String source)?  $default,) {final _that = this;
switch (_that) {
case _ScanResult() when $default != null:
return $default(_that.data,_that.labelType,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScanResult implements ScanResult {
  const _ScanResult({@JsonKey(name: 'scanData') required this.data, required this.labelType, required this.source});
  factory _ScanResult.fromJson(Map<String, dynamic> json) => _$ScanResultFromJson(json);

@override@JsonKey(name: 'scanData') final  String data;
@override final  String labelType;
@override final  String source;

/// Create a copy of ScanResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanResultCopyWith<_ScanResult> get copyWith => __$ScanResultCopyWithImpl<_ScanResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanResult&&(identical(other.data, data) || other.data == data)&&(identical(other.labelType, labelType) || other.labelType == labelType)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data,labelType,source);

@override
String toString() {
  return 'ScanResult(data: $data, labelType: $labelType, source: $source)';
}


}

/// @nodoc
abstract mixin class _$ScanResultCopyWith<$Res> implements $ScanResultCopyWith<$Res> {
  factory _$ScanResultCopyWith(_ScanResult value, $Res Function(_ScanResult) _then) = __$ScanResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'scanData') String data, String labelType, String source
});




}
/// @nodoc
class __$ScanResultCopyWithImpl<$Res>
    implements _$ScanResultCopyWith<$Res> {
  __$ScanResultCopyWithImpl(this._self, this._then);

  final _ScanResult _self;
  final $Res Function(_ScanResult) _then;

/// Create a copy of ScanResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? labelType = null,Object? source = null,}) {
  return _then(_ScanResult(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,labelType: null == labelType ? _self.labelType : labelType // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
