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
          return ServerFailure(_handleError(error.response?.statusCode, error.response?.data));
        case DioExceptionType.cancel:
          return ServerFailure("error_request_cancelled".tr());
        case DioExceptionType.connectionError:
          return NetworkFailure();
        case DioExceptionType.badCertificate:
          return ServerFailure("error_bad_certificate".tr());
        default:
          return ServerFailure("error_something_went_wrong".tr());
      }
    } else {
      return ServerFailure("error_unexpected".tr());
    }
  }

  static String _handleError(int? statusCode, dynamic responseData) {
    // 1. محاولة استخراج رسالة الخطأ من الباك أند (Laravel)
    if (responseData != null && responseData is Map) {
      if (responseData.containsKey('error') && responseData['error'] != null) {
        return responseData['error'].toString();
      }
      if (responseData.containsKey('message') && responseData['message'] != null) {
        return responseData['message'].toString();
      }
      // في حال وجود أخطاء Validation من لارفيل (Array of errors)
      if (responseData.containsKey('errors') && responseData['errors'] is Map) {
        final errors = responseData['errors'] as Map;
        return errors.values.first[0].toString(); // إرجاع أول خطأ وجدناه
      }
    }

    // 2. إذا لم نجد رسالة من الباك أند، نستخدم الرسائل الافتراضية المترجمة
    switch (statusCode) {
      case 400: return "error_bad_request".tr();
      case 401: return "error_unauthorized".tr();
      case 403: return "error_forbidden".tr();
      case 404: return "error_not_found".tr();
      case 409: return "error_conflict".tr();
      case 500: return "error_internal_server".tr();
      case 503: return "error_service_unavailable".tr();
      default: return "error_something_went_wrong".tr();
    }
  }
}
