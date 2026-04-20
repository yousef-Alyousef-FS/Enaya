import '../../../../../core/view_models/base_view_model.dart';
import '../../../../appointments/domain/entities/appointment_entity.dart';
import '../../../../appointments/domain/usecases/get_today_appointments_usecase.dart';
import '../../../../appointments/domain/usecases/update_appointment_status_usecase.dart';
import '../../../../appointments/domain/entities/appointment_status.dart';

class ReceptionDashboardState extends BaseViewModel {
  final GetTodayAppointmentsUseCase _getTodayAppointmentsUseCase;
  final UpdateAppointmentStatusUseCase _updateAppointmentStatusUseCase;

  List<AppointmentEntity> _todayAppointments = [];
  List<AppointmentEntity> _waitingList = [];
  final int userRoleId; // نمرر الـ Role ID عند إنشاء الـ State

  ReceptionDashboardState({
    required GetTodayAppointmentsUseCase getTodayAppointmentsUseCase,
    required UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase,
    required this.userRoleId,
  }) : _getTodayAppointmentsUseCase = getTodayAppointmentsUseCase,
       _updateAppointmentStatusUseCase = updateAppointmentStatusUseCase;

  List<AppointmentEntity> get todayAppointments => _todayAppointments;
  List<AppointmentEntity> get waitingList => _waitingList;

  // التحقق من صلاحية الاستقبال
  bool get isReceptionist => userRoleId == 3; // افترضنا أن 3 هو الاستقبال

  Future<void> loadDashboardData() async {
    setState(ViewState.loading);

    final result = await _getTodayAppointmentsUseCase(
      GetTodayAppointmentsParams(),
    );

    result.fold((failure) => setError(failure.message), (appointments) {
      _todayAppointments = appointments
          .where((a) => a.status == AppointmentStatus.scheduled)
          .toList();
      _waitingList = appointments
          .where((a) => a.status == AppointmentStatus.arrived)
          .toList();
      setState(ViewState.success);
    });
  }

  Future<void> markPatientAsArrived(String appointmentId) async {
    if (!isReceptionist) {
      setError("Unauthorized: Only receptionist can perform this action.");
      return;
    }

    final result = await _updateAppointmentStatusUseCase(
      UpdateAppointmentStatusParams(
        appointmentId: appointmentId,
        status: AppointmentStatus.arrived,
      ),
    );

    result.fold((failure) => setError(failure.message), (updatedAppointment) {
      _todayAppointments.removeWhere((a) => a.id == appointmentId);
      _waitingList.add(updatedAppointment);
      notifyListeners();
    });
  }
}
