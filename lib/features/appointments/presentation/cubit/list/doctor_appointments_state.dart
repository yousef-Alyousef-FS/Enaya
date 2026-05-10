import 'package:equatable/equatable.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';

enum DoctorAppointmentsStatus { initial, loading, success, failure }

class DoctorAppointmentsState extends Equatable {
  final DoctorAppointmentsStatus status;
  final List<AppointmentEntity> appointments;
  final List<AppointmentEntity> filteredAppointments;
  final String? errorMessage;
  final String searchQuery;
  final DateTime selectedDate;
  final AppointmentStatus? statusFilter;

  const DoctorAppointmentsState({
    this.status = DoctorAppointmentsStatus.initial,
    this.appointments = const [],
    this.filteredAppointments = const [],
    this.errorMessage,
    this.searchQuery = '',
    required this.selectedDate,
    this.statusFilter,
  });

  factory DoctorAppointmentsState.initial() {
    return DoctorAppointmentsState(selectedDate: DateTime.now());
  }

  DoctorAppointmentsState copyWith({
    DoctorAppointmentsStatus? status,
    List<AppointmentEntity>? appointments,
    List<AppointmentEntity>? filteredAppointments,
    String? errorMessage,
    String? searchQuery,
    DateTime? selectedDate,
    AppointmentStatus? statusFilter,
    bool clearStatusFilter = false,
  }) {
    return DoctorAppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDate: selectedDate ?? this.selectedDate,
      statusFilter: clearStatusFilter
          ? null
          : statusFilter ?? this.statusFilter,
    );
  }

  @override
  List<Object?> get props => [
    status,
    appointments,
    filteredAppointments,
    errorMessage,
    searchQuery,
    selectedDate,
    statusFilter,
  ];
}
