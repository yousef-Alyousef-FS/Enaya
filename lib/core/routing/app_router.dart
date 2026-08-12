import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/features/appointments/data/models/appointments_overview_view_mode.dart';
import 'package:enaya/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/appointments/domain/entities/appointment_entity.dart';
import '../../features/appointments/presentation/appointments_page.dart';
import '../../features/appointments/presentation/cubit/appointments_cubit_imports.dart';
import '../../features/appointments/presentation/screens/details/appointment_details_screen.dart';
import '../../features/appointments/presentation/screens/doctor/doctor_work_schedule_screen.dart';
import '../../features/appointments/presentation/screens/form/appointment_success_screen.dart';
import '../../features/appointments/presentation/screens/form/edit_appointment_screen.dart';
import '../../features/appointments/presentation/screens/form/schedule_appointment_screen.dart';
import '../../features/appointments/presentation/screens/patient/patient_appointment_history_screen.dart';
import '../../features/auth/presentation/screens/change_password_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/dashboard/doctor/presentation/pages/doctor_dashboard_page.dart';
import '../../features/dashboard/patient/presentation/pages/patient_dashboard_page.dart';
import '../../features/dashboard/receptionist/presentation/pages/receptionist_dashboard_page.dart';
import '../../features/notifications/data/repositories/notifications_repository.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/patients/domain/entities/patient_entity.dart';
import '../../features/patients/presentation/screens/complete_profile_screen.dart';
import '../../features/patients/presentation/screens/edit_patient_screen.dart';
import '../../features/patients/presentation/screens/patient_details_screen.dart';
import '../../features/patients/presentation/screens/patient_registration_screen.dart';
import '../../features/patients/presentation/screens/patients_list_screen.dart';
import '../../features/patients/presentation/state/patient_profile_cubit.dart';
import '../../features/patients/presentation/state/patients_cubit.dart';
import '../../features/prescriptions/presentation/cubit/prescription_cubit.dart';
import '../../features/prescriptions/presentation/screens/add_prescription_screen.dart';
import '../../features/session/presentation/cubit/session_cubit.dart';
import '../../features/session/presentation/screens/session_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../constants/dev_config.dart';
import '../di/injection.dart';
import '../screens/developer_screen.dart';
import '../screens/no_internet_screen.dart';
import '../services/patient_session.dart';
import '../services/session_manager.dart';

/// Central router definition for the application.
///
/// This keeps all top-level navigation paths in one place and supports the
/// developer menu for quick screen inspection.
class AppRouter {
  // Commons
  static const String splash = '/';
  static const String devMenu = '/dev-menu';
  static const String noInternet = '/no-internet';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String changePassword = '/change-password';
  // Appointments
  static const String appointmentsOverview = '/appointments';
  static const String appointmentDetails = '/appointments/details';
  static const String editAppointment = '/appointments/edit';
  static const String scheduleAppointment = '/appointments/schedule';
  static const String appointmentSuccess = '/appointments/success';
  static const String appointmentHistory = '/appointments/history';

  static const String doctorHome = '/doctor';
  static const String doctorSchedule = '/doctor/schedule';
  static const String patientHome = '/patient';
  static const String receptionistHome = '/receptionist';
  static const String patients = '/patients';
  static const String patientDetails = '/patients/details';
  static const String editPatient = '/patients/edit';
  static const String patientRegistration = '/patients/register';
  static const String completeProfile = '/patients/complete-profile';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  // Doctor Session & Prescriptions
  static const String doctorSession = '/doctor/session';
  static const String addPrescription = '/doctor/prescription/add';

  static final router = GoRouter(
    initialLocation: DevConfig.isDevMode ? devMenu : splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: devMenu,
        builder: (context, state) => const DeveloperScreen(),
      ),
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
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: resetPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          return ResetPasswordScreen(initialEmail: email);
        },
      ),
      GoRoute(
        path: changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: appointmentsOverview,
        builder: (context, state) {
          final requestedMode = state.uri.queryParameters['mode'];
          final roleId = getIt<SessionManager>().currentRoleId;

          final mode = AppointmentsPage.resolveMode(
            requestedMode: requestedMode,
            roleId: roleId,
          );
          return AppointmentsPage(mode: mode);
        },
      ),
      GoRoute(
        path: doctorHome,
        builder: (context, state) => const DoctorDashboardPage(),
      ),
      GoRoute(
        path: doctorSchedule,
        builder: (context, state) {
          final doctorId =
              state.uri.queryParameters['doctorId'] ??
              getIt<SessionManager>().currentRoleId;
          return BlocProvider(
            create: (context) => getIt<DoctorAvailabilityCubit>(),
            child: DoctorWorkScheduleScreen(doctorId: doctorId.toString()),
          );
        },
      ),
      GoRoute(
        path: patientHome,
        builder: (context, state) => const PatientDashboardPage(),
      ),
      GoRoute(
        path: receptionistHome,
        builder: (context, state) => const ReceptionistDashboardPage(),
      ),
      GoRoute(
        path: patients,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<PatientsCubit>(),
          child: const PatientsListScreen(),
        ),
      ),
      GoRoute(
        path: patientDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! Map<String, dynamic>) {
            return const _InvalidRouteDataScreen(
              title: 'Missing patient details',
            );
          }

          final patient = extra['patient'];
          if (patient is! PatientEntity) {
            return const _InvalidRouteDataScreen(title: 'Invalid patient data');
          }

          final readOnly = extra['readOnly'] as bool? ?? false;

          return BlocProvider(
            create: (context) => getIt<PatientsCubit>(),
            child: PatientDetailsScreen(patient: patient, readOnly: readOnly),
          );
        },
      ),
      GoRoute(
        path: editPatient,
        builder: (context, state) {
          final patient = state.extra;
          if (patient is! PatientEntity) {
            return const _InvalidRouteDataScreen(title: 'Invalid patient data');
          }

          return BlocProvider(
            create: (context) => getIt<PatientsCubit>(),
            child: EditPatientScreen(patient: patient),
          );
        },
      ),
      GoRoute(
        path: patientRegistration,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<PatientsCubit>(),
          child: const PatientRegistrationScreen(),
        ),
      ),
      GoRoute(
        path: completeProfile,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<PatientProfileCubit>(),
          child: const CompleteProfileScreen(),
        ),
      ),
      GoRoute(
        path: notifications,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              NotificationsCubit(FakeNotificationsRepository())..load(),
          child: const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: appointmentDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! Map<String, dynamic>) {
            return Scaffold(
              body: Center(
                child: Text('missing_appointment_details_data'.tr()),
              ),
            );
          }

          final appointment = extra['appointment'];
          final role = extra['role'];

          if (appointment is! AppointmentEntity ||
              role is! AppointmentsOverviewMode) {
            return Scaffold(
              body: Center(
                child: Text('invalid_appointment_details_data'.tr()),
              ),
            );
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
            return Scaffold(
              body: Center(child: Text('missing_appointment_edit_data'.tr())),
            );
          }

          final appointment = extra['appointment'];
          if (appointment is! AppointmentEntity) {
            return Scaffold(
              body: Center(child: Text('invalid_appointment_edit_data'.tr())),
            );
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
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return AppointmentSuccessScreen(
            dateTime: extra?['dateTime'],
            doctorName: extra?['doctorName'],
          );
        },
      ),
      GoRoute(
        path: appointmentHistory,
        builder: (context, state) {
          final patientId = PatientSession().patientId ?? 'p1';
          return BlocProvider(
            create: (context) =>
                getIt<PatientAppointmentsCubit>()..loadAppointments(patientId),
            child: const PatientAppointmentHistoryScreen(),
          );
        },
      ),
      GoRoute(
        path: '$doctorSession/:appointmentId',
        builder: (context, state) {
          final appointmentId = int.tryParse(
            state.pathParameters['appointmentId'] ?? '',
          );
          if (appointmentId == null) {
            return const _InvalidRouteDataScreen(
              title: 'Invalid appointment ID',
            );
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    getIt<SessionCubit>()..loadOrStartSession(appointmentId),
              ),
              BlocProvider(
                create: (context) =>
                    getIt<PrescriptionCubit>()
                      ..loadPrescriptions(appointmentId),
              ),
            ],
            child: SessionScreen(appointmentId: appointmentId),
          );
        },
      ),
      GoRoute(
        path: '$addPrescription/:appointmentId/:sessionId',
        builder: (context, state) {
          final appointmentId = int.tryParse(
            state.pathParameters['appointmentId'] ?? '',
          );
          final sessionId = int.tryParse(
            state.pathParameters['sessionId'] ?? '',
          );
          if (appointmentId == null || sessionId == null) {
            return const _InvalidRouteDataScreen(title: 'Invalid IDs');
          }
          return BlocProvider(
            create: (context) => getIt<PrescriptionCubit>(),
            child: AddPrescriptionScreen(
              appointmentId: appointmentId,
              sessionId: sessionId,
            ),
          );
        },
      ),
    ],
  );
}

class _InvalidRouteDataScreen extends StatelessWidget {
  const _InvalidRouteDataScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48),
              const SizedBox(height: 16),
              const Text(
                'This screen was opened with incomplete data.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => context.go(AppRouter.patientHome),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Back to dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
