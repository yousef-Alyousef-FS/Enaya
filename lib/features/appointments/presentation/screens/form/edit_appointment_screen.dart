import 'package:enaya/features/patients/domain/entities/patient_entity.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/appointment_entity.dart';
import 'schedule_appointment_screen.dart';

/// Thin wrapper that reuses the shared appointment screen in reschedule mode.
class EditAppointmentScreen extends StatelessWidget {
  final AppointmentEntity appointment;

  const EditAppointmentScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return ScheduleAppointmentScreen(
      mode: AppointmentScreenMode.reschedule,
      appointment: appointment,
      patient: _toPatientEntity(appointment),
      doctorId: appointment.doctorId,
      doctorName: appointment.doctorName,
    );
  }

  static PatientEntity _toPatientEntity(AppointmentEntity appointment) {
    return PatientEntity(
      id: appointment.patientId,
      name: appointment.patientName,
      email: '',
      phone: '',
      dateOfBirth: DateTime(1970),
      job: '',
      address: '',
    );
  }
}
