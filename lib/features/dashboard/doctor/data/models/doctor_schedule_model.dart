import 'package:enaya/features/appointments/domain/entities/appointment_entity.dart';
import 'package:enaya/features/appointments/data/models/appointment_model/appointment_model.dart';

class DoctorScheduleModel {
  final AppointmentEntity? currentAppointment;
  final List<AppointmentEntity> upcomingAppointments;

  DoctorScheduleModel({
    required this.currentAppointment,
    required this.upcomingAppointments,
  });

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleModel(
      currentAppointment: json['current'] != null
          ? AppointmentModel.fromJson(json['current']).toEntity()
          : null,
      upcomingAppointments: (json['upcoming'] as List<dynamic>)
          .map((e) => AppointmentModel.fromJson(e).toEntity())
          .toList(),
    );
  }
}
