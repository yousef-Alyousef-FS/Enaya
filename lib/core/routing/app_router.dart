import 'package:flutter/material.dart';
import 'package:enaya/features/appointments/data/models/appointments_overview_view_mode.dart';
import 'package:go_router/go_router.dart';
import 'package:enaya/features/auth/presentation/screens/signup_screen.dart';
import '../../features/appointments/domain/entities/appointment_entity.dart';
import '../../features/appointments/presentation/appointments_page.dart';
import '../../features/appointments/presentation/screens/appointment_details_screen.dart';
import '../../features/appointments/presentation/screens/appointment_success_screen.dart';
import '../../features/appointments/presentation/screens/edit_appointment_screen.dart';
import '../../features/appointments/presentation/screens/schedule_appointment_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/change_password_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/patients/presentation/screens/patient_registration_screen.dart';
import '../di/injection.dart';
import '../services/session_manager.dart';
import '../../features/dashboard/doctor/presentation/pages/doctor_dashboard_page.dart';
import '../../features/dashboard/patient/presentation/pages/patient_dashboard_page.dart';
import '../../features/dashboard/receptionist/presentation/pages/receptionist_dashboard_page.dart';
import '../constants/dev_config.dart';
import '../screens/developer_screen.dart';
import '../screens/no_internet_screen.dart';

/// Central router definition for the application.
///
/// This keeps all top-level navigation paths in one place and supports the
/// developer menu for quick screen inspection.
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
  static const String appointmentDetails = '/appointments/details';
  static const String editAppointment = '/appointments/edit';
  static const String scheduleAppointment = '/appointments/schedule';
  static const String appointmentSuccess = '/appointments/success';

  static const String doctorHome = '/doctor';
  static const String patientHome = '/patient';
  static const String receptionistHome = '/receptionist';
  static const String patientRegistration = '/patients/register';

  static final router = GoRouter(
    initialLocation: DevConfig.isDevMode ? devMenu : splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: devMenu, builder: (context, state) => const DeveloperScreen()),
      GoRoute(
        path: noInternet,
        builder: (context, state) {
          // The `next` query parameter preserves the route we should return to
          // after connectivity is restored.
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
          final requestedMode = state.uri.queryParameters['mode'];
          final roleId = getIt<SessionManager>().currentRoleId;

          final mode = AppointmentsPage.resolveMode(requestedMode: requestedMode, roleId: roleId);
          return AppointmentsPage(mode: mode);
        },
      ),
      GoRoute(path: doctorHome, builder: (context, state) => const DoctorDashboardPage()),
      GoRoute(path: patientHome, builder: (context, state) => const PatientDashboardPage()),
      GoRoute(
        path: receptionistHome,
        builder: (context, state) => const ReceptionistDashboardPage(),
      ),
      GoRoute(
        path: patientRegistration,
        builder: (context, state) => const PatientRegistrationScreen(),
      ),
      GoRoute(
        path: appointmentDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! Map<String, dynamic>) {
            return const Scaffold(body: Center(child: Text('Missing appointment details data')));
          }

          final appointment = extra['appointment'];
          final role = extra['role'];

          if (appointment is! AppointmentEntity || role is! AppointmentsOverviewMode) {
            return const Scaffold(body: Center(child: Text('Invalid appointment details data')));
          }

          return AppointmentDetailsScreen(
            appointment: appointment,
            role: role,
            onDataChanged: extra['onDataChanged'] as VoidCallback?,
          );
        },
      ),
      GoRoute(
        path: editAppointment,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! Map<String, dynamic>) {
            return const Scaffold(body: Center(child: Text('Missing appointment edit data')));
          }

          final appointment = extra['appointment'];
          if (appointment is! AppointmentEntity) {
            return const Scaffold(body: Center(child: Text('Invalid appointment edit data')));
          }

          return EditAppointmentScreen(appointment: appointment);
        },
      ),
      GoRoute(
        path: scheduleAppointment,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          return ScheduleAppointmentScreen(
            patient: extra?['patient'],
            doctorId: extra?['doctorId'],
            doctorName: extra?['doctorName'],
            isPatientMode: extra?['isPatientMode'] ?? false,
            mode: extra?['mode'] ?? AppointmentScreenMode.create,
            appointment: extra?['appointment'],
          );
        },
      ),
      GoRoute(
        path: appointmentSuccess,
        builder: (context, state) => const AppointmentSuccessScreen(),
      ),
    ],
  );
}
