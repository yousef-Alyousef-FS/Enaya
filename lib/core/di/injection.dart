import 'package:get_it/get_it.dart';
import 'injection_container_core.dart';
import 'injection_container_auth.dart';
import 'injection_container_patients.dart';
import 'injection_container_appointments.dart';
import 'injection_container_dashboards.dart';

final getIt = GetIt.instance;

/// Central entry point for dependency injection.
/// [ARCH_FLAG]: Split into feature-specific containers to avoid a massive God File.
Future<void> initGetIt() async {
  await initCoreInjection();
  await initAuthInjection();
  await initPatientsInjection();
  await initAppointmentsInjection();
  await initDashboardsInjection();
}
