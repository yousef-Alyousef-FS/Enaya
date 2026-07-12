import 'package:equatable/equatable.dart';
import '../../../domain/entities/appointment_entity.dart';

/// Common state fields shared by all appointment screens.
/// [API_READY]: Extended with field-level error mapping for backend validation.
abstract class BaseAppointmentsState extends Equatable {
  final List<AppointmentEntity> appointments;
  final List<AppointmentEntity> filteredAppointments;
  final int currentPage;
  final int pageSize;
  final bool hasMore;
  final bool isLoading;
  final bool isPageLoading;
  final String? errorMessage;
  final Map<String, String>? fieldErrors; 
  final String searchQuery;
  final String? filterSignature; // [DEEP_FIX]: Prevent Race Conditions

  const BaseAppointmentsState({
    required this.appointments,
    required this.filteredAppointments,
    this.currentPage = 1,
    this.pageSize = 50,
    this.hasMore = true,
    this.isLoading = false,
    this.isPageLoading = false,
    this.errorMessage,
    this.fieldErrors,
    this.searchQuery = '',
    this.filterSignature,
  });

  @override
  List<Object?> get props => [
        appointments,
        filteredAppointments,
        currentPage,
        pageSize,
        hasMore,
        isLoading,
        isPageLoading,
        errorMessage,
        fieldErrors,
        searchQuery,
        filterSignature,
      ];

  BaseAppointmentsState copyWith({
    List<AppointmentEntity>? appointments,
    List<AppointmentEntity>? filteredAppointments,
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
    String? filterSignature,
  });
}
