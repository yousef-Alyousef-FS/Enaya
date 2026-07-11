import '../models/doctor_model.dart';

// ============================================================================
// ?? Abstract Interface
// ============================================================================
abstract class DoctorDirectoryDataSource {
  /// Fetch the list of available doctors
  ///
  /// Returns a list of [DoctorModel] representing doctors in the system.
  Future<List<DoctorModel>> getDoctors();
}
