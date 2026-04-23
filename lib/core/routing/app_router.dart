import 'package:go_router/go_router.dart';
import 'package:enaya/features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/change_password_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/appointments/presentation/screens/appointments_overview_screen.dart';
import '../../features/dashboard/doctor/presentation/pages/doctor_dashboard_page.dart';
import '../../features/dashboard/patient/presentation/pages/patient_dashboard_page.dart';
import '../../features/dashboard/reception/presentation/pages/reception_dashboard_page.dart';
import '../widgets/no_internet_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String noInternet = '/no-internet';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String changePassword = '/change-password';
  static const String appointmentsOverview = '/appointments';
  static const String receptionistHome = '/receptionist';
  static const String doctorHome = '/doctor';
  static const String patientHome = '/patient';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: noInternet,
        builder: (context, state) {
          final nextRoute = state.uri.queryParameters['next'] ?? login;
          return NoInternetScreen(nextRoute: nextRoute);
        },
      ),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: signup, builder: (context, state) => const SignupScreen()),
      GoRoute(
        path: verifyEmail,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return VerifyEmailScreen(email: email);
        },
      ),
      GoRoute(path: forgotPassword, builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(
        path: resetPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          return ResetPasswordScreen(initialEmail: email);
        },
      ),
      GoRoute(path: changePassword, builder: (context, state) => const ChangePasswordScreen()),
      GoRoute(
        path: appointmentsOverview,
        builder: (context, state) {
          final modeStr = state.uri.queryParameters['mode'];
          final mode = AppointmentsOverviewMode.values.firstWhere(
            (e) => e.name == modeStr,
            orElse: () => AppointmentsOverviewMode.generic,
          );
          return AppointmentsOverviewScreen(
            config: AppointmentsOverviewConfig(mode: mode),
          );
        },
      ),
      GoRoute(path: receptionistHome, builder: (context, state) => const ReceptionDashboardPage()),

      GoRoute(path: doctorHome, builder: (context, state) => const DoctorDashboardPage()),
      GoRoute(path: patientHome, builder: (context, state) => const PatientDashboardPage()),
    ],
  );
}
