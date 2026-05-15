import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/di/injection.dart';
import 'package:enaya/core/routing/app_router.dart';
import 'package:enaya/features/appointments/presentation/screens/schedule_appointment_screen.dart';
import 'package:enaya/features/patients/domain/entities/patient_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/services/patient_session.dart';
import '../../../../../core/widgets/section_header.dart';
import '../../../data/models/appointments_overview_view_mode.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../cubit/patient_appointments_cubit.dart';
import '../../cubit/patient_appointments_state.dart';
import '../../widgets/shared/appointment_card.dart';
import '../../widgets/shared/appointments_feedback_state.dart';

import '../../widgets/patient/book_appointment_card.dart';
import '../../widgets/patient/patient_next_appointment_card.dart';

/// Patient-facing appointment timeline with the next visit and history list.
class PatientAppointmentsScreen extends StatelessWidget {
  final bool isEmbedded;

  const PatientAppointmentsScreen({super.key, this.isEmbedded = true});

  @override
  Widget build(BuildContext context) {
    final session = PatientSession();
    final patientId = session.patientId ?? 'p1';
    final patientEntity = session.patientEntity ?? _createDefaultPatient();

    return BlocProvider(
      create: (context) =>
          getIt<PatientAppointmentsCubit>()..loadAppointments(patientId),
      child: BlocBuilder<PatientAppointmentsCubit, PatientAppointmentsState>(
        builder: (context, state) {
          final isLoading = state.status == PatientAppointmentsStatus.loading;
          final isFailure = state.status == PatientAppointmentsStatus.failure;
          final nextApp = state.upcomingAppointments.isNotEmpty
              ? state.upcomingAppointments.first
              : null;
          final history = state.pastAppointments;

          final content = RefreshIndicator(
            onRefresh: () => context
                .read<PatientAppointmentsCubit>()
                .loadAppointments(patientId),
            child: ListView(
              padding: isEmbedded ? EdgeInsets.zero : const EdgeInsets.all(24),
              shrinkWrap: isEmbedded,
              physics: isEmbedded
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
              children: [
                BookAppointmentCard(
                  onTap: () async {
                    final result = await context.push(
                      AppRouter.scheduleAppointment,
                      extra: {'patient': patientEntity, 'isPatientMode': true},
                    );
                    if (result == true && context.mounted) {
                      context.read<PatientAppointmentsCubit>().loadAppointments(
                        patientId,
                      );
                    }
                  },
                ),
                const SizedBox(height: 32),

                if (isFailure) ...[
                  AppointmentsInlineError(
                    message: state.errorMessage,
                    onRetry: () => context
                        .read<PatientAppointmentsCubit>()
                        .loadAppointments(patientId),
                  ),
                  const SizedBox(height: 20),
                ],

                if (state.upcomingAppointments.isEmpty &&
                    state.pastAppointments.isEmpty &&
                    !isLoading)
                  _buildEmptyState(context)
                else ...[
                  if (nextApp != null) ...[
                    AppSectionHeader(title: 'next_appointment'.tr()),
                    const SizedBox(height: 16),
                    PatientNextAppointmentCard(
                      appointment: nextApp,
                      onCancel: () => _openDetails(context, nextApp, patientId),
                      onReschedule: () =>
                          _rescheduleAppointment(context, nextApp),
                    ),
                    const SizedBox(height: 32),
                  ],
                  if (history.isNotEmpty) ...[
                    AppSectionHeader(title: 'previous_appointments'.tr()),
                    const SizedBox(height: 16),
                    ...history.map(
                      (app) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: AppointmentCard(
                          appointment: app,
                          mode: AppointmentsOverviewMode.patient,
                          onTap: () => _openDetails(context, app, patientId),
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          );

          if (isEmbedded) {
            return content;
          }

          return Scaffold(body: SafeArea(child: content));
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppointmentsInlineEmpty(
      title: 'no_appointments_found'.tr(),
      subtitle: 'find_your_doctor_hint'.tr(),
      actionLabel: 'new_appointment'.tr(),
      onAction: () => _openBookingFlow(context),
    );
  }

  void _openBookingFlow(BuildContext context) {
    final session = PatientSession();
    final patientEntity = session.patientEntity ?? _createDefaultPatient();
    final patientId = session.patientId ?? 'p1';
    context
        .push(
          AppRouter.scheduleAppointment,
          extra: {'patient': patientEntity, 'isPatientMode': true},
        )
        .then((_) {
          if (context.mounted) {
            context.read<PatientAppointmentsCubit>().loadAppointments(
              patientId,
            );
          }
        });
  }

  Future<void> _rescheduleAppointment(
    BuildContext context,
    AppointmentEntity appointment,
  ) async {
    final result = await context.push(
      AppRouter.scheduleAppointment,
      extra: {
        'appointment': appointment,
        'mode': AppointmentScreenMode.reschedule,
      },
    );

    if (result == true && context.mounted) {
      final session = PatientSession();
      final patientId = session.patientId ?? 'p1';
      context.read<PatientAppointmentsCubit>().loadAppointments(patientId);
    }
  }

  void _openDetails(
    BuildContext context,
    AppointmentEntity appointment,
    String patientId,
  ) {
    context.push(
      AppRouter.appointmentDetails,
      extra: {
        'appointment': appointment,
        'role': AppointmentsOverviewMode.patient,
        'onDataChanged': () {
          if (context.mounted) {
            context.read<PatientAppointmentsCubit>().loadAppointments(
              patientId,
            );
          }
        },
      },
    );
  }

  /// Returns a default patient entity when no session exists.
  /// Uses 'p1' (Ahmed Ali) from mock data to ensure appointments load correctly.
  PatientEntity _createDefaultPatient() {
    return PatientEntity(
      id: 'p1',
      name: 'Ahmed Ali',
      email: 'ahmed@example.com',
      phone: '0123456789',
      dateOfBirth: DateTime(1990, 1, 1),
      medicalHistory: 'None',
      address: 'Cairo, Egypt',
    );
  }
}
