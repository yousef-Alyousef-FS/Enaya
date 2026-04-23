import 'package:flutter_bloc/flutter_bloc.dart';

import 'doctor_dashboard_state.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  DoctorDashboardCubit() : super(const DoctorDashboardState.initial());
}
