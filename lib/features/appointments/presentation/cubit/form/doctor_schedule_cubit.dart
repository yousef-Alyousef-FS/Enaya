import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_doctor_schedule_usecase.dart';
import '../../../domain/usecases/save_doctor_schedule_usecase.dart';
import 'doctor_schedule_state.dart';
import '../../../data/models/work_schedule_model.dart';

class DoctorScheduleCubit extends Cubit<DoctorScheduleState> {
  final GetDoctorScheduleUseCase getScheduleUseCase;
  final SaveDoctorScheduleUseCase saveScheduleUseCase;

  DoctorScheduleCubit({
    required this.getScheduleUseCase,
    required this.saveScheduleUseCase,
  }) : super(const DoctorScheduleState.initial());

  Future<void> loadSchedule() async {
    emit(state.copyWith(isLoading: true));

    final result = await getScheduleUseCase();

    emit(state.copyWith(isLoading: false, schedule: result));
  }

  void updateEntry(WorkScheduleEntry entry) {
    final newSchedule = state.schedule.map((e) {
      return e.day == entry.day ? entry : e;
    }).toList();

    emit(state.copyWith(schedule: newSchedule));
  }

  Future<void> saveSchedule() async {
    emit(state.copyWith(isLoading: true));
    await saveScheduleUseCase(state.schedule);
    emit(state.copyWith(isLoading: false));
  }
}
