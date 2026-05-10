import '../../domain/entities/appointment_status.dart';
import '../models/appointment_model/appointment_model.dart';
import 'appointment_remote_data_source.dart';

class AppointmentMockDataSourceImpl implements AppointmentRemoteDataSource {
  final List<AppointmentModel> _mockAppointments = [
    // --- TODAY ---
    AppointmentModel(
      id: '1',
      patientId: 'p1',
      patientName: 'Ahmed Ali',
      doctorId: 'd1',
      doctorName: 'Dr. Samir',
      dateTime: DateTime.now().copyWith(hour: 9, minute: 0),
      status: AppointmentStatus.completed,
      reason: 'Regular Checkup',
    ),
    AppointmentModel(
      id: '2',
      patientId: 'p2',
      patientName: 'Sara Hassan',
      doctorId: 'd1',
      doctorName: 'Dr. Samir',
      dateTime: DateTime.now().copyWith(hour: 10, minute: 30),
      status: AppointmentStatus.arrived,
      reason: 'Fever',
    ),
    AppointmentModel(
      id: '3',
      patientId: 'p3',
      patientName: 'John Doe',
      doctorId: 'd2',
      doctorName: 'Dr. Laila',
      dateTime: DateTime.now().copyWith(hour: 11, minute: 0),
      status: AppointmentStatus.inProgress,
      reason: 'Dental pain',
    ),
    AppointmentModel(
      id: '4',
      patientId: 'p1',
      patientName: 'Ahmed Ali',
      doctorId: 'd2',
      doctorName: 'Dr. Laila',
      dateTime: DateTime.now().copyWith(hour: 14, minute: 0),
      status: AppointmentStatus.scheduled,
      reason: 'Follow-up',
    ),

    // --- TOMORROW ---
    AppointmentModel(
      id: '5',
      patientId: 'p4',
      patientName: 'Mona Zaki',
      doctorId: 'd1',
      doctorName: 'Dr. Samir',
      dateTime: DateTime.now()
          .add(const Duration(days: 1))
          .copyWith(hour: 10, minute: 0),
      status: AppointmentStatus.confirmed,
    ),

    // --- YESTERDAY (For History) ---
    AppointmentModel(
      id: '6',
      patientId: 'p1',
      patientName: 'Ahmed Ali',
      doctorId: 'd1',
      doctorName: 'Dr. Samir',
      dateTime: DateTime.now()
          .subtract(const Duration(days: 1))
          .copyWith(hour: 15, minute: 30),
      status: AppointmentStatus.completed,
      reason: 'Initial consultation',
    ),
    AppointmentModel(
      id: '7',
      patientId: 'p2',
      patientName: 'Sara Hassan',
      doctorId: 'd2',
      doctorName: 'Dr. Laila',
      dateTime: DateTime.now()
          .subtract(const Duration(days: 5))
          .copyWith(hour: 10, minute: 0),
      status: AppointmentStatus.completed,
      reason: 'Monthly checkup',
    ),
    AppointmentModel(
      id: '8',
      patientId: 'p3',
      patientName: 'John Doe',
      doctorId: 'd1',
      doctorName: 'Dr. Samir',
      dateTime: DateTime.now().copyWith(hour: 16, minute: 0),
      status: AppointmentStatus.cancelled,
      reason: 'Patient called to cancel',
    ),
  ];

  @override
  Future<List<AppointmentModel>> getAppointments({
    DateTime? date,
    DateTime? endDate,
    String? doctorId,
    String? patientId,
    String? status,
    int page = 1,
    int limit = 50,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _mockAppointments.where((a) {
      bool matches = true;

      if (date != null && endDate != null) {
        final start = DateTime(date.year, date.month, date.day);
        final end = DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          23,
          59,
          59,
        );
        matches &=
            a.dateTime.isAfter(start.subtract(const Duration(seconds: 1))) &&
            a.dateTime.isBefore(end.add(const Duration(seconds: 1)));
      } else if (date != null) {
        matches &=
            a.dateTime.year == date.year &&
            a.dateTime.month == date.month &&
            a.dateTime.day == date.day;
      }

      if (doctorId != null) {
        matches &= a.doctorId == doctorId;
      }

      if (patientId != null) {
        matches &= a.patientId == patientId;
      }

      if (status != null) {
        matches &= a.status.name == status;
      }

      return matches;
    }).toList();
  }

  @override
  Future<AppointmentModel> getAppointmentById(String appointmentId) async {
    return _mockAppointments.firstWhere((a) => a.id == appointmentId);
  }

  @override
  Future<AppointmentModel> createAppointment(AppointmentModel model) async {
    final newApp = model.copyWith(
      id: (DateTime.now().millisecondsSinceEpoch).toString(),
    );
    _mockAppointments.add(newApp);
    return newApp;
  }

  @override
  Future<AppointmentModel> updateAppointmentStatus(
    String appointmentId,
    String status, {
    String? reason,
  }) async {
    final index = _mockAppointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      final updated = _mockAppointments[index].copyWith(
        status: parseAppointmentStatus(
          status,
          fallback: _mockAppointments[index].status,
        ),
        cancellationReason: (reason != null && reason.trim().isNotEmpty)
            ? reason.trim()
            : _mockAppointments[index].cancellationReason,
      );
      _mockAppointments[index] = updated;
      return updated;
    }
    throw Exception('Appointment not found');
  }

  @override
  Future<AppointmentModel> cancelAppointment(
    String appointmentId,
    String cancelledBy,
    String? reason,
  ) async {
    return updateAppointmentStatus(appointmentId, 'cancelled', reason: reason);
  }

  @override
  Future<AppointmentModel> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  ) async {
    final index = _mockAppointments.indexWhere((a) => a.id == appointmentId);
    if (index == -1) throw Exception('Not found');
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
    // Basic slots for mocking
    return [
      '09:00',
      '09:30',
      '10:00',
      '10:30',
      '11:00',
      '11:30',
      '14:00',
      '14:30',
      '15:00',
    ];
  }

  @override
  Future<Map<String, dynamic>> getAppointmentsStats({
    DateTime? date,
    String? doctorId,
  }) async {
    final filtered = _mockAppointments.where((a) {
      if (doctorId != null && a.doctorId != doctorId) return false;
      if (date != null) {
        return a.dateTime.year == date.year &&
            a.dateTime.month == date.month &&
            a.dateTime.day == date.day;
      }
      return true;
    }).toList();

    return {
      'total_appointments': filtered.length,
      'scheduled': filtered
          .where((a) => a.status == AppointmentStatus.scheduled)
          .length,
      'confirmed': filtered
          .where((a) => a.status == AppointmentStatus.confirmed)
          .length,
      'arrived': filtered
          .where((a) => a.status == AppointmentStatus.arrived)
          .length,
      'completed': filtered
          .where((a) => a.status == AppointmentStatus.completed)
          .length,
      'cancelled': filtered
          .where((a) => a.status == AppointmentStatus.cancelled)
          .length,
      'no_show': filtered
          .where((a) => a.status == AppointmentStatus.noShow)
          .length,
      'utilization_rate': 82.5,
      'completion_rate': 94.0,
      'by_doctor': [
        {
          'doctor_id': 'd1',
          'doctor_name': 'Dr. Samir',
          'total_appointments': filtered
              .where((a) => a.doctorId == 'd1')
              .length,
          'completed': filtered
              .where(
                (a) =>
                    a.doctorId == 'd1' &&
                    a.status == AppointmentStatus.completed,
              )
              .length,
          'completion_rate': 88.0,
          'average_wait_time': 15.0,
        },
        {
          'doctor_id': 'd2',
          'doctor_name': 'Dr. Laila',
          'total_appointments': filtered
              .where((a) => a.doctorId == 'd2')
              .length,
          'completed': filtered
              .where(
                (a) =>
                    a.doctorId == 'd2' &&
                    a.status == AppointmentStatus.completed,
              )
              .length,
          'completion_rate': 91.0,
          'average_wait_time': 10.0,
        },
      ],
    };
  }

  @override
  Future<Map<String, dynamic>> getPatientAppointments(String patientId) async {
    final list = _mockAppointments
        .where((a) => a.patientId == patientId)
        .toList();
    return {'data': list.map((e) => e.toJson()).toList()};
  }

  @override
  Future<Map<String, dynamic>> cancelAppointmentByPatient({
    required String appointmentId,
    required String cancellationReason,
  }) async {
    await updateAppointmentStatus(
      appointmentId,
      'cancelled',
      reason: cancellationReason,
    );
    return {'status': 'success'};
  }
}
