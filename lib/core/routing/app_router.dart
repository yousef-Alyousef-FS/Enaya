import 'package:go_router/go_router.dart';
import 'package:enaya/features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/dashboard/presentation/screens/receptionist_home_screen.dart';
import '../../features/dashboard/presentation/screens/doctor_home_screen.dart';
import '../../features/dashboard/presentation/screens/patient_home_screen.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String receptionistHome = '/receptionist';
  static const String doctorHome = '/doctor';
  static const String patientHome = '/patient';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: signup, builder: (context, state) => const SignupScreen()),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: receptionistHome,
        builder: (context, state) => const ReceptionistHomeScreen(),
      ),
      GoRoute(
        path: doctorHome,
        builder: (context, state) => const DoctorHomeScreen(),
      ),
      GoRoute(
        path: patientHome,
        builder: (context, state) => const PatientHomeScreen(),
      ),
    ],
  );
}
