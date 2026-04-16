import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../di/injection.dart';
import '../services/token_manager.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class DioFactory {
  static Dio getDio() {
    Dio dio = Dio();

    Duration timeOut = const Duration(minutes: 1);

    dio.options = BaseOptions(
      baseUrl: "https://your-api-url.com/api", // استبدله برابط لارفيل لاحقاً
      receiveTimeout: timeOut,
      sendTimeout: timeOut,
      headers: {
        CONTENT_TYPE: APPLICATION_JSON,
        ACCEPT: APPLICATION_JSON,
      },
    );

    addDioInterceptor(dio);

    return dio;
  }

  static void addDioInterceptor(Dio dio) {
    final tokenManager = getIt<TokenManager>();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 1. إضافة التوكن تلقائياً لكل الطلبات (Authorization: Bearer <token>)
          final token = await tokenManager.getToken();
          if (token != null) {
            options.headers[AUTHORIZATION] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // 2. معالجة انتهاء صلاحية التوكن (401)
          if (error.response?.statusCode == 401) {
            // هنا سيتم إضافة منطق الـ Refresh Token لاحقاً
          }
          return handler.next(error);
        },
      ),
    );

    // Logger لسهولة تتبع الطلبات في مرحلة التطوير
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ));
  }
}
