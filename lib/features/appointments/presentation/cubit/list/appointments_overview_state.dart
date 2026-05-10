import 'package:equatable/equatable.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../models/appointments_filter.dart';
import '../../../domain/entities/appointment_stats.dart';

/// Immutable UI state for appointments overview screens.
class AppointmentsOverviewState extends Equatable {
  final AppointmentsFilter filter;

  /// Raw appointments loaded from repository/use case.
  final List<AppointmentEntity> appointments;

  /// Derived list after local search/doctor filters.
  final List<AppointmentEntity> filteredAppointments;

  final AppointmentStats? stats;

  final int currentPage;
  final int pageSize;
  final bool hasMore;
  final bool isLoading;
  final bool isPageLoading;
  final String? errorMessage;

  const AppointmentsOverviewState({
    required this.filter,
    required this.appointments,
    required this.filteredAppointments,
    this.stats,
    required this.currentPage,
    required this.pageSize,
    required this.hasMore,
    required this.isLoading,
    required this.isPageLoading,
    this.errorMessage,
  });

  factory AppointmentsOverviewState.initial({DateTime? selectedDate}) {
    return AppointmentsOverviewState(
      filter: AppointmentsFilter(startDate: selectedDate ?? DateTime.now()),
      appointments: const [],
      filteredAppointments: const [],
      stats: null,
      currentPage: 1,
      pageSize: 20,
      hasMore: true,
      isLoading: false,
      isPageLoading: false,
      errorMessage: null,
    );
  }

  /// `true` when selectedDate points to current day.
  bool get isTodaySelected {
    final now = DateTime.now();
    return filter.startDate.year == now.year &&
        filter.startDate.month == now.month &&
        filter.startDate.day == now.day;
  }

  /// `true` when repository payload contains appointments.
  bool get hasAppointments => appointments.isNotEmpty;

  /// `true` when an error message is available.
  bool get hasError => errorMessage != null;

  /// Waiting-room appointments.
  List<AppointmentEntity> get waitingAppointments =>
      appointments.where((a) => a.status == AppointmentStatus.arrived).toList();

  /// Scheduled or confirmed appointments that are still in the future.
  List<AppointmentEntity> get upcomingAppointments {
    // If the user selected another day, use that day's start as the reference.
    final reference = isTodaySelected
        ? DateTime.now()
        : DateTime(
            filter.startDate.year,
            filter.startDate.month,
            filter.startDate.day,
          );

    return appointments
        .where(
          (a) =>
              (a.status == AppointmentStatus.scheduled ||
                  a.status == AppointmentStatus.confirmed) &&
              !a.dateTime.isBefore(reference),
        )
        .toList();
  }

  AppointmentEntity? get currentAppointment {
    if (appointments.isEmpty) return null;
    final reference = isTodaySelected
        ? DateTime.now()
        : DateTime(
            filter.startDate.year,
            filter.startDate.month,
            filter.startDate.day,
          );

    return appointments.firstWhere(
      (a) => a.status == AppointmentStatus.inProgress,
      orElse: () => appointments.firstWhere(
        (a) => a.status == AppointmentStatus.arrived,
        orElse: () => appointments.firstWhere(
          (a) =>
              (a.status == AppointmentStatus.scheduled ||
                  a.status == AppointmentStatus.confirmed) &&
              !a.dateTime.isBefore(reference),
          orElse: () => appointments.first,
        ),
      ),
    );
  }

  AppointmentsOverviewState copyWith({
    AppointmentsFilter? filter,
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
  }) {
    return AppointmentsOverviewState(
      filter: filter ?? this.filter,
      appointments: appointments ?? this.appointments,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      stats: stats ?? this.stats,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    filter,
    appointments,
    filteredAppointments,
    stats,
    currentPage,
    pageSize,
    hasMore,
    isLoading,
    isPageLoading,
    errorMessage,
  ];
}
