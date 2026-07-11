import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:enaya/core/constants/api_constants.dart';
import 'package:enaya/core/services/settings_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../di/injection.dart';
import '../services/token_manager.dart';

const String applicationJson = "application/json";
const String contentType = "content-type";
const String accept = "accept";
const String authorization = "authorization";
const String defaultLanguage = "language";

/// Creates and configures Dio clients used by repositories and remote data sources.
class DioFactory {
  /// Returns a fully configured Dio instance with base options and interceptors.
  static Dio getDio() {
    final dio = Dio();
    const timeout = Duration(seconds: 45);
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      receiveTimeout: timeout,
      sendTimeout: timeout,
      connectTimeout: timeout,
      headers: {
        contentType: applicationJson,
        accept: applicationJson,
      },
    );

    addDioInterceptor(dio);

    return dio;
  }

  /// Adds authentication, localization, refresh-token recovery, and logging interceptors.
  static void addDioInterceptor(Dio dio) {
    final tokenManager = getIt<TokenManager>();
    final settingsService = getIt<SettingsService>();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // [API_REFINE]: Dynamically resolve language from settings or system on every request.
          final languageCode = settingsService.getLanguage() ?? 
                              PlatformDispatcher.instance.locale.languageCode;
          options.headers[defaultLanguage] = languageCode;

          // Attach the latest access token when available.
          final token = await tokenManager.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers[authorization] = "Bearer $token";
          }

          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          // Attempt transparent token refresh when the access token is expired.
          if (error.response?.statusCode == 401) {
            final refreshToken = await tokenManager.getRefreshToken();

            if (refreshToken != null) {
              try {
                // Request a new access token using refresh token.
                final refreshResponse = await dio.post(
                  ApiConstants.refreshToken,
                  data: {"refresh_token": refreshToken},
                );

                final responseData = refreshResponse.data;
                if (responseData is! Map) {
                  throw const FormatException(
                    'Invalid refresh response format',
                  );
                }

                final newToken = responseData["token"]?.toString();
                final newRefresh = responseData["refresh_token"]?.toString();

                if (newToken == null || newToken.isEmpty) {
                  throw const FormatException(
                    'Missing token in refresh response',
                  );
                }

                // Persist the new token pair before retrying the original request.
                await tokenManager.saveToken(newToken);
                if (newRefresh != null && newRefresh.isNotEmpty) {
                  await tokenManager.saveRefreshToken(newRefresh);
                }

                // Replay the original request with refreshed credentials.
                final retryRequest = error.requestOptions;
                retryRequest.headers[authorization] = "Bearer $newToken";

                final response = await dio.fetch(retryRequest);
                return handler.resolve(response);
              } catch (e) {
                // Refresh failed: clear auth state so upper layers can re-login.
                await tokenManager.clearAll();
              }
            }
          }

          // End error-recovery branch, continue with original Dio error chain.
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
