import '../../domain/entities/appointment_status.dart';
import 'package:equatable/equatable.dart';

class AppointmentsFilter extends Equatable {
  final DateTime startDate;
  final DateTime? endDate;
  final String doctorId;
  final String? doctorName;
  final String searchQuery;
  final AppointmentStatus? status;

  const AppointmentsFilter({
    required this.startDate,
    this.endDate,
    this.doctorId = 'all',
    this.doctorName,
    this.searchQuery = '',
    this.status,
  });

  AppointmentsFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? doctorId,
    String? doctorName,
    String? searchQuery,
    AppointmentStatus? status,
    bool clearEndDate = false,
    bool clearDoctor = false,
    bool clearStatus = false,
  }) {
    return AppointmentsFilter(
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      doctorId: clearDoctor ? 'all' : doctorId ?? this.doctorId,
      doctorName: clearDoctor ? null : doctorName ?? this.doctorName,
      searchQuery: searchQuery ?? this.searchQuery,
      status: clearStatus ? null : status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    doctorId,
    doctorName,
    searchQuery,
    status,
  ];
}
