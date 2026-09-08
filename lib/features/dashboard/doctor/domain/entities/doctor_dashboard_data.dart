import 'package:equatable/equatable.dart';

class DoctorDashboardData extends Equatable {
  final int todayPatients;
  final int totalConsultations;
  final int pendingReports;

  const DoctorDashboardData({
    required this.todayPatients,
    required this.totalConsultations,
    required this.pendingReports,
  });

  @override
  List<Object?> get props => [
    todayPatients,
    totalConsultations,
    pendingReports,
  ];
}
