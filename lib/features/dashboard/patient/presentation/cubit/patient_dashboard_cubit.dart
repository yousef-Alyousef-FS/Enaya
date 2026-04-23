import 'package:flutter_bloc/flutter_bloc.dart';

import 'patient_dashboard_state.dart';

class PatientDashboardCubit extends Cubit<PatientDashboardState> {
  PatientDashboardCubit() : super(const PatientDashboardState.initial());
}
