import '../../../domain/entities/appointment_entity.dart';
import 'base_appointments_state.dart';

enum PatientAppointmentsStatus { initial, loading, success, failure }

class PatientAppointmentsState extends BaseAppointmentsState {
  final PatientAppointmentsStatus status;
  final List<AppointmentEntity> upcomingAppointments;
  final List<AppointmentEntity> pastAppointments;

  const PatientAppointmentsState({
    this.status = PatientAppointmentsStatus.initial,
    required super.appointments,
    required super.filteredAppointments,
    this.upcomingAppointments = const [],
    this.pastAppointments = const [],
    super.errorMessage,
    super.fieldErrors,
    super.currentPage,
    super.pageSize,
    super.hasMore,
    super.isPageLoading,
    super.isLoading,
    super.searchQuery,
    super.filterSignature,
  });

  static PatientAppointmentsState initial() {
    return PatientAppointmentsState(
      appointments: const <AppointmentEntity>[],
      filteredAppointments: const <AppointmentEntity>[],
      currentPage: 1,
      pageSize: 50,
      hasMore: true,
      isLoading: false,
      isPageLoading: false,
      searchQuery: '',
    );
  }

  @override
  PatientAppointmentsState copyWith({
    PatientAppointmentsStatus? status,
    List<AppointmentEntity>? upcomingAppointments,
    List<AppointmentEntity>? pastAppointments,
    List<AppointmentEntity>? appointments,
    List<AppointmentEntity>? filteredAppointments,
    String? errorMessage,
    bool clearErrorMessage = false,
    Map<String, String>? fieldErrors,
    bool clearFieldErrors = false,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
    bool? isPageLoading,
    bool? isLoading,
    String? searchQuery,
    String? filterSignature,
  }) {
    return PatientAppointmentsState(
      status: status ?? this.status,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      pastAppointments: pastAppointments ?? this.pastAppointments,
      appointments: appointments ?? this.appointments,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      fieldErrors: clearFieldErrors ? null : fieldErrors ?? this.fieldErrors,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      filterSignature: filterSignature ?? this.filterSignature,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        status,
        upcomingAppointments,
        pastAppointments,
      ];
}
