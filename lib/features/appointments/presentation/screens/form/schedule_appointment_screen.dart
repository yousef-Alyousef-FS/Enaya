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
  State<ScheduleAppointmentScreen> createState() => _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen> {
  late final TextEditingController _reasonController;
  late final TextEditingController _notesController;
  late final AppointmentScheduleCubit _cubit;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController(text: widget.appointment?.reason);
    _notesController = TextEditingController(text: widget.appointment?.notes);

    _cubit = getIt<AppointmentScheduleCubit>();
    _cubit.loadAvailableDoctors();

    final session = PatientSession();
    final resolvedPatient = widget.patient ?? session.patientEntity ?? _createDefaultPatient();

    if (widget.mode == AppointmentScreenMode.reschedule && widget.appointment != null) {
      final appointment = widget.appointment!;
      _cubit.updateSelectedPatient(resolvedPatient);
      _cubit.updateSelectedDoctor(
        widget.doctorId ?? appointment.doctorId,
        widget.doctorName ?? appointment.doctorName,
        autoLoadSlots: false,
      );
      _cubit.updateSelectedDate(
        date: appointment.dateTime,
        doctorId: widget.doctorId ?? appointment.doctorId,
      );
      _cubit.setInitialStep(1);
      return;
    }

    _cubit.updateSelectedPatient(resolvedPatient);
    if (widget.doctorId != null) {
      _cubit.updateSelectedDoctor(widget.doctorId!, widget.doctorName ?? '');
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleNavigation(BuildContext context, AppointmentScheduleState state) {
    final cubit = context.read<AppointmentScheduleCubit>();
    final isLastStep = state.currentStep == state.totalSteps(widget.isPatientMode) - 1;

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
    if (widget.mode == AppointmentScreenMode.reschedule && widget.appointment != null) {
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

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<AppointmentScheduleCubit, AppointmentScheduleState>(
        listenWhen: (previous, current) {
          final successChanged = previous.isSuccess != current.isSuccess && current.isSuccess;
          final errorChanged =
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null &&
              current.errorMessage!.isNotEmpty;
          return successChanged || errorChanged;
        },
        listener: (context, state) {
          if (state.isSuccess) {
            context.pushReplacement(
              AppRouter.appointmentSuccess,
              extra: {
                'dateTime': state.selectedTimeSlot?.dateTime ?? state.selectedDate,
                'doctorName': state.selectedDoctorName,
              },
            );
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
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              title: Text(
                widget.mode == AppointmentScreenMode.reschedule
                    ? 'edit_appointment'.tr()
                    : 'schedule_appointment'.tr(),
              ),
              leading: Container(
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  onPressed: () => _previousStep(context, state),
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  _buildStepper(context, state),
                  const SizedBox(height: 8),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 240),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.04, 0.0),
                              end: Offset.zero,
                            ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        key: ValueKey(state.currentStep),
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 136),
                        child: _buildCurrentStep(state),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
        customStep: AppointmentStepIcon(
          icon: Icons.group_rounded,
          step: 0,
          currentStep: state.currentStep,
        ),
        title: widget.isPatientMode ? 'doctor'.tr() : 'parties'.tr(),
      ),
      EasyStep(
        customStep: AppointmentStepIcon(
          icon: Icons.calendar_month_rounded,
          step: 1,
          currentStep: state.currentStep,
        ),
        title: 'schedule'.tr(),
      ),
      EasyStep(
        customStep: AppointmentStepIcon(
          icon: Icons.edit_note_rounded,
          step: 2,
          currentStep: state.currentStep,
        ),
        title: 'details'.tr(),
      ),
      EasyStep(
        customStep: AppointmentStepIcon(
          icon: Icons.task_alt_rounded,
          step: 3,
          currentStep: state.currentStep,
        ),
        title: 'review'.tr(),
      ),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: EasyStepper(
        activeStep: state.currentStep,
        enableStepTapping: false,
        lineStyle: LineStyle(
          lineLength: 52,
          lineType: LineType.normal,
          defaultLineColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
          finishedLineColor: theme.colorScheme.primary,
          lineThickness: 2,
        ),
        activeStepTextColor: theme.colorScheme.primary,
        finishedStepTextColor: theme.colorScheme.primary.withValues(alpha: 0.8),
        internalPadding: 18,
        showLoadingAnimation: false,
        stepRadius: 22,
        steps: steps,
        onStepReached: (index) {
          if (index != state.currentStep) {
            cubit.goToStep(index, widget.isPatientMode);
          }
        },
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
        return StepDetails(reasonController: _reasonController, notesController: _notesController);
      case 3:
        return StepReview(reason: _reasonController.text);
      default:
        return const SizedBox();
    }
  }

  Widget _buildFloatingAction(BuildContext context, AppointmentScheduleState state) {
    return AppointmentBookingFooter(
      isLoading: state.isLoading,
      isValid: state.canGoNext(widget.isPatientMode),
      isLastStep: state.currentStep == state.totalSteps(widget.isPatientMode) - 1,
      onPressed: () => _handleNavigation(context, state),
    );
  }

  void _handleBookingError(BuildContext context, AppointmentScheduleState state, ThemeData theme) {
    final isConflict =
        state.errorMessage!.contains('already') || state.errorMessage!.contains('active');

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

class AppointmentStepIcon extends StatelessWidget {
  const AppointmentStepIcon({
    super.key,
    required this.icon,
    required this.step,
    required this.currentStep,
  });

  final IconData icon;
  final int step;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = currentStep == step;
    final isFinished = currentStep > step;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(isActive ? 11 : 8),
      transform: Matrix4.translationValues(0, isActive ? -2 : 0, 0),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : (isFinished
                  ? theme.colorScheme.primary.withValues(alpha: 0.12)
                  : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55)),
        shape: BoxShape.circle,
        border: isActive
            ? Border.all(color: theme.colorScheme.primaryContainer, width: 3)
            : (isFinished
                  ? Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2), width: 1.2)
                  : Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                      width: 1,
                    )),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        color: isActive
            ? Colors.white
            : (isFinished ? theme.colorScheme.primary : Colors.grey.shade500),
        size: isActive ? 21 : 18,
      ),
    );
  }
}

class AppointmentBookingFooter extends StatelessWidget {
  const AppointmentBookingFooter({
    super.key,
    required this.isLoading,
    required this.isValid,
    required this.isLastStep,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isValid;
  final bool isLastStep;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
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
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: 62,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: isValid && !isLoading
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: (isValid && !isLoading) ? onPressed : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            elevation: isValid ? 0 : 0,
            shadowColor: Colors.transparent,
          ),
          child: isLoading
              ? const SpinKitThreeBounce(color: Colors.white, size: 24)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLastStep ? 'confirm_appointment'.tr() : 'next'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isLastStep ? Icons.check_circle_rounded : Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
