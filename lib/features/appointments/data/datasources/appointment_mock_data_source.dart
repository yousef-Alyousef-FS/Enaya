
import '../../domain/entities/appointment_status.dart';
import '../models/appointment_model.dart';
import 'appointment_remote_data_source.dart';

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
    // Additional mock data for range testing
    AppointmentModel(
      id: '4',
      patientId: 'p4',
      patientName: 'Mona Zaki',
      doctorId: 'd1',
      doctorName: 'Dr. Samir',
      dateTime: DateTime.now().add(const Duration(days: 1)).copyWith(hour: 14, minute: 0),
      status: AppointmentStatus.scheduled,
    ),
    AppointmentModel(
      id: '5',
      patientId: 'p5',
      patientName: 'Omar Khaled',
      doctorId: 'd2',
      doctorName: 'Dr. Laila',
      dateTime: DateTime.now().add(const Duration(days: 2)).copyWith(hour: 16, minute: 30),
      status: AppointmentStatus.confirmed,
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
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _mockAppointments.where((a) {
      bool matches = true;
      
      if (date != null && endDate != null) {
        final start = DateTime(date.year, date.month, date.day);
        final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        matches &= a.dateTime.isAfter(start.subtract(const Duration(seconds: 1))) && 
                  a.dateTime.isBefore(end.add(const Duration(seconds: 1)));
      } else if (date != null) {
        matches &= a.dateTime.year == date.year &&
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
      'total_appointments': _mockAppointments.length,
      'scheduled': _mockAppointments.where((a) => a.status == AppointmentStatus.scheduled).length,
      'confirmed': _mockAppointments.where((a) => a.status == AppointmentStatus.confirmed).length,
      'arrived': _mockAppointments.where((a) => a.status == AppointmentStatus.arrived).length,
      'completed': _mockAppointments.where((a) => a.status == AppointmentStatus.completed).length,
      'cancelled': _mockAppointments.where((a) => a.status == AppointmentStatus.cancelled).length,
      'no_show': 0,
      'utilization_rate': 75.0,
      'completion_rate': 90.0,
      'by_doctor': [
        {
          'doctor_id': 'd1',
          'doctor_name': 'Dr. Samir',
          'total_appointments': _mockAppointments.where((a) => a.doctorId == 'd1').length,
          'completed': 5,
          'completion_rate': 85.0,
          'average_wait_time': 12.5,
        }
      ],
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
