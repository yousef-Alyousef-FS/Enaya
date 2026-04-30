import 'package:go_router/go_router.dart';
import 'package:enaya/features/appointments/presentation/appointments_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import 'package:enaya/features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/change_password_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/dashboard/doctor/presentation/pages/doctor_dashboard_page.dart';
import '../../features/dashboard/patient/presentation/pages/patient_dashboard_page.dart';
import '../../features/dashboard/receptionist/presentation/pages/receptionist_dashboard_page.dart';
import '../constants/dev_config.dart';
import '../screens/developer_screen.dart';
import '../screens/no_internet_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String devMenu = '/dev-menu';
  static const String noInternet = '/no-internet';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String changePassword = '/change-password';
  static const String appointmentsOverview = '/appointments';
  static const String doctorHome = '/doctor';
  static const String patientHome = '/patient';
  static const String receptionistHome = '/receptionist';

  static final router = GoRouter(
    initialLocation: DevConfig.isDevMode ? devMenu : splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: devMenu, builder: (context, state) => const DeveloperScreen()),
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
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              final mode = AppointmentsPage.mapRoleIdToMode(authState.currentUser?.roleId);
              return AppointmentsPage(mode: mode);
            },
          );
        },
      ),
      GoRoute(path: doctorHome, builder: (context, state) => const DoctorDashboardPage()),
      GoRoute(path: patientHome, builder: (context, state) => const PatientDashboardPage()),
      GoRoute(
        path: receptionistHome,
        builder: (context, state) => const ReceptionistDashboardPage(),
      ),
    ],
  );
}
