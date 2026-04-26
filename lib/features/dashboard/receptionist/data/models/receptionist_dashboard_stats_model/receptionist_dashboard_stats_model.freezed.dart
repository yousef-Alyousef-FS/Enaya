// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receptionist_dashboard_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReceptionistDashboardStatsModel _$ReceptionistDashboardStatsModelFromJson(
  Map<String, dynamic> json,
) {
  return _ReceptionistDashboardStatsModel.fromJson(json);
}

/// @nodoc
mixin _$ReceptionistDashboardStatsModel {
  String get receptionistName => throw _privateConstructorUsedError;
  String get shiftStatus => throw _privateConstructorUsedError;
  String get shiftStart => throw _privateConstructorUsedError;
  String get shiftEnd => throw _privateConstructorUsedError;
  int get averageWaitTimeMinutes => throw _privateConstructorUsedError;
  List<String> get topWaitingPatients => throw _privateConstructorUsedError;
  int get totalAppointments => throw _privateConstructorUsedError;
  int get waitingListCount => throw _privateConstructorUsedError;
  int get newRegistrations => throw _privateConstructorUsedError;
  int get activeCheckInDesks => throw _privateConstructorUsedError;
  String get nextCheckInPatient => throw _privateConstructorUsedError;
  String get nextCheckInTime => throw _privateConstructorUsedError;
  List<AppointmentSummaryModel> get appointments =>
      throw _privateConstructorUsedError;

  /// Serializes this ReceptionistDashboardStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReceptionistDashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceptionistDashboardStatsModelCopyWith<ReceptionistDashboardStatsModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceptionistDashboardStatsModelCopyWith<$Res> {
  factory $ReceptionistDashboardStatsModelCopyWith(
    ReceptionistDashboardStatsModel value,
    $Res Function(ReceptionistDashboardStatsModel) then,
  ) =
      _$ReceptionistDashboardStatsModelCopyWithImpl<
        $Res,
        ReceptionistDashboardStatsModel
      >;
  @useResult
  $Res call({
    String receptionistName,
    String shiftStatus,
    String shiftStart,
    String shiftEnd,
    int averageWaitTimeMinutes,
    List<String> topWaitingPatients,
    int totalAppointments,
    int waitingListCount,
    int newRegistrations,
    int activeCheckInDesks,
    String nextCheckInPatient,
    String nextCheckInTime,
    List<AppointmentSummaryModel> appointments,
  });
}

/// @nodoc
class _$ReceptionistDashboardStatsModelCopyWithImpl<
  $Res,
  $Val extends ReceptionistDashboardStatsModel
>
    implements $ReceptionistDashboardStatsModelCopyWith<$Res> {
  _$ReceptionistDashboardStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReceptionistDashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receptionistName = null,
    Object? shiftStatus = null,
    Object? shiftStart = null,
    Object? shiftEnd = null,
    Object? averageWaitTimeMinutes = null,
    Object? topWaitingPatients = null,
    Object? totalAppointments = null,
    Object? waitingListCount = null,
    Object? newRegistrations = null,
    Object? activeCheckInDesks = null,
    Object? nextCheckInPatient = null,
    Object? nextCheckInTime = null,
    Object? appointments = null,
  }) {
    return _then(
      _value.copyWith(
            receptionistName: null == receptionistName
                ? _value.receptionistName
                : receptionistName // ignore: cast_nullable_to_non_nullable
                      as String,
            shiftStatus: null == shiftStatus
                ? _value.shiftStatus
                : shiftStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            shiftStart: null == shiftStart
                ? _value.shiftStart
                : shiftStart // ignore: cast_nullable_to_non_nullable
                      as String,
            shiftEnd: null == shiftEnd
                ? _value.shiftEnd
                : shiftEnd // ignore: cast_nullable_to_non_nullable
                      as String,
            averageWaitTimeMinutes: null == averageWaitTimeMinutes
                ? _value.averageWaitTimeMinutes
                : averageWaitTimeMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            topWaitingPatients: null == topWaitingPatients
                ? _value.topWaitingPatients
                : topWaitingPatients // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            totalAppointments: null == totalAppointments
                ? _value.totalAppointments
                : totalAppointments // ignore: cast_nullable_to_non_nullable
                      as int,
            waitingListCount: null == waitingListCount
                ? _value.waitingListCount
                : waitingListCount // ignore: cast_nullable_to_non_nullable
                      as int,
            newRegistrations: null == newRegistrations
                ? _value.newRegistrations
                : newRegistrations // ignore: cast_nullable_to_non_nullable
                      as int,
            activeCheckInDesks: null == activeCheckInDesks
                ? _value.activeCheckInDesks
                : activeCheckInDesks // ignore: cast_nullable_to_non_nullable
                      as int,
            nextCheckInPatient: null == nextCheckInPatient
                ? _value.nextCheckInPatient
                : nextCheckInPatient // ignore: cast_nullable_to_non_nullable
                      as String,
            nextCheckInTime: null == nextCheckInTime
                ? _value.nextCheckInTime
                : nextCheckInTime // ignore: cast_nullable_to_non_nullable
                      as String,
            appointments: null == appointments
                ? _value.appointments
                : appointments // ignore: cast_nullable_to_non_nullable
                      as List<AppointmentSummaryModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReceptionistDashboardStatsModelImplCopyWith<$Res>
    implements $ReceptionistDashboardStatsModelCopyWith<$Res> {
  factory _$$ReceptionistDashboardStatsModelImplCopyWith(
    _$ReceptionistDashboardStatsModelImpl value,
    $Res Function(_$ReceptionistDashboardStatsModelImpl) then,
  ) = __$$ReceptionistDashboardStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String receptionistName,
    String shiftStatus,
    String shiftStart,
    String shiftEnd,
    int averageWaitTimeMinutes,
    List<String> topWaitingPatients,
    int totalAppointments,
    int waitingListCount,
    int newRegistrations,
    int activeCheckInDesks,
    String nextCheckInPatient,
    String nextCheckInTime,
    List<AppointmentSummaryModel> appointments,
  });
}

/// @nodoc
class __$$ReceptionistDashboardStatsModelImplCopyWithImpl<$Res>
    extends
        _$ReceptionistDashboardStatsModelCopyWithImpl<
          $Res,
          _$ReceptionistDashboardStatsModelImpl
        >
    implements _$$ReceptionistDashboardStatsModelImplCopyWith<$Res> {
  __$$ReceptionistDashboardStatsModelImplCopyWithImpl(
    _$ReceptionistDashboardStatsModelImpl _value,
    $Res Function(_$ReceptionistDashboardStatsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReceptionistDashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receptionistName = null,
    Object? shiftStatus = null,
    Object? shiftStart = null,
    Object? shiftEnd = null,
    Object? averageWaitTimeMinutes = null,
    Object? topWaitingPatients = null,
    Object? totalAppointments = null,
    Object? waitingListCount = null,
    Object? newRegistrations = null,
    Object? activeCheckInDesks = null,
    Object? nextCheckInPatient = null,
    Object? nextCheckInTime = null,
    Object? appointments = null,
  }) {
    return _then(
      _$ReceptionistDashboardStatsModelImpl(
        receptionistName: null == receptionistName
            ? _value.receptionistName
            : receptionistName // ignore: cast_nullable_to_non_nullable
                  as String,
        shiftStatus: null == shiftStatus
            ? _value.shiftStatus
            : shiftStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        shiftStart: null == shiftStart
            ? _value.shiftStart
            : shiftStart // ignore: cast_nullable_to_non_nullable
                  as String,
        shiftEnd: null == shiftEnd
            ? _value.shiftEnd
            : shiftEnd // ignore: cast_nullable_to_non_nullable
                  as String,
        averageWaitTimeMinutes: null == averageWaitTimeMinutes
            ? _value.averageWaitTimeMinutes
            : averageWaitTimeMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        topWaitingPatients: null == topWaitingPatients
            ? _value._topWaitingPatients
            : topWaitingPatients // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        totalAppointments: null == totalAppointments
            ? _value.totalAppointments
            : totalAppointments // ignore: cast_nullable_to_non_nullable
                  as int,
        waitingListCount: null == waitingListCount
            ? _value.waitingListCount
            : waitingListCount // ignore: cast_nullable_to_non_nullable
                  as int,
        newRegistrations: null == newRegistrations
            ? _value.newRegistrations
            : newRegistrations // ignore: cast_nullable_to_non_nullable
                  as int,
        activeCheckInDesks: null == activeCheckInDesks
            ? _value.activeCheckInDesks
            : activeCheckInDesks // ignore: cast_nullable_to_non_nullable
                  as int,
        nextCheckInPatient: null == nextCheckInPatient
            ? _value.nextCheckInPatient
            : nextCheckInPatient // ignore: cast_nullable_to_non_nullable
                  as String,
        nextCheckInTime: null == nextCheckInTime
            ? _value.nextCheckInTime
            : nextCheckInTime // ignore: cast_nullable_to_non_nullable
                  as String,
        appointments: null == appointments
            ? _value._appointments
            : appointments // ignore: cast_nullable_to_non_nullable
                  as List<AppointmentSummaryModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceptionistDashboardStatsModelImpl
    implements _ReceptionistDashboardStatsModel {
  const _$ReceptionistDashboardStatsModelImpl({
    required this.receptionistName,
    required this.shiftStatus,
    required this.shiftStart,
    required this.shiftEnd,
    required this.averageWaitTimeMinutes,
    required final List<String> topWaitingPatients,
    required this.totalAppointments,
    required this.waitingListCount,
    required this.newRegistrations,
    required this.activeCheckInDesks,
    required this.nextCheckInPatient,
    required this.nextCheckInTime,
    required final List<AppointmentSummaryModel> appointments,
  }) : _topWaitingPatients = topWaitingPatients,
       _appointments = appointments;

  factory _$ReceptionistDashboardStatsModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ReceptionistDashboardStatsModelImplFromJson(json);

  @override
  final String receptionistName;
  @override
  final String shiftStatus;
  @override
  final String shiftStart;
  @override
  final String shiftEnd;
  @override
  final int averageWaitTimeMinutes;
  final List<String> _topWaitingPatients;
  @override
  List<String> get topWaitingPatients {
    if (_topWaitingPatients is EqualUnmodifiableListView)
      return _topWaitingPatients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topWaitingPatients);
  }

  @override
  final int totalAppointments;
  @override
  final int waitingListCount;
  @override
  final int newRegistrations;
  @override
  final int activeCheckInDesks;
  @override
  final String nextCheckInPatient;
  @override
  final String nextCheckInTime;
  final List<AppointmentSummaryModel> _appointments;
  @override
  List<AppointmentSummaryModel> get appointments {
    if (_appointments is EqualUnmodifiableListView) return _appointments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appointments);
  }

  @override
  String toString() {
    return 'ReceptionistDashboardStatsModel(receptionistName: $receptionistName, shiftStatus: $shiftStatus, shiftStart: $shiftStart, shiftEnd: $shiftEnd, averageWaitTimeMinutes: $averageWaitTimeMinutes, topWaitingPatients: $topWaitingPatients, totalAppointments: $totalAppointments, waitingListCount: $waitingListCount, newRegistrations: $newRegistrations, activeCheckInDesks: $activeCheckInDesks, nextCheckInPatient: $nextCheckInPatient, nextCheckInTime: $nextCheckInTime, appointments: $appointments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceptionistDashboardStatsModelImpl &&
            (identical(other.receptionistName, receptionistName) ||
                other.receptionistName == receptionistName) &&
            (identical(other.shiftStatus, shiftStatus) ||
                other.shiftStatus == shiftStatus) &&
            (identical(other.shiftStart, shiftStart) ||
                other.shiftStart == shiftStart) &&
            (identical(other.shiftEnd, shiftEnd) ||
                other.shiftEnd == shiftEnd) &&
            (identical(other.averageWaitTimeMinutes, averageWaitTimeMinutes) ||
                other.averageWaitTimeMinutes == averageWaitTimeMinutes) &&
            const DeepCollectionEquality().equals(
              other._topWaitingPatients,
              _topWaitingPatients,
            ) &&
            (identical(other.totalAppointments, totalAppointments) ||
                other.totalAppointments == totalAppointments) &&
            (identical(other.waitingListCount, waitingListCount) ||
                other.waitingListCount == waitingListCount) &&
            (identical(other.newRegistrations, newRegistrations) ||
                other.newRegistrations == newRegistrations) &&
            (identical(other.activeCheckInDesks, activeCheckInDesks) ||
                other.activeCheckInDesks == activeCheckInDesks) &&
            (identical(other.nextCheckInPatient, nextCheckInPatient) ||
                other.nextCheckInPatient == nextCheckInPatient) &&
            (identical(other.nextCheckInTime, nextCheckInTime) ||
                other.nextCheckInTime == nextCheckInTime) &&
            const DeepCollectionEquality().equals(
              other._appointments,
              _appointments,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    receptionistName,
    shiftStatus,
    shiftStart,
    shiftEnd,
    averageWaitTimeMinutes,
    const DeepCollectionEquality().hash(_topWaitingPatients),
    totalAppointments,
    waitingListCount,
    newRegistrations,
    activeCheckInDesks,
    nextCheckInPatient,
    nextCheckInTime,
    const DeepCollectionEquality().hash(_appointments),
  );

  /// Create a copy of ReceptionistDashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceptionistDashboardStatsModelImplCopyWith<
    _$ReceptionistDashboardStatsModelImpl
  >
  get copyWith =>
      __$$ReceptionistDashboardStatsModelImplCopyWithImpl<
        _$ReceptionistDashboardStatsModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceptionistDashboardStatsModelImplToJson(this);
  }
}

abstract class _ReceptionistDashboardStatsModel
    implements ReceptionistDashboardStatsModel {
  const factory _ReceptionistDashboardStatsModel({
    required final String receptionistName,
    required final String shiftStatus,
    required final String shiftStart,
    required final String shiftEnd,
    required final int averageWaitTimeMinutes,
    required final List<String> topWaitingPatients,
    required final int totalAppointments,
    required final int waitingListCount,
    required final int newRegistrations,
    required final int activeCheckInDesks,
    required final String nextCheckInPatient,
    required final String nextCheckInTime,
    required final List<AppointmentSummaryModel> appointments,
  }) = _$ReceptionistDashboardStatsModelImpl;

  factory _ReceptionistDashboardStatsModel.fromJson(Map<String, dynamic> json) =
      _$ReceptionistDashboardStatsModelImpl.fromJson;

  @override
  String get receptionistName;
  @override
  String get shiftStatus;
  @override
  String get shiftStart;
  @override
  String get shiftEnd;
  @override
  int get averageWaitTimeMinutes;
  @override
  List<String> get topWaitingPatients;
  @override
  int get totalAppointments;
  @override
  int get waitingListCount;
  @override
  int get newRegistrations;
  @override
  int get activeCheckInDesks;
  @override
  String get nextCheckInPatient;
  @override
  String get nextCheckInTime;
  @override
  List<AppointmentSummaryModel> get appointments;

  /// Create a copy of ReceptionistDashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceptionistDashboardStatsModelImplCopyWith<
    _$ReceptionistDashboardStatsModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
