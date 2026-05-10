import 'dart:convert';

import '../../../../core/cache/cache_helper.dart';
import '../models/appointment_model/appointment_model.dart';

/// Handles local caching of appointment data
///
/// Provides read-through cache with stale-while-revalidate strategy:
/// - Fetches from local cache first (fast response)
/// - Updates from remote in background if stale
/// - Supports offline viewing of cached appointments
class AppointmentCacheHelper {
  static const String _generalAppointmentsKey = 'appointments_cache';
  static const String _patientAppointmentsPrefix = 'patient_appointments_';
  static const String _doctorAppointmentsPrefix = 'doctor_appointments_';
  static const String _cacheTimestampSuffix = '_timestamp';

  /// Cache validity period (6 hours)
  static const Duration _cacheValidityDuration = Duration(hours: 6);

  final CacheHelper cacheHelper;

  AppointmentCacheHelper({required this.cacheHelper});

  // ============================================================================
  // ?? General Appointments Cache
  // ============================================================================

  /// Save a list of appointments to cache
  Future<bool> cacheAppointments(List<AppointmentModel> appointments) async {
    try {
      final jsonList = appointments.map((a) => a.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      final success = await cacheHelper.setData(
        key: _generalAppointmentsKey,
        value: jsonString,
      );

      if (success) {
        // Store timestamp
        await cacheHelper.setData(
          key: _generalAppointmentsKey + _cacheTimestampSuffix,
          value: DateTime.now().toIso8601String(),
        );
      }

      return success;
    } catch (_) {
      return false;
    }
  }

  /// Get cached appointments if still valid
  ///
  /// Returns [null] if cache is not found or expired (unless [allowStale] is true)
  Future<List<AppointmentModel>?> getCachedAppointments({
    bool allowStale = true,
  }) async {
    try {
      final cachedJsonString = cacheHelper.getData(
        key: _generalAppointmentsKey,
      );
      if (cachedJsonString == null || cachedJsonString is! String) {
        return null;
      }

      // Check if cache is stale
      if (!allowStale && !await _isCacheValid(_generalAppointmentsKey)) {
        return null;
      }

      final jsonList = jsonDecode(cachedJsonString) as List;
      return jsonList
          .map(
            (json) => AppointmentModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Clear general appointments cache
  Future<bool> clearAppointmentsCache() async {
    try {
      await cacheHelper.removeData(key: _generalAppointmentsKey);
      await cacheHelper.removeData(
        key: _generalAppointmentsKey + _cacheTimestampSuffix,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // ============================================================================
  // ?? Patient-Specific Appointments Cache
  // ============================================================================

  /// Save patient's appointments to cache
  Future<bool> cachePatientAppointments(
    String patientId,
    List<AppointmentModel> appointments,
  ) async {
    try {
      final key = _patientAppointmentsPrefix + patientId;
      final jsonList = appointments.map((a) => a.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      final success = await cacheHelper.setData(key: key, value: jsonString);

      if (success) {
        await cacheHelper.setData(
          key: key + _cacheTimestampSuffix,
          value: DateTime.now().toIso8601String(),
        );
      }

      return success;
    } catch (_) {
      return false;
    }
  }

  /// Get cached appointments for a specific patient
  Future<List<AppointmentModel>?> getCachedPatientAppointments(
    String patientId, {
    bool allowStale = true,
  }) async {
    try {
      final key = _patientAppointmentsPrefix + patientId;
      final cachedJsonString = cacheHelper.getData(key: key);
      if (cachedJsonString == null || cachedJsonString is! String) {
        return null;
      }

      if (!allowStale && !await _isCacheValid(key)) {
        return null;
      }

      final jsonList = jsonDecode(cachedJsonString) as List;
      return jsonList
          .map(
            (json) => AppointmentModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Clear cache for a specific patient
  Future<bool> clearPatientAppointmentsCache(String patientId) async {
    try {
      final key = _patientAppointmentsPrefix + patientId;
      await cacheHelper.removeData(key: key);
      await cacheHelper.removeData(key: key + _cacheTimestampSuffix);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ============================================================================
  // ?? Doctor-Specific Appointments Cache
  // ============================================================================

  /// Save doctor's appointments to cache
  Future<bool> cacheDoctorAppointments(
    String doctorId,
    List<AppointmentModel> appointments,
  ) async {
    try {
      final key = _doctorAppointmentsPrefix + doctorId;
      final jsonList = appointments.map((a) => a.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      final success = await cacheHelper.setData(key: key, value: jsonString);

      if (success) {
        await cacheHelper.setData(
          key: key + _cacheTimestampSuffix,
          value: DateTime.now().toIso8601String(),
        );
      }

      return success;
    } catch (_) {
      return false;
    }
  }

  /// Get cached appointments for a specific doctor
  Future<List<AppointmentModel>?> getCachedDoctorAppointments(
    String doctorId, {
    bool allowStale = true,
  }) async {
    try {
      final key = _doctorAppointmentsPrefix + doctorId;
      final cachedJsonString = cacheHelper.getData(key: key);
      if (cachedJsonString == null || cachedJsonString is! String) {
        return null;
      }

      if (!allowStale && !await _isCacheValid(key)) {
        return null;
      }

      final jsonList = jsonDecode(cachedJsonString) as List;
      return jsonList
          .map(
            (json) => AppointmentModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Clear cache for a specific doctor
  Future<bool> clearDoctorAppointmentsCache(String doctorId) async {
    try {
      final key = _doctorAppointmentsPrefix + doctorId;
      await cacheHelper.removeData(key: key);
      await cacheHelper.removeData(key: key + _cacheTimestampSuffix);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ============================================================================
  // ?? Cache Invalidation & Validation
  // ============================================================================

  /// Check if cache for a key is still valid (not stale)
  Future<bool> _isCacheValid(String baseKey) async {
    try {
      final timestampStr =
          cacheHelper.getData(key: baseKey + _cacheTimestampSuffix) as String?;
      if (timestampStr == null) {
        return false;
      }

      final cacheTime = DateTime.parse(timestampStr);
      final timeDifference = DateTime.now().difference(cacheTime);
      return timeDifference <= _cacheValidityDuration;
    } catch (_) {
      return false;
    }
  }

  /// Clear all appointment-related caches
  Future<void> clearAllAppointmentCaches() async {
    try {
      await clearAppointmentsCache();
      // In a production app, you'd track all doctor/patient IDs
      // For now, this just clears the general cache
    } catch (_) {
      // Silently fail
    }
  }
}
