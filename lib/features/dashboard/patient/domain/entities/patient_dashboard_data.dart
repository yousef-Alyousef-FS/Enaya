import 'package:equatable/equatable.dart';

class PatientDashboardData extends Equatable {
  final int totalAppointments;
  final int completedVisits;

  const PatientDashboardData({
    required this.totalAppointments,
    required this.completedVisits,
  });

  @override
  List<Object?> get props => [totalAppointments, completedVisits];
}
