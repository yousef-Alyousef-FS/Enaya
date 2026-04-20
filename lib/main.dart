import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/di/injection.dart';
import 'package:enaya/core/theme/app_theme.dart';
import 'package:enaya/core/routing/app_router.dart';
import 'package:provider/provider.dart';
import 'package:enaya/features/auth/presentation/state/auth_view_model.dart';
import 'package:enaya/features/appointments/presentation/state/appointment_state.dart';
import 'package:enaya/features/dashboard/reception/presentation/state/reception_dashboard_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  // Initialize Dependency Injection
  await initGetIt();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('ar', 'SA'),
      child: const EnayaApp(),
    ),
  );
}

class EnayaApp extends StatelessWidget {
  const EnayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<ReceptionDashboardState>()),
        ChangeNotifierProvider(create: (_) => getIt<AppointmentState>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: false,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Enaya Medical Center',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
  
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
