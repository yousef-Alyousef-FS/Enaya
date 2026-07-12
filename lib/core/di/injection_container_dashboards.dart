import 'package:get_it/get_it.dart';
import '../../../features/dashboard/doctor/presentation/cubit/doctor_dashboard_cubit.dart';
import '../../../features/dashboard/patient/presentation/cubit/patient_dashboard_cubit.dart';
import '../../../features/dashboard/receptionist/presentation/cubit/receptionist_dashboard_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDashboardsInjection() async {
  getIt.registerFactory(
    () => ReceptionistDashboardCubit(getStatsUseCase: getIt(), getAppointmentsUseCase: getIt()),
  );

  getIt.registerFactory(
    () => DoctorDashboardCubit(
      getStatsUseCase: getIt(),
      getAppointmentsUseCase: getIt(),
      updateStatusUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => PatientDashboardCubit(getIt()),
  );
}
