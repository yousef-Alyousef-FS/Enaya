import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../routing/app_router.dart';
import 'token_manager.dart';

/// Central service to manage FCM lifecycle and interaction with Laravel backend.
class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final Dio _dio;
  final TokenManager _tokenManager;

  NotificationService(this._dio, this._tokenManager);

  /// Standard entry point called on app startup.
  Future<void> initialize() async {
    // [SAFETY]: Verify platform support before calling Firebase methods
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    try {
      // 1. Request permission
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (kDebugMode) {
        print(
          '>>> FCM User granted permission: ${settings.authorizationStatus}',
        );
      }

      // 2. Setup message listeners
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // 4. Token Refresh Listener
      _fcm.onTokenRefresh.listen((newToken) async {
        final sanctumToken = await _tokenManager.getToken();
        if (sanctumToken != null && sanctumToken.isNotEmpty) {
          await uploadDeviceToken(fcmToken: newToken);
        }
      });

      // 5. Check for initial message (if app launched from notification)
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('>>> NotificationService: Failed to initialize: $e');
      }
    }
  }

  /// Sends the unique FCM device token to the Laravel /device-token endpoint.
  Future<void> uploadDeviceToken({String? fcmToken}) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    try {
      final token = fcmToken ?? await _fcm.getToken();
      if (token == null) return;

      if (kDebugMode) {
        print('>>> Uploading FCM Token: $token');
      }

      await _dio.post(
        '/device-token',
        data: {
          'fcm_token': token,
          'device_type': Platform.isAndroid ? 'android' : 'ios',
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('>>> FCM Token upload failed: $e');
      }
    }
  }

  /// Removes the device token on logout.
  Future<void> removeDeviceTokenOnLogout() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    try {
      final fcmToken = await _fcm.getToken();
      await _dio.post('/logout', data: {'fcm_token': fcmToken});
    } catch (_) {}
  }

  /// Handle messages received while the app is in foreground.
  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('>>> FCM Foreground Message: ${message.notification?.title}');
    }
    // TODO: Trigger a UI event (NotificationCubit refresh or Local Notification)
  }

  /// Handle tap on notification while app is in background.
  void _handleMessageOpenedApp(RemoteMessage message) {
    _handleNotificationTap(message);
  }

  /// Central routing logic based on notification data payload.
  void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    final String? type = data['type']?.toString();
    final String? id = (data['id'] ?? data['appointment_id'])?.toString();

    if (type == null) return;

    if (kDebugMode) {
      print('>>> FCM Tap Action: Type=$type, ID=$id');
    }

    // ⭐ Navigation Strategy based on Notification Type
    if (type.contains('appointment') || type.contains('reminder')) {
      if (id != null) {
        AppRouter.router.push(
          AppRouter.appointmentDetails,
          extra: {'appointmentId': id, 'fromNotification': true},
        );
      } else {
        AppRouter.router.push('/appointments');
      }
    } else if (type.contains('prescription')) {
      AppRouter.router.push('/medical-history');
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background handler,
  // make sure you call `Firebase.initializeApp` first.
  if (kDebugMode) {
    print(">>> FCM Background Message: ${message.messageId}");
  }
}
