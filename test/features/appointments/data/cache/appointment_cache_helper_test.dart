import 'package:enaya/core/cache/cache_helper.dart';
import 'package:enaya/features/appointments/data/cache/appointment_cache_helper.dart';
import 'package:enaya/features/appointments/data/models/appointment_model/appointment_model.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheHelper extends Mock implements CacheHelper {}

void main() {
  group('AppointmentCacheHelper', () {
    late AppointmentCacheHelper appointmentCacheHelper;
    late MockCacheHelper mockCacheHelper;

    setUp(() {
      mockCacheHelper = MockCacheHelper();
      appointmentCacheHelper = AppointmentCacheHelper(
        cacheHelper: mockCacheHelper,
      );

      // Register fallback values for mocktail
      registerFallbackValue('');
    });

    group('General Appointments Cache', () {
      test('should cache appointments successfully', () async {
        // Arrange
        final appointments = [
          AppointmentModel(
            id: 'apt-1',
            patientId: 'p1',
            patientName: 'Patient Test',
            doctorId: 'd1',
            doctorName: 'Dr. Test',
            scheduledAt: DateTime(2026, 5, 15, 10, 0),
            status: AppointmentStatus.scheduled,
          ),
        ];

        when(
          () => mockCacheHelper.setData(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => true);

        // Act
        final result = await appointmentCacheHelper.cacheAppointments(
          appointments,
        );

        // Assert
        expect(result, isTrue);
      });

      test('should handle cache retrieval errors gracefully', () async {
        // Arrange
        when(
          () => mockCacheHelper.getData(key: any(named: 'key')),
        ).thenReturn(null);

        // Act
        final result = await appointmentCacheHelper.getCachedAppointments(
          allowStale: true,
        );

        // Assert
        expect(result, isNull);
      });

      test('should clear appointments cache successfully', () async {
        // Arrange
        when(
          () => mockCacheHelper.removeData(key: any(named: 'key')),
        ).thenAnswer((_) async => true);

        // Act
        final result = await appointmentCacheHelper.clearAppointmentsCache();

        // Assert
        expect(result, isTrue);
      });
    });

    group('Patient-Specific Cache', () {
      test('should cache patient appointments successfully', () async {
        // Arrange
        const patientId = 'patient-123';
        final appointments = [
          AppointmentModel(
            id: 'apt-1',
            patientId: patientId,
            patientName: 'Patient Test',
            doctorId: 'd1',
            doctorName: 'Dr. Test',
            scheduledAt: DateTime(2026, 5, 15, 10, 0),
            status: AppointmentStatus.scheduled,
          ),
        ];

        when(
          () => mockCacheHelper.setData(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => true);

        // Act
        final result = await appointmentCacheHelper.cachePatientAppointments(
          patientId,
          appointments,
        );

        // Assert
        expect(result, isTrue);
      });

      test('should clear patient appointments cache', () async {
        // Arrange
        const patientId = 'patient-123';
        when(
          () => mockCacheHelper.removeData(key: any(named: 'key')),
        ).thenAnswer((_) async => true);

        // Act
        final result = await appointmentCacheHelper
            .clearPatientAppointmentsCache(patientId);

        // Assert
        expect(result, isTrue);
      });
    });

    group('Doctor-Specific Cache', () {
      test('should cache doctor appointments successfully', () async {
        // Arrange
        const doctorId = 'doctor-123';
        final appointments = [
          AppointmentModel(
            id: 'apt-1',
            patientId: 'p1',
            patientName: 'Patient Test',
            doctorId: doctorId,
            doctorName: 'Dr. Test',
            scheduledAt: DateTime(2026, 5, 15, 10, 0),
            status: AppointmentStatus.scheduled,
          ),
        ];

        when(
          () => mockCacheHelper.setData(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => true);

        // Act
        final result = await appointmentCacheHelper.cacheDoctorAppointments(
          doctorId,
          appointments,
        );

        // Assert
        expect(result, isTrue);
      });

      test('should clear doctor appointments cache', () async {
        // Arrange
        const doctorId = 'doctor-123';
        when(
          () => mockCacheHelper.removeData(key: any(named: 'key')),
        ).thenAnswer((_) async => true);

        // Act
        final result = await appointmentCacheHelper
            .clearDoctorAppointmentsCache(doctorId);

        // Assert
        expect(result, isTrue);
      });
    });

    group('Cache Error Handling', () {
      test('should return false when caching fails', () async {
        // Arrange
        final appointments = [
          AppointmentModel(
            id: 'apt-1',
            patientId: 'p1',
            patientName: 'Patient Test',
            doctorId: 'd1',
            doctorName: 'Dr. Test',
            scheduledAt: DateTime(2026, 5, 15, 10, 0),
            status: AppointmentStatus.scheduled,
          ),
        ];

        when(
          () => mockCacheHelper.setData(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenThrow(Exception('Cache error'));

        // Act
        final result = await appointmentCacheHelper.cacheAppointments(
          appointments,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should return null when retrieving invalid cache', () async {
        // Arrange
        when(
          () => mockCacheHelper.getData(key: any(named: 'key')),
        ).thenThrow(Exception('Invalid cache data'));

        // Act
        final result = await appointmentCacheHelper.getCachedAppointments(
          allowStale: true,
        );

        // Assert
        expect(result, isNull);
      });
    });
  });
}
