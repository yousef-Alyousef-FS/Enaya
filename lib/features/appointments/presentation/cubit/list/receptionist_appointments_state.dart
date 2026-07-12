import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_stats.dart';
import '../../models/appointments_filter.dart';
import 'base_appointments_state.dart';

/// Immutable UI state for receptionist appointments overview.
class ReceptionistAppointmentsState extends BaseAppointmentsState {
  final AppointmentsFilter filter;
  final AppointmentStats? stats;

  const ReceptionistAppointmentsState({
    required super.appointments,
    required super.filteredAppointments,
    required super.currentPage,
    required super.pageSize,
    required super.hasMore,
    required super.isLoading,
    required super.isPageLoading,
    super.errorMessage,
    super.fieldErrors,
    super.searchQuery,
    super.filterSignature,
    required this.filter,
    this.stats,
  });

  static ReceptionistAppointmentsState initial({DateTime? selectedDate}) {
    return ReceptionistAppointmentsState(
      filter: AppointmentsFilter(startDate: selectedDate ?? DateTime.now()),
      appointments: const [],
      filteredAppointments: const [],
      stats: null,
      currentPage: 1,
      pageSize: 50,
      hasMore: true,
      isLoading: false,
      isPageLoading: false,
      errorMessage: null,
      searchQuery: '',
    );
  }

  bool get isTodaySelected {
    final now = DateTime.now();
    return filter.startDate.year == now.year &&
        filter.startDate.month == now.month &&
        filter.startDate.day == now.day;
  }

  @override
  ReceptionistAppointmentsState copyWith({
    List<AppointmentEntity>? appointments,
    List<AppointmentEntity>? filteredAppointments,
    AppointmentStats? stats,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
    bool? isLoading,
    bool? isPageLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    Map<String, String>? fieldErrors,
    bool clearFieldErrors = false,
    String? searchQuery,
    AppointmentsFilter? filter,
    String? filterSignature,
  }) {
    return ReceptionistAppointmentsState(
      appointments: appointments ?? this.appointments,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      stats: stats ?? this.stats,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      fieldErrors: clearFieldErrors ? null : fieldErrors ?? this.fieldErrors,
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
      filterSignature: filterSignature ?? this.filterSignature,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        filter,
        stats,
      ];
}
