import '../entities/appointment_entity.dart';
import '../entities/appointment_status.dart';

abstract class AppointmentRepository {
  Future<AppointmentEntity> getAppointmentById(String appointmentId);

  Future<List<AppointmentEntity>> getAppointmentsByDate(
    DateTime date, {
    AppointmentStatus? status,
    int page = 1,
    int limit = 20,
  });

  Future<List<AppointmentEntity>> getAppointmentsToday({
    int page = 1,
    int limit = 20,
  });
  Future<List<AppointmentEntity>> getAppointmentsByPatient(
    String patientId, {
    int page = 1,
    int limit = 20,
  });
  Future<List<AppointmentEntity>> getAppointmentsByDoctor(
    String doctorId, {
    int page = 1,
    int limit = 20,
  });

  Future<AppointmentEntity> createAppointment(AppointmentEntity appointment);

  Future<AppointmentEntity> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  );

  Future<AppointmentEntity> cancelAppointment(
    String appointmentId,
    String cancelledBy,
    String? reason,
  );

  Future<AppointmentEntity> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  );

  Future<void> deleteAppointment(String appointmentId); // optional
}
