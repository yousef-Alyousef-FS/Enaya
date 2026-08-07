import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/services/patient_session.dart';
import '../../../../patients/domain/entities/patient_entity.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../cubit/form/appointment_schedule_cubit.dart';
import '../../cubit/form/appointment_schedule_state.dart';
import '../../widgets/form/appointment_form_steps.dart';

enum AppointmentScreenMode { create, reschedule }

/// [ARCH_FLAG]: Unified booking flow with Final Review Step.
class ScheduleAppointmentScreen extends StatefulWidget {
  final PatientEntity? patient;
  final String? doctorId;
  final String? doctorName;
  final bool isPatientMode;
  final AppointmentScreenMode mode;
  final AppointmentEntity? appointment;

  const ScheduleAppointmentScreen({
    super.key,
    this.patient,
    this.doctorId,
    this.doctorName,
    this.isPatientMode = false,
    this.mode = AppointmentScreenMode.create,
    this.appointment,
  });

  @override
  State<ScheduleAppointmentScreen> createState() =>
      _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen> {
  late final TextEditingController _reasonController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController(text: widget.appointment?.reason);
    _notesController = TextEditingController(text: widget.appointment?.notes);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleNavigation(BuildContext context, AppointmentScheduleState state) {
    final cubit = context.read<AppointmentScheduleCubit>();
    final isLastStep =
        state.currentStep == state.totalSteps(widget.isPatientMode) - 1;

    if (isLastStep) {
      _confirmAppointment(context);
    } else {
      cubit.nextStep(widget.isPatientMode);
    }
  }

  void _previousStep(BuildContext context, AppointmentScheduleState state) {
    final cubit = context.read<AppointmentScheduleCubit>();
    if (state.currentStep > 0) {
      cubit.previousStep();
    } else {
      context.pop();
    }
  }

  void _confirmAppointment(BuildContext context) {
    final cubit = context.read<AppointmentScheduleCubit>();
    if (widget.mode == AppointmentScreenMode.reschedule &&
        widget.appointment != null) {
      cubit.rescheduleAppointment(appointmentId: widget.appointment!.id);
    } else {
      cubit.createAppointment(
        reason: _reasonController.text.trim(),
        notes: _notesController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) {
        final cubit = getIt<AppointmentScheduleCubit>();
        cubit.loadAvailableDoctors();
        final session = PatientSession();
        final resolvedPatient =
            widget.patient ?? session.patientEntity ?? _createDefaultPatient();

        if (widget.mode == AppointmentScreenMode.reschedule &&
            widget.appointment != null) {
          final appointment = widget.appointment!;
          cubit.updateSelectedPatient(resolvedPatient);
          cubit.updateSelectedDoctor(
            widget.doctorId ?? appointment.doctorId,
            widget.doctorName ?? appointment.doctorName,
            autoLoadSlots: false,
          );
          cubit.updateSelectedDate(
            date: appointment.dateTime,
            doctorId: widget.doctorId ?? appointment.doctorId,
          );
          cubit.setInitialStep(1);
          return cubit;
        }

        cubit.updateSelectedPatient(resolvedPatient);
        if (widget.doctorId != null)
          cubit.updateSelectedDoctor(widget.doctorId!, widget.doctorName ?? '');
        return cubit;
      },
      child: BlocConsumer<AppointmentScheduleCubit, AppointmentScheduleState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.pushReplacement(
              AppRouter.appointmentSuccess,
              extra: {
                'dateTime':
                    state.selectedTimeSlot?.dateTime ?? state.selectedDate,
                'doctorName': state.selectedDoctorName,
              },
            );
            // [FIX]: Ensure state is reset after success to prevent stale data on next entry
            context.read<AppointmentScheduleCubit>().reset();
          }
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            _handleBookingError(context, state, theme);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(
              title: Text(
                widget.mode == AppointmentScreenMode.reschedule
                    ? 'edit_appointment'.tr()
                    : 'schedule_appointment'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => _previousStep(context, state),
              ),
            ),
            body: Column(
              children: [
                _buildStepper(context, state),
                const SizedBox(height: 8),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.05, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                    child: SingleChildScrollView(
                      key: ValueKey(state.currentStep),
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 140),
                      child: _buildCurrentStep(state),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: _buildFloatingAction(context, state),
          );
        },
      ),
    );
  }

  Widget _buildStepper(BuildContext context, AppointmentScheduleState state) {
    final theme = Theme.of(context);
    final cubit = context.read<AppointmentScheduleCubit>();

    final steps = [
      EasyStep(
        customStep: _buildStepIcon(Icons.group_rounded, 0, state.currentStep),
        title: widget.isPatientMode ? 'doctor'.tr() : 'parties'.tr(),
      ),
      EasyStep(
        customStep: _buildStepIcon(
          Icons.calendar_month_rounded,
          1,
          state.currentStep,
        ),
        title: 'schedule'.tr(),
      ),
      EasyStep(
        customStep: _buildStepIcon(
          Icons.edit_note_rounded,
          2,
          state.currentStep,
        ),
        title: 'details'.tr(),
      ),
      EasyStep(
        customStep: _buildStepIcon(
          Icons.task_alt_rounded,
          3,
          state.currentStep,
        ),
        title: 'review'.tr(),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: EasyStepper(
        activeStep: state.currentStep,
        lineStyle: LineStyle(
          lineLength: 60,
          lineType: LineType.normal,
          defaultLineColor: theme.colorScheme.outlineVariant.withValues(
            alpha: 0.5,
          ),
          finishedLineColor: theme.colorScheme.primary,
          lineThickness: 2,
        ),
        activeStepTextColor: theme.colorScheme.primary,
        finishedStepTextColor: theme.colorScheme.primary.withValues(alpha: 0.7),
        internalPadding: 40,
        showLoadingAnimation: false,
        stepRadius: 24,
        steps: steps,
        onStepReached: (index) => cubit.goToStep(index, widget.isPatientMode),
      ),
    );
  }

  Widget _buildStepIcon(IconData icon, int step, int currentStep) {
    final theme = Theme.of(context);
    final isActive = currentStep == step;
    final isFinished = currentStep > step;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      padding: EdgeInsets.all(isActive ? 12 : 8),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : (isFinished
                  ? theme.colorScheme.primary.withValues(alpha: 0.15)
                  : theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.4,
                    )),
        shape: BoxShape.circle,
        border: isActive
            ? Border.all(color: theme.colorScheme.primaryContainer, width: 4)
            : (isFinished
                  ? Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 1.5,
                    )
                  : null),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        color: isActive
            ? Colors.white
            : (isFinished ? theme.colorScheme.primary : Colors.grey.shade500),
        size: isActive ? 22 : 18,
      ),
    );
  }

  Widget _buildCurrentStep(AppointmentScheduleState state) {
    switch (state.currentStep) {
      case 0:
        return StepParticipants(isPatientMode: widget.isPatientMode);
      case 1:
        return const StepDateTime();
      case 2:
        return StepDetails(
          reasonController: _reasonController,
          notesController: _notesController,
        );
      case 3:
        return StepReview(reason: _reasonController.text);
      default:
        return const SizedBox();
    }
  }

  Widget _buildFloatingAction(
    BuildContext context,
    AppointmentScheduleState state,
  ) {
    final theme = Theme.of(context);
    final isValid = state.canGoNext(widget.isPatientMode);
    final isLastStep =
        state.currentStep == state.totalSteps(widget.isPatientMode) - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.0),
            theme.colorScheme.surface,
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: (isValid && !state.isLoading)
              ? () => _handleNavigation(context, state)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: isValid ? 8 : 0,
            shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
          ),
          child: state.isLoading
              ? const SpinKitThreeBounce(color: Colors.white, size: 24)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLastStep ? 'confirm_appointment'.tr() : 'next'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isLastStep
                          ? Icons.check_circle_rounded
                          : Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _handleBookingError(
    BuildContext context,
    AppointmentScheduleState state,
    ThemeData theme,
  ) {
    final isConflict =
        state.errorMessage!.contains('already') ||
        state.errorMessage!.contains('active');

    AwesomeDialog(
      context: context,
      dialogType: isConflict ? DialogType.warning : DialogType.error,
      animType: AnimType.scale,
      title: isConflict ? 'booking_conflict'.tr() : 'error'.tr(),
      desc: state.errorMessage!,
      btnOkText: isConflict ? 'view_appointments'.tr() : 'try_again'.tr(),
      btnOkColor: isConflict ? Colors.orange : theme.colorScheme.error,
      btnOkOnPress: () {
        if (isConflict) context.go('/appointments');
      },
      buttonsBorderRadius: BorderRadius.circular(16),
      headerAnimationLoop: false,
    ).show();
  }

  PatientEntity _createDefaultPatient() => PatientEntity(
    id: 'p1',
    name: 'Ahmed Ali',
    email: 'ahmed@example.com',
    phone: '0123456789',
    dateOfBirth: DateTime(1990, 1, 1),
    job: 'None',
    address: 'Cairo, Egypt',
  );
}
