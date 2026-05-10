import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:enaya/features/appointments/data/cache/doctor_availability_cache_helper.dart';
import 'package:enaya/features/appointments/data/models/doctor_availability_model.dart';
import 'package:enaya/core/cache/cache_helper.dart';
import 'package:flutter/material.dart';

// ============================================================================
// ?? Mock Implementation
// ============================================================================
class MockCacheHelper extends Mock implements CacheHelper {}

// ============================================================================
// ?? Tests
// ============================================================================
void main() {
  late DoctorAvailabilityCacheHelper cacheHelper;
  late MockCacheHelper mockCacheHelper;

  setUp(() {
    mockCacheHelper = MockCacheHelper();
    cacheHelper = DoctorAvailabilityCacheHelper(cacheHelper: mockCacheHelper);
  });

  group('DoctorAvailabilityCacheHelper', () {
    // ========================================================================
    // ?? Cache Doctor Availability Tests
    // ========================================================================
    group('cacheDoctorAvailability', () {
      test('should save availability data and timestamp when cache succeeds', () async {
        // Arrange
        const doctorId = 'doc123';
        final availability = DoctorAvailability(
          doctorId: doctorId,
          workingDays: [
            WorkingDay(
              dayOfWeek: DateTime.monday,
              startTime: const TimeOfDay(hour: 9, minute: 0),
              endTime: const TimeOfDay(hour: 17, minute: 0),
            ),
          ],
          appointmentDurationMinutes: 30,
        );

        when(
          () => mockCacheHelper.setData(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => true);

        // Act
        final result = await cacheHelper.cacheDoctorAvailability(availability);

        // Assert
        expect(result, true);
        verify(
          () => mockCacheHelper.setData(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).called(greaterThanOrEqualTo(2));
      });

      test('should return false when cache save fails', () async {
        // Arrange
        const doctorId = 'doc123';
        final availability = DoctorAvailability(
          doctorId: doctorId,
          workingDays: [
            WorkingDay(
              dayOfWeek: DateTime.monday,
              startTime: const TimeOfDay(hour: 9, minute: 0),
              endTime: const TimeOfDay(hour: 17, minute: 0),
            ),
          ],
          appointmentDurationMinutes: 30,
        );

        when(
          () => mockCacheHelper.setData(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenThrow(Exception('Cache error'));

        // Act
        final result = await cacheHelper.cacheDoctorAvailability(availability);

        // Assert
        expect(result, false);
      });
    });

    // ========================================================================
    // ?? Get Cached Doctor Availability Tests
    // ========================================================================
    group('getCachedDoctorAvailability', () {
      test('should return cached availability when data exists', () async {
        // Arrange
        const doctorId = 'doc123';

        final jsonString =
            '{"doctor_id":"doc123","working_days":[{"day_of_week":1,"start_time":"09:00","end_time":"17:00"}],"appointment_duration_minutes":30,"off_days":[]}';

        when(() => mockCacheHelper.getData(key: any(named: 'key'))).thenReturn(jsonString);

        when(
          () => mockCacheHelper.getData(key: 'doctor_availability_doc123_timestamp'),
        ).thenReturn(DateTime.now().millisecondsSinceEpoch.toString());

        // Act
        final result = await cacheHelper.getCachedDoctorAvailability(doctorId);

        // Assert
        expect(result, isNotNull);
        expect(result?.doctorId, doctorId);
      });

      test('should return null when no cached data exists', () async {
        // Arrange
        const doctorId = 'doc123';

        when(() => mockCacheHelper.getData(key: any(named: 'key'))).thenReturn(null);

        // Act
        final result = await cacheHelper.getCachedDoctorAvailability(doctorId);

        // Assert
        expect(result, isNull);
      });

      test('should return null when cache retrieval fails', () async {
        // Arrange
        const doctorId = 'doc123';

        when(
          () => mockCacheHelper.getData(key: any(named: 'key')),
        ).thenThrow(Exception('Cache error'));

        // Act
        final result = await cacheHelper.getCachedDoctorAvailability(doctorId);

        // Assert
        expect(result, isNull);
      });
    });

    // ========================================================================
    // ?? Clear Cache Tests
    // ========================================================================
    group('clearDoctorAvailabilityCache', () {
      test('should clear cache for specific doctor', () async {
        // Arrange
        const doctorId = 'doc123';

        when(
          () => mockCacheHelper.removeData(key: any(named: 'key')),
        ).thenAnswer((_) async => true);

        // Act
        final result = await cacheHelper.clearDoctorAvailabilityCache(doctorId);

        // Assert
        expect(result, true);
        verify(
          () => mockCacheHelper.removeData(key: any(named: 'key')),
        ).called(2); // Called twice (data + timestamp)
      });

      test('should return false when cache clear fails', () async {
        // Arrange
        const doctorId = 'doc123';

        when(
          () => mockCacheHelper.removeData(key: any(named: 'key')),
        ).thenThrow(Exception('Cache error'));

        // Act
        final result = await cacheHelper.clearDoctorAvailabilityCache(doctorId);

        // Assert
        expect(result, false);
      });
    });

    // ========================================================================
    // ?? Clear All Cache Tests
    // ========================================================================
    group('clearAllDoctorAvailabilityCache', () {
      test('should clear all doctor availability cache', () async {
        // Arrange
        when(
          () => mockCacheHelper.removeData(key: any(named: 'key')),
        ).thenAnswer((_) async => true);

        // Act
        final result = await cacheHelper.clearAllDoctorAvailabilityCache();

        // Assert
        expect(result, true);
        verify(() => mockCacheHelper.removeData(key: any(named: 'key'))).called(1);
      });
    });
  });
}
