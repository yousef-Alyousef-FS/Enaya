import 'package:enaya/features/patients/data/datasources/patients_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Patients role data routing', () {
    test('doctor-scoped patient list resolves to the doctor endpoint', () {
      expect(
        PatientsRemoteDataSourceImpl.resolvePatientListUrl(doctorId: 'd1'),
        'doctor/d1/patients',
      );
    });

    test('receptionist view stays on the reception endpoint', () {
      expect(PatientsRemoteDataSourceImpl.resolvePatientListUrl(), 'reception/patients');
    });
  });
}
