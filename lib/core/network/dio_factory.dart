import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:enaya/core/constants/api_constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../di/injection.dart';
import '../services/token_manager.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

String platformLocale = PlatformDispatcher.instance.locale.languageCode;

class DioFactory {
  static Dio getDio() {
    final dio = Dio();
    const timeout = Duration(seconds: 45);
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      receiveTimeout: timeout,
      sendTimeout: timeout,
      connectTimeout: timeout,
      headers: {CONTENT_TYPE: APPLICATION_JSON, ACCEPT: APPLICATION_JSON, DEFAULT_LANGUAGE: "ar"},
    );

    addDioInterceptor(dio);

    return dio;
  }

  static void addDioInterceptor(Dio dio) {
    final tokenManager = getIt<TokenManager>();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers[DEFAULT_LANGUAGE] = platformLocale;

          // إضافة التوكن
          final token = await tokenManager.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers[AUTHORIZATION] = "Bearer $token";
          }

          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          // معالجة 401 (انتهاء التوكن)
          if (error.response?.statusCode == 401) {
            final refreshToken = await tokenManager.getRefreshToken();

            if (refreshToken != null) {
              try {
                // طلب Refresh Token
                final refreshResponse = await dio.post(
                  ApiConstants.refreshToken,
                  data: {"refresh_token": refreshToken},
                );

                final responseData = refreshResponse.data;
                if (responseData is! Map) {
                  throw const FormatException('Invalid refresh response format');
                }

                final newToken = responseData["token"]?.toString();
                final newRefresh = responseData["refresh_token"]?.toString();

                if (newToken == null || newToken.isEmpty) {
                  throw const FormatException('Missing token in refresh response');
                }

                // حفظ التوكن الجديد
                await tokenManager.saveToken(newToken);
                if (newRefresh != null && newRefresh.isNotEmpty) {
                  await tokenManager.saveRefreshToken(newRefresh);
                }

                // إعادة الطلب الأصلي
                final retryRequest = error.requestOptions;
                retryRequest.headers[AUTHORIZATION] = "Bearer $newToken";

                final response = await dio.fetch(retryRequest);
                return handler.resolve(response);
              } catch (e) {
                // فشل الـ Refresh → تسجيل خروج
                await tokenManager.clearAll();
              }
            }
          }

          return handler.next(error);
        },
      ),
    );

    // Logger
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 120,
      ),
    );
  }
}
