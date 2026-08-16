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
  @JsonKey(name: 'id')
  dynamic get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'patient_id')
  dynamic get patientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_id')
  dynamic get doctorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_at')
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  AppointmentStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'visit_reason')
  String? get visitReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'notes')
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'patient_name')
  String? get patientName => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_name')
  String? get doctorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'patient_phone')
  String? get patientPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'queue_number')
  int? get queueNumber => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'id') dynamic id,
    @JsonKey(name: 'patient_id') dynamic patientId,
    @JsonKey(name: 'doctor_id') dynamic doctorId,
    @JsonKey(name: 'scheduled_at') DateTime? scheduledAt,
    @JsonKey(name: 'status') AppointmentStatus status,
    @JsonKey(name: 'visit_reason') String? visitReason,
    @JsonKey(name: 'notes') String? notes,
    @JsonKey(name: 'patient_name') String? patientName,
    @JsonKey(name: 'doctor_name') String? doctorName,
    @JsonKey(name: 'patient_phone') String? patientPhone,
    @JsonKey(name: 'queue_number') int? queueNumber,
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
    Object? id = freezed,
    Object? patientId = freezed,
    Object? doctorId = freezed,
    Object? scheduledAt = freezed,
    Object? status = null,
    Object? visitReason = freezed,
    Object? notes = freezed,
    Object? patientName = freezed,
    Object? doctorName = freezed,
    Object? patientPhone = freezed,
    Object? queueNumber = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            patientId: freezed == patientId
                ? _value.patientId
                : patientId // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            doctorId: freezed == doctorId
                ? _value.doctorId
                : doctorId // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            scheduledAt: freezed == scheduledAt
                ? _value.scheduledAt
                : scheduledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AppointmentStatus,
            visitReason: freezed == visitReason
                ? _value.visitReason
                : visitReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            patientName: freezed == patientName
                ? _value.patientName
                : patientName // ignore: cast_nullable_to_non_nullable
                      as String?,
            doctorName: freezed == doctorName
                ? _value.doctorName
                : doctorName // ignore: cast_nullable_to_non_nullable
                      as String?,
            patientPhone: freezed == patientPhone
                ? _value.patientPhone
                : patientPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            queueNumber: freezed == queueNumber
                ? _value.queueNumber
                : queueNumber // ignore: cast_nullable_to_non_nullable
                      as int?,
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
    @JsonKey(name: 'id') dynamic id,
    @JsonKey(name: 'patient_id') dynamic patientId,
    @JsonKey(name: 'doctor_id') dynamic doctorId,
    @JsonKey(name: 'scheduled_at') DateTime? scheduledAt,
    @JsonKey(name: 'status') AppointmentStatus status,
    @JsonKey(name: 'visit_reason') String? visitReason,
    @JsonKey(name: 'notes') String? notes,
    @JsonKey(name: 'patient_name') String? patientName,
    @JsonKey(name: 'doctor_name') String? doctorName,
    @JsonKey(name: 'patient_phone') String? patientPhone,
    @JsonKey(name: 'queue_number') int? queueNumber,
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
    Object? id = freezed,
    Object? patientId = freezed,
    Object? doctorId = freezed,
    Object? scheduledAt = freezed,
    Object? status = null,
    Object? visitReason = freezed,
    Object? notes = freezed,
    Object? patientName = freezed,
    Object? doctorName = freezed,
    Object? patientPhone = freezed,
    Object? queueNumber = freezed,
  }) {
    return _then(
      _$AppointmentModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        patientId: freezed == patientId
            ? _value.patientId
            : patientId // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        doctorId: freezed == doctorId
            ? _value.doctorId
            : doctorId // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        scheduledAt: freezed == scheduledAt
            ? _value.scheduledAt
            : scheduledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AppointmentStatus,
        visitReason: freezed == visitReason
            ? _value.visitReason
            : visitReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        patientName: freezed == patientName
            ? _value.patientName
            : patientName // ignore: cast_nullable_to_non_nullable
                  as String?,
        doctorName: freezed == doctorName
            ? _value.doctorName
            : doctorName // ignore: cast_nullable_to_non_nullable
                  as String?,
        patientPhone: freezed == patientPhone
            ? _value.patientPhone
            : patientPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        queueNumber: freezed == queueNumber
            ? _value.queueNumber
            : queueNumber // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentModelImpl implements _AppointmentModel {
  const _$AppointmentModelImpl({
    @JsonKey(name: 'id') required this.id,
    @JsonKey(name: 'patient_id') required this.patientId,
    @JsonKey(name: 'doctor_id') required this.doctorId,
    @JsonKey(name: 'scheduled_at') this.scheduledAt,
    @JsonKey(name: 'status') required this.status,
    @JsonKey(name: 'visit_reason') this.visitReason,
    @JsonKey(name: 'notes') this.notes,
    @JsonKey(name: 'patient_name') this.patientName,
    @JsonKey(name: 'doctor_name') this.doctorName,
    @JsonKey(name: 'patient_phone') this.patientPhone,
    @JsonKey(name: 'queue_number') this.queueNumber,
  });

  factory _$AppointmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final dynamic id;
  @override
  @JsonKey(name: 'patient_id')
  final dynamic patientId;
  @override
  @JsonKey(name: 'doctor_id')
  final dynamic doctorId;
  @override
  @JsonKey(name: 'scheduled_at')
  final DateTime? scheduledAt;
  @override
  @JsonKey(name: 'status')
  final AppointmentStatus status;
  @override
  @JsonKey(name: 'visit_reason')
  final String? visitReason;
  @override
  @JsonKey(name: 'notes')
  final String? notes;
  @override
  @JsonKey(name: 'patient_name')
  final String? patientName;
  @override
  @JsonKey(name: 'doctor_name')
  final String? doctorName;
  @override
  @JsonKey(name: 'patient_phone')
  final String? patientPhone;
  @override
  @JsonKey(name: 'queue_number')
  final int? queueNumber;

  @override
  String toString() {
    return 'AppointmentModel(id: $id, patientId: $patientId, doctorId: $doctorId, scheduledAt: $scheduledAt, status: $status, visitReason: $visitReason, notes: $notes, patientName: $patientName, doctorName: $doctorName, patientPhone: $patientPhone, queueNumber: $queueNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentModelImpl &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.patientId, patientId) &&
            const DeepCollectionEquality().equals(other.doctorId, doctorId) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.visitReason, visitReason) ||
                other.visitReason == visitReason) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.patientName, patientName) ||
                other.patientName == patientName) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.patientPhone, patientPhone) ||
                other.patientPhone == patientPhone) &&
            (identical(other.queueNumber, queueNumber) ||
                other.queueNumber == queueNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(id),
    const DeepCollectionEquality().hash(patientId),
    const DeepCollectionEquality().hash(doctorId),
    scheduledAt,
    status,
    visitReason,
    notes,
    patientName,
    doctorName,
    patientPhone,
    queueNumber,
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
    @JsonKey(name: 'id') required final dynamic id,
    @JsonKey(name: 'patient_id') required final dynamic patientId,
    @JsonKey(name: 'doctor_id') required final dynamic doctorId,
    @JsonKey(name: 'scheduled_at') final DateTime? scheduledAt,
    @JsonKey(name: 'status') required final AppointmentStatus status,
    @JsonKey(name: 'visit_reason') final String? visitReason,
    @JsonKey(name: 'notes') final String? notes,
    @JsonKey(name: 'patient_name') final String? patientName,
    @JsonKey(name: 'doctor_name') final String? doctorName,
    @JsonKey(name: 'patient_phone') final String? patientPhone,
    @JsonKey(name: 'queue_number') final int? queueNumber,
  }) = _$AppointmentModelImpl;

  factory _AppointmentModel.fromJson(Map<String, dynamic> json) =
      _$AppointmentModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  dynamic get id;
  @override
  @JsonKey(name: 'patient_id')
  dynamic get patientId;
  @override
  @JsonKey(name: 'doctor_id')
  dynamic get doctorId;
  @override
  @JsonKey(name: 'scheduled_at')
  DateTime? get scheduledAt;
  @override
  @JsonKey(name: 'status')
  AppointmentStatus get status;
  @override
  @JsonKey(name: 'visit_reason')
  String? get visitReason;
  @override
  @JsonKey(name: 'notes')
  String? get notes;
  @override
  @JsonKey(name: 'patient_name')
  String? get patientName;
  @override
  @JsonKey(name: 'doctor_name')
  String? get doctorName;
  @override
  @JsonKey(name: 'patient_phone')
  String? get patientPhone;
  @override
  @JsonKey(name: 'queue_number')
  int? get queueNumber;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentModelImplCopyWith<_$AppointmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
