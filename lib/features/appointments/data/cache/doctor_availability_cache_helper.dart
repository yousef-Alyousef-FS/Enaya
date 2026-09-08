import 'dart:convert';

import '../../../../core/cache/cache_helper.dart';
import '../models/doctor_availability_model.dart';

/// Caching layer for doctor availability data with read-through strategy.
/// - Returns cached data immediately if available (even if stale)
/// - Fetches fresh from remote when cache is empty
/// - Updates cache after remote fetch
/// - TTL: 6 hours for automatic invalidation
class DoctorAvailabilityCacheHelper {
  final CacheHelper cacheHelper;

  static const String _cachePrefix = 'doctor_availability_';
  static const String _timestampSuffix = '_timestamp';
  static const Duration _cacheTTL = Duration(hours: 6);

  DoctorAvailabilityCacheHelper({required this.cacheHelper});

  /// Cache doctor availability data for a specific doctor
  Future<bool> cacheDoctorAvailability(DoctorAvailability availability) async {
    try {
      final key = _getCacheKey(availability.doctorId);
      final json = availability.toJson();
      final jsonString = jsonEncode(json);

      await cacheHelper.setData(key: key, value: jsonString);
      await cacheHelper.setData(
        key: '$key$_timestampSuffix',
        value: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  /// Get cached doctor availability (returns stale data if TTL expired)
  Future<DoctorAvailability?> getCachedDoctorAvailability(
    String doctorId, {
    bool allowStale = true,
  }) async {
    try {
      final key = _getCacheKey(doctorId);
      final cachedJsonString = cacheHelper.getData(key: key);

      if (cachedJsonString == null || cachedJsonString is! String) {
        return null;
      }

      if (!allowStale && !await _isCacheValid(key)) {
        return null;
      }

      final json = jsonDecode(cachedJsonString) as Map<String, dynamic>;
      return DoctorAvailability.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Clear cache for a specific doctor
  Future<bool> clearDoctorAvailabilityCache(String doctorId) async {
    try {
      final key = _getCacheKey(doctorId);
      await cacheHelper.removeData(key: key);
      await cacheHelper.removeData(key: '$key$_timestampSuffix');
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Clear all doctor availability cache
  Future<bool> clearAllDoctorAvailabilityCache() async {
    try {
      // Note: This is a simplified approach. For production, maintain a list of cached keys.
      await cacheHelper.removeData(key: _cachePrefix);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Get the cache key for a doctor's availability
  String _getCacheKey(String doctorId) => '$_cachePrefix$doctorId';

  /// Check if cache is still valid based on TTL
  Future<bool> _isCacheValid(String baseKey) async {
    try {
      final timestampStr =
          cacheHelper.getData(key: '$baseKey$_timestampSuffix') as String?;

      if (timestampStr == null) return false;

      final timestamp = int.parse(timestampStr);
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      return now.difference(cacheTime) < _cacheTTL;
    } catch (_) {
      return false;
    }
  }
}
