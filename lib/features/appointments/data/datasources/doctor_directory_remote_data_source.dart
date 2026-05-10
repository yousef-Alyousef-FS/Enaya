import 'package:dio/dio.dart';

import '../models/doctor_model.dart';
import 'doctor_directory_data_source.dart';

// ============================================================================
// ?? Remote Implementation
// ============================================================================
class DoctorDirectoryRemoteDataSource implements DoctorDirectoryDataSource {
  final Dio dio;

  DoctorDirectoryRemoteDataSource(this.dio);

  @override
  Future<List<DoctorModel>> getDoctors() async {
    try {
      final response = await dio.get(
        '/doctors',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch doctors',
        );
      }

      final data = response.data;

      // Handle API response structure
      final doctorsList = _parseResponse(data);

      return doctorsList;
    } on DioException catch (_) {
      // Re-throw DIO exceptions as-is
      rethrow;
    } catch (e) {
      // Wrap unexpected errors
      throw DioException(
        requestOptions: RequestOptions(path: '/doctors'),
        message: 'Unexpected error while fetching doctors: $e',
      );
    }
  }

  /// Parse the API response to extract doctors list
  List<DoctorModel> _parseResponse(dynamic responseData) {
    try {
      // If response is already a list
      if (responseData is List) {
        return responseData.map((item) => _parseDoctorItem(item)).toList();
      }

      // If response is a map with data field
      if (responseData is Map<String, dynamic>) {
        // Try to extract data field (common pattern)
        if (responseData.containsKey('data')) {
          final data = responseData['data'];
          if (data is List) {
            return data.map((item) => _parseDoctorItem(item)).toList();
          }
        }

        // If no data field, try treating response as a single doctor (unlikely but handle it)
        return [_parseDoctorItem(responseData)];
      }

      throw const FormatException('Unexpected response format for doctors API');
    } catch (e) {
      throw FormatException('Failed to parse doctors response: $e');
    }
  }

  /// Parse a single doctor item from API response
  DoctorModel _parseDoctorItem(dynamic item) {
    if (item is! Map<String, dynamic>) {
      throw FormatException(
        'Doctor item must be a map, got ${item.runtimeType}',
      );
    }

    final id = item['id'] ?? item['_id'];
    final name = item['name'] ?? item['fullName'] ?? item['firstName'];

    if (id == null || name == null) {
      throw FormatException(
        'Doctor item missing required fields: id=$id, name=$name',
      );
    }

    return DoctorModel(id: id.toString(), name: name.toString());
  }
}
