// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppointmentSummaryModel _$AppointmentSummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _AppointmentSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$AppointmentSummaryModel {
  String get patientName => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get doctorName => throw _privateConstructorUsedError;
  String get visitType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this AppointmentSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentSummaryModelCopyWith<AppointmentSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentSummaryModelCopyWith<$Res> {
  factory $AppointmentSummaryModelCopyWith(
    AppointmentSummaryModel value,
    $Res Function(AppointmentSummaryModel) then,
  ) = _$AppointmentSummaryModelCopyWithImpl<$Res, AppointmentSummaryModel>;
  @useResult
  $Res call({
    String patientName,
    String time,
    String doctorName,
    String visitType,
    String status,
  });
}

/// @nodoc
class _$AppointmentSummaryModelCopyWithImpl<
  $Res,
  $Val extends AppointmentSummaryModel
>
    implements $AppointmentSummaryModelCopyWith<$Res> {
  _$AppointmentSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patientName = null,
    Object? time = null,
    Object? doctorName = null,
    Object? visitType = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            patientName: null == patientName
                ? _value.patientName
                : patientName // ignore: cast_nullable_to_non_nullable
                      as String,
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String,
            doctorName: null == doctorName
                ? _value.doctorName
                : doctorName // ignore: cast_nullable_to_non_nullable
                      as String,
            visitType: null == visitType
                ? _value.visitType
                : visitType // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentSummaryModelImplCopyWith<$Res>
    implements $AppointmentSummaryModelCopyWith<$Res> {
  factory _$$AppointmentSummaryModelImplCopyWith(
    _$AppointmentSummaryModelImpl value,
    $Res Function(_$AppointmentSummaryModelImpl) then,
  ) = __$$AppointmentSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String patientName,
    String time,
    String doctorName,
    String visitType,
    String status,
  });
}

/// @nodoc
class __$$AppointmentSummaryModelImplCopyWithImpl<$Res>
    extends
        _$AppointmentSummaryModelCopyWithImpl<
          $Res,
          _$AppointmentSummaryModelImpl
        >
    implements _$$AppointmentSummaryModelImplCopyWith<$Res> {
  __$$AppointmentSummaryModelImplCopyWithImpl(
    _$AppointmentSummaryModelImpl _value,
    $Res Function(_$AppointmentSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppointmentSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patientName = null,
    Object? time = null,
    Object? doctorName = null,
    Object? visitType = null,
    Object? status = null,
  }) {
    return _then(
      _$AppointmentSummaryModelImpl(
        patientName: null == patientName
            ? _value.patientName
            : patientName // ignore: cast_nullable_to_non_nullable
                  as String,
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String,
        doctorName: null == doctorName
            ? _value.doctorName
            : doctorName // ignore: cast_nullable_to_non_nullable
                  as String,
        visitType: null == visitType
            ? _value.visitType
            : visitType // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentSummaryModelImpl implements _AppointmentSummaryModel {
  const _$AppointmentSummaryModelImpl({
    required this.patientName,
    required this.time,
    required this.doctorName,
    required this.visitType,
    required this.status,
  });

  factory _$AppointmentSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentSummaryModelImplFromJson(json);

  @override
  final String patientName;
  @override
  final String time;
  @override
  final String doctorName;
  @override
  final String visitType;
  @override
  final String status;

  @override
  String toString() {
    return 'AppointmentSummaryModel(patientName: $patientName, time: $time, doctorName: $doctorName, visitType: $visitType, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentSummaryModelImpl &&
            (identical(other.patientName, patientName) ||
                other.patientName == patientName) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.visitType, visitType) ||
                other.visitType == visitType) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    patientName,
    time,
    doctorName,
    visitType,
    status,
  );

  /// Create a copy of AppointmentSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentSummaryModelImplCopyWith<_$AppointmentSummaryModelImpl>
  get copyWith =>
      __$$AppointmentSummaryModelImplCopyWithImpl<
        _$AppointmentSummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentSummaryModelImplToJson(this);
  }
}

abstract class _AppointmentSummaryModel implements AppointmentSummaryModel {
  const factory _AppointmentSummaryModel({
    required final String patientName,
    required final String time,
    required final String doctorName,
    required final String visitType,
    required final String status,
  }) = _$AppointmentSummaryModelImpl;

  factory _AppointmentSummaryModel.fromJson(Map<String, dynamic> json) =
      _$AppointmentSummaryModelImpl.fromJson;

  @override
  String get patientName;
  @override
  String get time;
  @override
  String get doctorName;
  @override
  String get visitType;
  @override
  String get status;

  /// Create a copy of AppointmentSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentSummaryModelImplCopyWith<_$AppointmentSummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
