import 'package:enaya/features/appointments/appointments_imports.dart';

class AppointmentMockDataSourceImpl implements AppointmentRemoteDataSource {
  final List<AppointmentModel> _mockAppointments = [
    AppointmentModel(
      id: '1',
      patientId: 'p1',
      patientName: 'Ahmed Ali',
      doctorId: 'd1',
      doctorName: 'Dr. Samir',
      dateTime: DateTime.now().copyWith(hour: 9, minute: 0),
      status: AppointmentStatus.scheduled,
    ),
    AppointmentModel(
      id: '2',
      patientId: 'p2',
      patientName: 'Sara Hassan',
      doctorId: 'd1',
      doctorName: 'Dr. Samir',
      dateTime: DateTime.now().copyWith(hour: 10, minute: 30),
      status: AppointmentStatus.arrived,
    ),
    AppointmentModel(
      id: '3',
      patientId: 'p3',
      patientName: 'John Doe',
      doctorId: 'd2',
      doctorName: 'Dr. Laila',
      dateTime: DateTime.now().copyWith(hour: 11, minute: 0),
      status: AppointmentStatus.scheduled,
    ),
  ];

  @override
  Future<List<AppointmentModel>> getAppointmentsByDate(
    DateTime date, {
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockAppointments
        .where(
          (a) =>
              a.dateTime.year == date.year &&
              a.dateTime.month == date.month &&
              a.dateTime.day == date.day,
        )
        .toList();
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsToday({int page = 1, int limit = 20}) async {
    return getAppointmentsByDate(DateTime.now());
  }

  @override
  Future<AppointmentModel> getAppointmentById(String appointmentId) async {
    return _mockAppointments.firstWhere((a) => a.id == appointmentId);
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByPatient(
    String patientId, {
    int page = 1,
    int limit = 20,
  }) async {
    return _mockAppointments.where((a) => a.patientId == patientId).toList();
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByDoctor(
    String doctorId, {
    int page = 1,
    int limit = 20,
  }) async {
    return _mockAppointments.where((a) => a.doctorId == doctorId).toList();
  }

  @override
  Future<AppointmentModel> createAppointment(AppointmentModel model) async {
    _mockAppointments.add(model);
    return model;
  }

  @override
  Future<AppointmentModel> updateAppointmentStatus(String appointmentId, String status) async {
    final index = _mockAppointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      final updated = _mockAppointments[index].copyWith(
        status: parseAppointmentStatus(status, fallback: _mockAppointments[index].status),
      );
      _mockAppointments[index] = updated;
      return updated;
    }
    throw Exception('Not found');
  }

  @override
  Future<AppointmentModel> cancelAppointment(
    String appointmentId,
    String cancelledBy,
    String? reason,
  ) async {
    return updateAppointmentStatus(appointmentId, 'cancelled');
  }

  @override
  Future<AppointmentModel> rescheduleAppointment(String appointmentId, DateTime newDateTime) async {
    final index = _mockAppointments.indexWhere((a) => a.id == appointmentId);
    final updated = _mockAppointments[index].copyWith(dateTime: newDateTime);
    _mockAppointments[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    _mockAppointments.removeWhere((a) => a.id == appointmentId);
  }

  @override
  Future<List<String>> getAvailableSlots(String doctorId, DateTime date) async {
    return ['09:00', '09:30', '10:00', '10:30', '11:00'];
  }

  @override
  Future<Map<String, dynamic>> getAppointmentsStats({DateTime? date, String? doctorId}) async {
    return {
      'today_total': _mockAppointments.length,
      'arrived_count': _mockAppointments.where((a) => a.status == AppointmentStatus.arrived).length,
      'pending_count': _mockAppointments
          .where((a) => a.status == AppointmentStatus.scheduled)
          .length,
      'completed_count': _mockAppointments
          .where((a) => a.status == AppointmentStatus.completed)
          .length,
    };
  }

  @override
  Future<Map<String, dynamic>> getPatientAppointments(String patientId) async {
    return {
      'data': _mockAppointments
          .where((a) => a.patientId == patientId)
          .map((e) => e.toJson())
          .toList(),
    };
  }

  @override
  Future<Map<String, dynamic>> cancelAppointmentByPatient({
    required String appointmentId,
    required String cancellationReason,
  }) async {
    await updateAppointmentStatus(appointmentId, 'cancelled');
    return {'message': 'success'};
  }
}
