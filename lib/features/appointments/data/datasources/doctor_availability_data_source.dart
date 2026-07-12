import '../models/doctor_availability_model.dart';

// ============================================================================
// ?? Abstract Interface
// ============================================================================
abstract class DoctorAvailabilityDataSource {
  /// Fetch doctor availability including working hours, breaks, and off days
  Future<DoctorAvailability> getDoctorAvailability(String doctorId);

  /// Save or update doctor availability
  Future<void> saveDoctorAvailability(DoctorAvailability availability);
}
