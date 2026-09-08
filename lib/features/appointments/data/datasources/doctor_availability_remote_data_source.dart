import 'package:dio/dio.dart';

import '../models/doctor_availability_model.dart';
import 'doctor_availability_data_source.dart';

// ============================================================================
// ?? Remote Implementation
// ============================================================================
class DoctorAvailabilityRemoteDataSource implements DoctorAvailabilityDataSource {
  final Dio dio;

  DoctorAvailabilityRemoteDataSource(this.dio);

  @override
  Future<DoctorAvailability> getDoctorAvailability(String doctorId) async {
    try {
      final response = await dio.get(
        '/doctors/$doctorId/availability',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch doctor availability',
        );
      }

      final data = response.data;

      // Parse availability from response
      final availability = _parseAvailability(data, doctorId);
      return availability;
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/doctors/$doctorId/availability'),
        message: 'Unexpected error while fetching doctor availability: $e',
      );
    }
  }

  @override
  Future<void> saveDoctorAvailability(DoctorAvailability availability) async {
    try {
      final payload = _availabilityToJson(availability);

      final response = await dio.post(
        '/doctors/${availability.doctorId}/availability',
        data: payload,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to save doctor availability',
        );
      }
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/doctors/${availability.doctorId}/availability'),
        message: 'Unexpected error while saving doctor availability: $e',
      );
    }
  }

  /// Parse doctor availability from API response
  DoctorAvailability _parseAvailability(dynamic responseData, String doctorId) {
    try {
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        final data = responseData['data'] as Map<String, dynamic>;
        return DoctorAvailability.fromJson({...data, 'doctor_id': doctorId});
      }

      // Handle direct response
      if (responseData is Map<String, dynamic>) {
        return DoctorAvailability.fromJson({...responseData, 'doctor_id': doctorId});
      }

      throw const FormatException('Invalid response format for doctor availability');
    } catch (e) {
      throw FormatException('Failed to parse doctor availability: $e');
    }
  }

  /// Convert DoctorAvailability to JSON for API request
  Map<String, dynamic> _availabilityToJson(DoctorAvailability availability) {
    return {
      'doctor_id': availability.doctorId,
      'weekly_hours': availability.weeklyHours
          .map(
            (entry) => {
              'day': entry.day.name,
              'enabled': entry.enabled,
              'start_time': _timeOfDayToString(entry.startTime),
              'end_time': _timeOfDayToString(entry.endTime),
            },
          )
          .toList(),
      'working_days': availability.workingDays.map((wd) => wd.toJson()).toList(),
      'exceptions': availability.exceptions.map((e) => e.toJson()).toList(),
      'off_days': availability.offDays.map((d) => d.toIso8601String()).toList(),
      'appointment_duration_minutes': availability.appointmentDurationMinutes,
    };
  }

  /// Convert TimeOfDay to string format (HH:mm)
  String _timeOfDayToString(dynamic time) {
    if (time is String) return time;
    // Assume it's TimeOfDay if not string
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
