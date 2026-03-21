// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scanner_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScannerStatus {

 ScannerStatusType get status; String get profile;
/// Create a copy of ScannerStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScannerStatusCopyWith<ScannerStatus> get copyWith => _$ScannerStatusCopyWithImpl<ScannerStatus>(this as ScannerStatus, _$identity);

  /// Serializes this ScannerStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScannerStatus&&(identical(other.status, status) || other.status == status)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,profile);

@override
String toString() {
  return 'ScannerStatus(status: $status, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $ScannerStatusCopyWith<$Res>  {
  factory $ScannerStatusCopyWith(ScannerStatus value, $Res Function(ScannerStatus) _then) = _$ScannerStatusCopyWithImpl;
@useResult
$Res call({
 ScannerStatusType status, String profile
});




}
/// @nodoc
class _$ScannerStatusCopyWithImpl<$Res>
    implements $ScannerStatusCopyWith<$Res> {
  _$ScannerStatusCopyWithImpl(this._self, this._then);

  final ScannerStatus _self;
  final $Res Function(ScannerStatus) _then;

/// Create a copy of ScannerStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? profile = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScannerStatusType,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScannerStatus].
extension ScannerStatusPatterns on ScannerStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScannerStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScannerStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScannerStatus value)  $default,){
final _that = this;
switch (_that) {
case _ScannerStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScannerStatus value)?  $default,){
final _that = this;
switch (_that) {
case _ScannerStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScannerStatusType status,  String profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScannerStatus() when $default != null:
return $default(_that.status,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScannerStatusType status,  String profile)  $default,) {final _that = this;
switch (_that) {
case _ScannerStatus():
return $default(_that.status,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScannerStatusType status,  String profile)?  $default,) {final _that = this;
switch (_that) {
case _ScannerStatus() when $default != null:
return $default(_that.status,_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScannerStatus implements ScannerStatus {
  const _ScannerStatus({required this.status, required this.profile});
  factory _ScannerStatus.fromJson(Map<String, dynamic> json) => _$ScannerStatusFromJson(json);

@override final  ScannerStatusType status;
@override final  String profile;

/// Create a copy of ScannerStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScannerStatusCopyWith<_ScannerStatus> get copyWith => __$ScannerStatusCopyWithImpl<_ScannerStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScannerStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScannerStatus&&(identical(other.status, status) || other.status == status)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,profile);

@override
String toString() {
  return 'ScannerStatus(status: $status, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$ScannerStatusCopyWith<$Res> implements $ScannerStatusCopyWith<$Res> {
  factory _$ScannerStatusCopyWith(_ScannerStatus value, $Res Function(_ScannerStatus) _then) = __$ScannerStatusCopyWithImpl;
@override @useResult
$Res call({
 ScannerStatusType status, String profile
});




}
/// @nodoc
class __$ScannerStatusCopyWithImpl<$Res>
    implements _$ScannerStatusCopyWith<$Res> {
  __$ScannerStatusCopyWithImpl(this._self, this._then);

  final _ScannerStatus _self;
  final $Res Function(_ScannerStatus) _then;

/// Create a copy of ScannerStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? profile = null,}) {
  return _then(_ScannerStatus(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScannerStatusType,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
