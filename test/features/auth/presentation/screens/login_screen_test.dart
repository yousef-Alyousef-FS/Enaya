import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enaya/core/di/injection.dart';
import 'package:enaya/features/auth/domain/entities/user_entity.dart';
import 'package:enaya/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/login_usecase.dart';
import 'package:enaya/features/auth/domain/usecases/signup_usecase.dart';
import 'package:enaya/features/auth/presentation/screens/login_screen.dart';
import 'package:enaya/features/auth/presentation/state/auth_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// 1. Mock the UseCases
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSignupUseCase extends Mock implements SignupUsecase {}

class MockForgotPasswordUseCase extends Mock implements ForgotPasswordUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSignupUseCase mockSignupUseCase;
  late MockForgotPasswordUseCase mockForgotPasswordUseCase;

  setUp(() async {
    await GetIt.instance.reset();

    mockLoginUseCase = MockLoginUseCase();
    mockSignupUseCase = MockSignupUseCase();
    mockForgotPasswordUseCase = MockForgotPasswordUseCase();

    getIt.registerLazySingleton<LoginUseCase>(() => mockLoginUseCase);
    getIt.registerLazySingleton<SignupUsecase>(() => mockSignupUseCase);
    getIt.registerLazySingleton<ForgotPasswordUseCase>(
      () => mockForgotPasswordUseCase,
    );
    getIt.registerFactory(
      () => AuthViewModel(
        loginUseCase: getIt(),
        signupUseCase: getIt(),
        forgotPasswordUseCase: getIt(),
        logoutUseCase: getIt(),
      ),
    );
  });

  // 2. Helper to create GoRouter for testing
  Widget createWidgetUnderTest() {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(body: Text('Home Page')),
        ),
      ],
    );

    return ScreenUtilInit(
      designSize: const Size(768, 1024),
      builder: (context, child) => MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets('Should show validation error when fields are empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle(); // Wait for routing to settle

    final loginButton = find.byType(ElevatedButton);
    await tester.tap(loginButton);
    await tester.pump();

    expect(find.text('Please enter your username or email'), findsOneWidget);
  });

  testWidgets('Should navigate to home on success', (
    WidgetTester tester,
  ) async {
    // Arrange
    const testUser = User(
      id: 1,
      email: 'test@test.com',
      userName: 'tester',
      roleId: 1,
      phone: '123456789',
    );
    when(
      () => mockLoginUseCase(
          LoginParams(usernameOrEmail: 'tester@mail.com', password: 'password123')
      ),
    ).thenAnswer((_) async => const Right(testUser));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Fill fields
    await tester.enterText(find.byType(TextFormField).at(0), 'tester@mail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    // Act
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Start animation
    await tester.pumpAndSettle(); // Wait for navigation

    // Assert
    expect(find.text('Home Page'), findsOneWidget);
  });
}
