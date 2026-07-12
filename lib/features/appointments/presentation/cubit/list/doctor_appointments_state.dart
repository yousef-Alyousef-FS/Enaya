import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import 'base_appointments_state.dart';

enum DoctorAppointmentsStatus { initial, loading, success, failure }

class DoctorAppointmentsState extends BaseAppointmentsState {
  final DoctorAppointmentsStatus status;
  final DateTime selectedDate;
  final DateTime selectedEndDate;
  final AppointmentStatus? statusFilter;

  const DoctorAppointmentsState({
    this.status = DoctorAppointmentsStatus.initial,
    required super.appointments,
    required super.filteredAppointments,
    super.errorMessage,
    super.fieldErrors,
    super.searchQuery,
    required this.selectedDate,
    required this.selectedEndDate,
    this.statusFilter,
    super.currentPage,
    super.pageSize,
    super.hasMore,
    super.isPageLoading,
    super.isLoading,
    super.filterSignature,
  });

  static DoctorAppointmentsState initial() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    return DoctorAppointmentsState(
      selectedDate: startOfDay,
      selectedEndDate: endOfDay,
      appointments: const [],
      filteredAppointments: const [],
      currentPage: 1,
      pageSize: 50,
      hasMore: true,
      isPageLoading: false,
      isLoading: false,
    );
  }

  @override
  DoctorAppointmentsState copyWith({
    DoctorAppointmentsStatus? status,
    List<AppointmentEntity>? appointments,
    List<AppointmentEntity>? filteredAppointments,
    String? errorMessage,
    bool clearErrorMessage = false,
    Map<String, String>? fieldErrors,
    bool clearFieldErrors = false,
    String? searchQuery,
    DateTime? selectedDate,
    DateTime? selectedEndDate,
    AppointmentStatus? statusFilter,
    bool clearStatusFilter = false,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
    bool? isPageLoading,
    bool? isLoading,
    String? filterSignature,
  }) {
    return DoctorAppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      fieldErrors: clearFieldErrors ? null : fieldErrors ?? this.fieldErrors,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedEndDate: selectedEndDate ?? this.selectedEndDate,
      statusFilter: clearStatusFilter ? null : statusFilter ?? this.statusFilter,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      isLoading: isLoading ?? this.isLoading,
      filterSignature: filterSignature ?? this.filterSignature,
    );
  }

  @override
  List<Object?> get props => [...super.props, status, selectedDate, selectedEndDate, statusFilter];
}
