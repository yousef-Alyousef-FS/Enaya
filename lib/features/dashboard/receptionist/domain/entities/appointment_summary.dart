import 'package:equatable/equatable.dart';

class AppointmentSummary extends Equatable {
  final String patientName;
  final String time;
  final String doctorName;
  final String visitType;
  final String status;

  const AppointmentSummary({
    required this.patientName,
    required this.time,
    required this.doctorName,
    required this.visitType,
    required this.status,
  });

  @override
  List<Object?> get props => [
    patientName,
    time,
    doctorName,
    visitType,
    status,
  ];
}
