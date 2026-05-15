// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) {
  return _AppointmentModel.fromJson(json);
}

/// @nodoc
mixin _$AppointmentModel {
  String get id => throw _privateConstructorUsedError;
  String get patientId => throw _privateConstructorUsedError;
  String get patientName => throw _privateConstructorUsedError;
  String? get patientPhone => throw _privateConstructorUsedError;
  String get doctorId => throw _privateConstructorUsedError;
  String get doctorName => throw _privateConstructorUsedError;
  DateTime get dateTime => throw _privateConstructorUsedError;
  AppointmentStatus get status => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int? get queueNumber => throw _privateConstructorUsedError;
  String? get cancelledBy => throw _privateConstructorUsedError;
  String? get cancellationReason => throw _privateConstructorUsedError;

  /// Serializes this AppointmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentModelCopyWith<AppointmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentModelCopyWith<$Res> {
  factory $AppointmentModelCopyWith(
    AppointmentModel value,
    $Res Function(AppointmentModel) then,
  ) = _$AppointmentModelCopyWithImpl<$Res, AppointmentModel>;
  @useResult
  $Res call({
    String id,
    String patientId,
    String patientName,
    String? patientPhone,
    String doctorId,
    String doctorName,
    DateTime dateTime,
    AppointmentStatus status,
    String? reason,
    String? notes,
    int? queueNumber,
    String? cancelledBy,
    String? cancellationReason,
  });
}

/// @nodoc
class _$AppointmentModelCopyWithImpl<$Res, $Val extends AppointmentModel>
    implements $AppointmentModelCopyWith<$Res> {
  _$AppointmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? patientName = null,
    Object? patientPhone = freezed,
    Object? doctorId = null,
    Object? doctorName = null,
    Object? dateTime = null,
    Object? status = null,
    Object? reason = freezed,
    Object? notes = freezed,
    Object? queueNumber = freezed,
    Object? cancelledBy = freezed,
    Object? cancellationReason = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            patientId: null == patientId
                ? _value.patientId
                : patientId // ignore: cast_nullable_to_non_nullable
                      as String,
            patientName: null == patientName
                ? _value.patientName
                : patientName // ignore: cast_nullable_to_non_nullable
                      as String,
            patientPhone: freezed == patientPhone
                ? _value.patientPhone
                : patientPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            doctorId: null == doctorId
                ? _value.doctorId
                : doctorId // ignore: cast_nullable_to_non_nullable
                      as String,
            doctorName: null == doctorName
                ? _value.doctorName
                : doctorName // ignore: cast_nullable_to_non_nullable
                      as String,
            dateTime: null == dateTime
                ? _value.dateTime
                : dateTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AppointmentStatus,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            queueNumber: freezed == queueNumber
                ? _value.queueNumber
                : queueNumber // ignore: cast_nullable_to_non_nullable
                      as int?,
            cancelledBy: freezed == cancelledBy
                ? _value.cancelledBy
                : cancelledBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            cancellationReason: freezed == cancellationReason
                ? _value.cancellationReason
                : cancellationReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentModelImplCopyWith<$Res>
    implements $AppointmentModelCopyWith<$Res> {
  factory _$$AppointmentModelImplCopyWith(
    _$AppointmentModelImpl value,
    $Res Function(_$AppointmentModelImpl) then,
  ) = __$$AppointmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String patientId,
    String patientName,
    String? patientPhone,
    String doctorId,
    String doctorName,
    DateTime dateTime,
    AppointmentStatus status,
    String? reason,
    String? notes,
    int? queueNumber,
    String? cancelledBy,
    String? cancellationReason,
  });
}

/// @nodoc
class __$$AppointmentModelImplCopyWithImpl<$Res>
    extends _$AppointmentModelCopyWithImpl<$Res, _$AppointmentModelImpl>
    implements _$$AppointmentModelImplCopyWith<$Res> {
  __$$AppointmentModelImplCopyWithImpl(
    _$AppointmentModelImpl _value,
    $Res Function(_$AppointmentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? patientName = null,
    Object? patientPhone = freezed,
    Object? doctorId = null,
    Object? doctorName = null,
    Object? dateTime = null,
    Object? status = null,
    Object? reason = freezed,
    Object? notes = freezed,
    Object? queueNumber = freezed,
    Object? cancelledBy = freezed,
    Object? cancellationReason = freezed,
  }) {
    return _then(
      _$AppointmentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        patientId: null == patientId
            ? _value.patientId
            : patientId // ignore: cast_nullable_to_non_nullable
                  as String,
        patientName: null == patientName
            ? _value.patientName
            : patientName // ignore: cast_nullable_to_non_nullable
                  as String,
        patientPhone: freezed == patientPhone
            ? _value.patientPhone
            : patientPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        doctorId: null == doctorId
            ? _value.doctorId
            : doctorId // ignore: cast_nullable_to_non_nullable
                  as String,
        doctorName: null == doctorName
            ? _value.doctorName
            : doctorName // ignore: cast_nullable_to_non_nullable
                  as String,
        dateTime: null == dateTime
            ? _value.dateTime
            : dateTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AppointmentStatus,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        queueNumber: freezed == queueNumber
            ? _value.queueNumber
            : queueNumber // ignore: cast_nullable_to_non_nullable
                  as int?,
        cancelledBy: freezed == cancelledBy
            ? _value.cancelledBy
            : cancelledBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        cancellationReason: freezed == cancellationReason
            ? _value.cancellationReason
            : cancellationReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentModelImpl implements _AppointmentModel {
  const _$AppointmentModelImpl({
    required this.id,
    required this.patientId,
    required this.patientName,
    this.patientPhone,
    required this.doctorId,
    required this.doctorName,
    required this.dateTime,
    required this.status,
    this.reason,
    this.notes,
    this.queueNumber,
    this.cancelledBy,
    this.cancellationReason,
  });

  factory _$AppointmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String patientId;
  @override
  final String patientName;
  @override
  final String? patientPhone;
  @override
  final String doctorId;
  @override
  final String doctorName;
  @override
  final DateTime dateTime;
  @override
  final AppointmentStatus status;
  @override
  final String? reason;
  @override
  final String? notes;
  @override
  final int? queueNumber;
  @override
  final String? cancelledBy;
  @override
  final String? cancellationReason;

  @override
  String toString() {
    return 'AppointmentModel(id: $id, patientId: $patientId, patientName: $patientName, patientPhone: $patientPhone, doctorId: $doctorId, doctorName: $doctorName, dateTime: $dateTime, status: $status, reason: $reason, notes: $notes, queueNumber: $queueNumber, cancelledBy: $cancelledBy, cancellationReason: $cancellationReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.patientName, patientName) ||
                other.patientName == patientName) &&
            (identical(other.patientPhone, patientPhone) ||
                other.patientPhone == patientPhone) &&
            (identical(other.doctorId, doctorId) ||
                other.doctorId == doctorId) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.queueNumber, queueNumber) ||
                other.queueNumber == queueNumber) &&
            (identical(other.cancelledBy, cancelledBy) ||
                other.cancelledBy == cancelledBy) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    patientId,
    patientName,
    patientPhone,
    doctorId,
    doctorName,
    dateTime,
    status,
    reason,
    notes,
    queueNumber,
    cancelledBy,
    cancellationReason,
  );

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentModelImplCopyWith<_$AppointmentModelImpl> get copyWith =>
      __$$AppointmentModelImplCopyWithImpl<_$AppointmentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentModelImplToJson(this);
  }
}

abstract class _AppointmentModel implements AppointmentModel {
  const factory _AppointmentModel({
    required final String id,
    required final String patientId,
    required final String patientName,
    final String? patientPhone,
    required final String doctorId,
    required final String doctorName,
    required final DateTime dateTime,
    required final AppointmentStatus status,
    final String? reason,
    final String? notes,
    final int? queueNumber,
    final String? cancelledBy,
    final String? cancellationReason,
  }) = _$AppointmentModelImpl;

  factory _AppointmentModel.fromJson(Map<String, dynamic> json) =
      _$AppointmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get patientId;
  @override
  String get patientName;
  @override
  String? get patientPhone;
  @override
  String get doctorId;
  @override
  String get doctorName;
  @override
  DateTime get dateTime;
  @override
  AppointmentStatus get status;
  @override
  String? get reason;
  @override
  String? get notes;
  @override
  int? get queueNumber;
  @override
  String? get cancelledBy;
  @override
  String? get cancellationReason;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentModelImplCopyWith<_$AppointmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
