import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../cache/cache_helper.dart';
import '../constants/api_constants.dart';
import '../di/injection.dart';
import '../services/token_manager.dart';

class DioFactory {
  static Dio? _dio;
  static final Logger _logger = Logger();

  static Dio getDio() {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: 'https://your-api-url.com/api/',
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            try {
              // الحصول على التوكن من TokenManager
              final tokenManager = getIt<TokenManager>();
              final authHeader = await tokenManager.getAuthorizationHeader();
              
              if (authHeader != null) {
                options.headers['Authorization'] = authHeader;
                _logger.d('🔐 تم إضافة التوكن للطلب: ${options.path}');
              }
            } catch (e) {
              _logger.e('❌ خطأ في إضافة التوكن: $e');
            }
            
            return handler.next(options);
          },

          onResponse: (response, handler) {
            _logger.d('✅ استجابة ناجحة: ${response.statusCode} - ${response.requestOptions.path}');
            return handler.next(response);
          },

          onError: (DioException e, handler) {
            _logger.e('❌ خطأ في الطلب: ${e.response?.statusCode} - ${e.message}');
            
            // معالجة خاصة للـ 401 Unauthorized
            if (e.response?.statusCode == 401) {
              _logger.w('⚠️ توكن غير صحيح أو منتهي الصلاحية');
              // يمكن إضافة منطق لتحديث التوكن هنا
            }
            
            return handler.next(e);
          },
        ),
      );
    }
    return _dio!;
  }

  /// إعادة تعيين الـ Dio (مفيد في الاختبارات)
  static void resetDio() {
    _dio = null;
  }
}
