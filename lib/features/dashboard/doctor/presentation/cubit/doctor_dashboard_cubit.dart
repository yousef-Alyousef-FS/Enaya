import '../../../../appointments/domain/entities/appointment_entity.dart';
import '../../../../appointments/domain/entities/appointment_stats.dart';
import '../../../../appointments/domain/usecases/get_appointments_usecase.dart';
import '../../../../appointments/domain/usecases/get_appointments_stats_usecase.dart';
import '../../../../appointments/domain/usecases/update_appointment_status_usecase.dart';
import '../../../../appointments/domain/entities/appointment_status.dart';
import '../../domain/entities/doctor_dashboard_data.dart';
import 'doctor_dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  final GetAppointmentsStatsUseCase getStatsUseCase;
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final UpdateAppointmentStatusUseCase updateStatusUseCase;

  DoctorDashboardCubit({
    required this.getStatsUseCase,
    required this.getAppointmentsUseCase,
    required this.updateStatusUseCase,
  }) : super(const DoctorDashboardState.initial());

  Future<void> load(String doctorId) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    // 1. إطلاق الطلبات بالتوازي لسرعة الأداء
    final statsFuture = getStatsUseCase(
      GetAppointmentsStatsParams(doctorId: doctorId, date: dayStart),
    );
    final appsFuture = getAppointmentsUseCase(
      GetAppointmentsParams(
        doctorId: doctorId,
        date: dayStart,
        endDate: dayEnd,
        limit: 200,
      ),
    );

    final statsResult = await statsFuture;
    final appsResult = await appsFuture;

    // 2. فحص نتيجة الإحصائيات
    final stats = statsResult.fold((failure) {
      emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      return null;
    }, (success) => success);
    if (stats == null) return;

    // 3. فحص نتيجة المواعيد
    final appointments = appsResult.fold((failure) {
      emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      return null;
    }, (success) => success);
    if (appointments == null) return;

    // 4. تحديد المريض الحالي والقادم (Business Logic)
    final currentPatient = _findCurrentPatient(appointments);
    final upcoming =
        appointments
            .where(
              (a) =>
                  a.status == AppointmentStatus.scheduled ||
                  a.status == AppointmentStatus.confirmed,
            )
            .where((a) => !a.dateTime.isBefore(now))
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // 5. محاولة إيجاد إحصائيات الطبيب الحالي
    DoctorStats? doctorStats;
    for (final item in stats.byDoctor) {
      if (item.doctorId == doctorId) {
        doctorStats = item;
        break;
      }
    }
    final dashboardStats = doctorStats != null
        ? doctorStats.toDashboardData()
        : DoctorDashboardData(
            todayPatients: appointments.length,
            totalConsultations: appointments
                .where((a) => a.status == AppointmentStatus.completed)
                .length,
            pendingReports: appointments
                .where((a) => a.status == AppointmentStatus.inProgress)
                .length,
          );

    // 6. تحديث الحالة النهائية
    emit(
      state.copyWith(
        isLoading: false,
        stats: dashboardStats,
        currentAppointment: currentPatient,
        upcomingAppointments: upcoming,
      ),
    );
  }

  /// يجد المريض الحالي: الأولوية لـ "قيد الكشف" ثم لـ "وصل للعيادة"
  AppointmentEntity? _findCurrentPatient(List<AppointmentEntity> appointments) {
    final inProgress =
        appointments
            .where((a) => a.status == AppointmentStatus.inProgress)
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    if (inProgress.isNotEmpty) {
      return inProgress.first;
    }

    final arrived =
        appointments
            .where((a) => a.status == AppointmentStatus.arrived)
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return arrived.isNotEmpty ? arrived.first : null;
  }

  Future<void> updateAppointmentStatus(
    String doctorId,
    String appointmentId,
    AppointmentStatus status,
  ) async {
    final result = await updateStatusUseCase(
      UpdateAppointmentStatusParams(
        appointmentId: appointmentId,
        status: status,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => load(doctorId),
    );
  }
}

extension on DoctorStats {
  DoctorDashboardData toDashboardData() {
    final pending = totalAppointments - completed;
    return DoctorDashboardData(
      todayPatients: totalAppointments,
      totalConsultations: completed,
      pendingReports: pending < 0 ? 0 : pending,
    );
  }
}
