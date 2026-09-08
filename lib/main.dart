import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/di/injection.dart';
import 'package:enaya/core/language/language_manager.dart';
import 'package:enaya/core/routing/app_router.dart';
import 'package:enaya/core/services/settings_service.dart';
import 'package:enaya/core/theme/app_theme.dart';
import 'package:enaya/core/theme/cubit/theme_cubit.dart';
import 'package:enaya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize Dependency Injection
  await initGetIt();

  // ⭐ Firebase Initialization (Strictly Mobile Only)
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await getIt<NotificationService>().initialize();
    } catch (e) {
      if (kDebugMode) {
        print('>>> Firebase Initialization skipped or failed: $e');
      }
    }
  }

  final settingsService = getIt<SettingsService>();
  final savedLanguage = settingsService.getLanguage();
  final initialLocale = savedLanguage == 'en'
      ? englishLocale
      : savedLanguage == 'ar'
      ? arabicLocale
      : const Locale('ar', 'SA');

  runApp(
    EasyLocalization(
      supportedLocales: const [englishLocale, arabicLocale],
      path: 'assets/translations',
      fallbackLocale: englishLocale,
      startLocale: initialLocale,
      child: const EnayaApp(),
    ),
  );
}

class EnayaApp extends StatelessWidget {
  const EnayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ThemeCubit>()),
        BlocProvider(create: (context) => getIt<AuthCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Enaya Medical Center',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
