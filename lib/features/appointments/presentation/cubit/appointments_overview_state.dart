import 'package:equatable/equatable.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_status.dart';

class AppointmentsOverviewState extends Equatable {
  final DateTime selectedDate;
  final DateTime? endDate; // نهاية النطاق الزمني
  final List<AppointmentEntity> appointments;
  final List<AppointmentEntity> filteredAppointments; // قائمة بعد التصفية والبحث
  final int currentPage;
  final int pageSize;
  final bool hasMore;
  final bool isLoading;
  final bool isPageLoading;
  final String? errorMessage;
  final String selectedDoctorId;
  final String? selectedDoctorName;
  final String searchQuery; // نص البحث

  const AppointmentsOverviewState({
    required this.selectedDate,
    this.endDate,
    required this.appointments,
    required this.filteredAppointments,
    required this.currentPage,
    required this.pageSize,
    required this.hasMore,
    required this.isLoading,
    required this.isPageLoading,
    required this.errorMessage,
    required this.selectedDoctorId,
    required this.selectedDoctorName,
    required this.searchQuery,
  });

  factory AppointmentsOverviewState.initial({DateTime? selectedDate}) {
    return AppointmentsOverviewState(
      selectedDate: selectedDate ?? DateTime.now(),
      endDate: null,
      appointments: const [],
      filteredAppointments: const [],
      currentPage: 1,
      pageSize: 20,
      hasMore: true,
      isLoading: false,
      isPageLoading: false,
      errorMessage: null,
      selectedDoctorId: 'all',
      selectedDoctorName: null,
      searchQuery: '',
    );
  }

  bool get isTodaySelected {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  bool get hasAppointments => appointments.isNotEmpty;
  bool get hasError => errorMessage != null;

  List<AppointmentEntity> get waitingAppointments =>
      appointments.where((a) => a.status == AppointmentStatus.arrived).toList();

  List<AppointmentEntity> get upcomingAppointments => appointments
      .where(
        (a) => a.status == AppointmentStatus.scheduled || a.status == AppointmentStatus.confirmed,
      )
      .toList();

  AppointmentEntity? get currentAppointment {
    if (appointments.isEmpty) return null;
    
    return appointments.firstWhere(
      (a) => a.status == AppointmentStatus.inProgress,
      orElse: () => appointments.firstWhere(
        (a) => a.status == AppointmentStatus.arrived,
        orElse: () => appointments.first,
      ),
    );
  }

  AppointmentsOverviewState copyWith({
    DateTime? selectedDate,
    DateTime? endDate,
    List<AppointmentEntity>? appointments,
    List<AppointmentEntity>? filteredAppointments,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
    bool? isLoading,
    bool? isPageLoading,
    String? errorMessage,
    String? selectedDoctorId,
    String? selectedDoctorName,
    String? searchQuery,
    bool clearErrorMessage = false,
    bool clearSelectedDoctorName = false,
    bool clearEndDate = false,
  }) {
    return AppointmentsOverviewState(
      selectedDate: selectedDate ?? this.selectedDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      appointments: appointments ?? this.appointments,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      selectedDoctorId: selectedDoctorId ?? this.selectedDoctorId,
      selectedDoctorName: clearSelectedDoctorName
          ? null
          : selectedDoctorName ?? this.selectedDoctorName,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    selectedDate,
    endDate,
    appointments,
    filteredAppointments,
    currentPage,
    pageSize,
    hasMore,
    isLoading,
    isPageLoading,
    errorMessage,
    selectedDoctorId,
    selectedDoctorName,
    searchQuery,
  ];
}
