// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scanner_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ScannerStatus _$ScannerStatusFromJson(Map<String, dynamic> json) {
  return _ScannerStatus.fromJson(json);
}

/// @nodoc
mixin _$ScannerStatus {
  ScannerStatusType get status => throw _privateConstructorUsedError;
  String get profile => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScannerStatusCopyWith<ScannerStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScannerStatusCopyWith<$Res> {
  factory $ScannerStatusCopyWith(
          ScannerStatus value, $Res Function(ScannerStatus) then) =
      _$ScannerStatusCopyWithImpl<$Res, ScannerStatus>;
  @useResult
  $Res call({ScannerStatusType status, String profile});
}

/// @nodoc
class _$ScannerStatusCopyWithImpl<$Res, $Val extends ScannerStatus>
    implements $ScannerStatusCopyWith<$Res> {
  _$ScannerStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? profile = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScannerStatusType,
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScannerStatusImplCopyWith<$Res>
    implements $ScannerStatusCopyWith<$Res> {
  factory _$$ScannerStatusImplCopyWith(
          _$ScannerStatusImpl value, $Res Function(_$ScannerStatusImpl) then) =
      __$$ScannerStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ScannerStatusType status, String profile});
}

/// @nodoc
class __$$ScannerStatusImplCopyWithImpl<$Res>
    extends _$ScannerStatusCopyWithImpl<$Res, _$ScannerStatusImpl>
    implements _$$ScannerStatusImplCopyWith<$Res> {
  __$$ScannerStatusImplCopyWithImpl(
      _$ScannerStatusImpl _value, $Res Function(_$ScannerStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? profile = null,
  }) {
    return _then(_$ScannerStatusImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScannerStatusType,
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScannerStatusImpl implements _ScannerStatus {
  const _$ScannerStatusImpl({required this.status, required this.profile});

  factory _$ScannerStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScannerStatusImplFromJson(json);

  @override
  final ScannerStatusType status;
  @override
  final String profile;

  @override
  String toString() {
    return 'ScannerStatus(status: $status, profile: $profile)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScannerStatusImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, status, profile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScannerStatusImplCopyWith<_$ScannerStatusImpl> get copyWith =>
      __$$ScannerStatusImplCopyWithImpl<_$ScannerStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScannerStatusImplToJson(
      this,
    );
  }
}

abstract class _ScannerStatus implements ScannerStatus {
  const factory _ScannerStatus(
      {required final ScannerStatusType status,
      required final String profile}) = _$ScannerStatusImpl;

  factory _ScannerStatus.fromJson(Map<String, dynamic> json) =
      _$ScannerStatusImpl.fromJson;

  @override
  ScannerStatusType get status;
  @override
  String get profile;
  @override
  @JsonKey(ignore: true)
  _$$ScannerStatusImplCopyWith<_$ScannerStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
