import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enaya/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enaya/core/di/injection.dart';
import 'package:enaya/features/auth/presentation/screens/splash_screen.dart';
import 'package:enaya/core/screens/developer_screen.dart';
import 'package:get_it/get_it.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // 1. Reset GetIt if it was already initialized
    await GetIt.instance.reset();
    
    // 2. Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    
    // 3. Initialize DI
    await initGetIt();

    // 4. Pump the widget with EasyLocalization
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        startLocale: const Locale('ar', 'SA'),
        child: const EnayaApp(),
      ),
    );

    // 5. Wait for the app to settle (GoRouter, ScreenUtil, etc)
    await tester.pumpAndSettle();

    // 6. Verify that either Splash or Developer Screen is visible
    // (depends on DevConfig.isDevMode in debug mode)
    final splashScreenFound = find.byType(SplashScreen);
    final devScreenFound = find.byType(DeveloperScreen);
    
    expect(
      splashScreenFound.evaluate().isNotEmpty || devScreenFound.evaluate().isNotEmpty,
      true,
    );
  });
}
