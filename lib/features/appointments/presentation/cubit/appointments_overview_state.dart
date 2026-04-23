import 'package:equatable/equatable.dart';

import '../../domain/entities/appointment_entity.dart';

class AppointmentsOverviewState extends Equatable {
  final DateTime selectedDate;
  final List<AppointmentEntity> appointments;
  final int currentPage;
  final int pageSize;
  final bool hasMore;
  final bool isLoading;
  final bool isPageLoading;
  final String? errorMessage;

  const AppointmentsOverviewState({
    required this.selectedDate,
    required this.appointments,
    required this.currentPage,
    required this.pageSize,
    required this.hasMore,
    required this.isLoading,
    required this.isPageLoading,
    required this.errorMessage,
  });

  factory AppointmentsOverviewState.initial({DateTime? selectedDate}) {
    return AppointmentsOverviewState(
      selectedDate: selectedDate ?? DateTime.now(),
      appointments: const [],
      currentPage: 1,
      pageSize: 20,
      hasMore: true,
      isLoading: false,
      isPageLoading: false,
      errorMessage: null,
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

  AppointmentsOverviewState copyWith({
    DateTime? selectedDate,
    List<AppointmentEntity>? appointments,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
    bool? isLoading,
    bool? isPageLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AppointmentsOverviewState(
      selectedDate: selectedDate ?? this.selectedDate,
      appointments: appointments ?? this.appointments,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedDate,
    appointments,
    currentPage,
    pageSize,
    hasMore,
    isLoading,
    isPageLoading,
    errorMessage,
  ];
}
