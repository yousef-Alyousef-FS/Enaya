import 'package:dio/dio.dart';
import '../error/failures.dart';

class ApiErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ServerFailure("Connection timeout with API server");
        case DioExceptionType.sendTimeout:
          return ServerFailure("Send timeout in association with API server");
        case DioExceptionType.receiveTimeout:
          return ServerFailure("Receive timeout in connection with API server");
        case DioExceptionType.badResponse:
          return ServerFailure(_handleError(error.response?.statusCode, error.response?.data));
        case DioExceptionType.cancel:
          return ServerFailure("Request to API server was cancelled");
        case DioExceptionType.connectionError:
          return NetworkFailure();
        default:
          return ServerFailure("Something went wrong");
      }
    } else {
      return ServerFailure("Unexpected error occurred");
    }
  }

  static String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400: return "Bad request";
      case 401: return "Unauthorized";
      case 403: return "Forbidden";
      case 404: return "Not found";
      case 500: return "Internal server error";
      default: return "Something went wrong";
    }
  }
}
