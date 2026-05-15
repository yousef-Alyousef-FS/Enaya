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

// ============================================================================
// ?? Mock Implementation (for development/testing)
// ============================================================================
class DoctorDirectoryMockDataSource implements DoctorDirectoryDataSource {
  @override
  Future<List<DoctorModel>> getDoctors() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      const DoctorModel(id: 'd1', name: 'Dr. Samir'),
      const DoctorModel(id: 'd2', name: 'Dr. Laila'),
      const DoctorModel(id: 'd3', name: 'Dr. Omar'),
    ];
  }
}
