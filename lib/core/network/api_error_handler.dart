import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../error/failures.dart';

class ApiErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ServerFailure("error_connection_timeout".tr());

        case DioExceptionType.sendTimeout:
          return ServerFailure("error_send_timeout".tr());

        case DioExceptionType.receiveTimeout:
          return ServerFailure("error_receive_timeout".tr());

        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);

        case DioExceptionType.cancel:
          return ServerFailure("error_request_cancelled".tr());

        case DioExceptionType.connectionError:
          return NetworkFailure();

        case DioExceptionType.badCertificate:
          return ServerFailure("error_bad_certificate".tr());

        default:
          return ServerFailure("error_something_went_wrong".tr());
      }
    }

    return ServerFailure("error_unexpected".tr());
  }

  static Failure _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    // 1. إذا في رسالة من الباك
    if (data is Map) {
      if (data['error'] != null) {
        return ServerFailure(data['error'].toString(), code: statusCode);
      }

      if (data['message'] != null) {
        return ServerFailure(data['message'].toString(), code: statusCode);
      }

      if (data['errors'] is Map) {
        final errors = data['errors'] as Map;
        final firstError = errors.values.first[0].toString();
        return ServerFailure(firstError, code: statusCode);
      }
    }

    // 2. fallback حسب status code
    return ServerFailure(_mapStatusCodeToMessage(statusCode), code: statusCode);
  }

  static String _mapStatusCodeToMessage(int? statusCode) {
    switch (statusCode) {
      case 400: return "error_bad_request".tr();
      case 401: return "error_unauthorized".tr();
      case 403: return "error_forbidden".tr();
      case 404: return "error_not_found".tr();
      case 409: return "error_conflict".tr();
      case 422: return "error_validation".tr();
      case 500: return "error_internal_server".tr();
      case 503: return "error_service_unavailable".tr();
      default: return "error_something_went_wrong".tr();
    }
  }
}
