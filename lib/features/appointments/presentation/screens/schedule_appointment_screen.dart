import 'package:easy_localization/easy_localization.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/patient_session.dart';
import '../../domain/entities/appointment_entity.dart';
import '../cubit/appointments_cubit_imports.dart';
import '../widgets/form/appointment_form_steps.dart';
import '../widgets/shared/appointments_feedback_state.dart';
import '../../../patients/domain/entities/patient_entity.dart';

enum AppointmentScreenMode { create, reschedule }

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
  int _activeStep = 0;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    _notesController = TextEditingController();

    // If in reschedule mode, we might want to start at step 1
    if (widget.mode == AppointmentScreenMode.reschedule) {
      _activeStep = 1;
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _nextStep(BuildContext context, AppointmentScheduleState state) {
    if (_activeStep < 2) {
      setState(() => _activeStep++);
    } else {
      _confirmAppointment(context);
    }
  }

  void _previousStep() {
    if (_activeStep > 0) {
      setState(() => _activeStep--);
    } else {
      context.pop();
    }
  }

  bool _isStepValid(int step, AppointmentScheduleState state) {
    switch (step) {
      case 0:
        return state.selectedPatient != null && state.selectedDoctorId != null;
      case 1:
        return state.selectedTimeSlot != null;
      case 2:
        return !state.isLoading;
      default:
        return false;
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

    return BlocProvider(
      create: (context) {
        final cubit = getIt<AppointmentScheduleCubit>();
        cubit.loadAvailableDoctors();
        final resolvedPatient =
            widget.patient ?? (widget.isPatientMode ? PatientSession().patientEntity : null);

        if (widget.mode == AppointmentScreenMode.reschedule && widget.appointment != null) {
          final appointment = widget.appointment!;
          final reschedulePatient = resolvedPatient ?? _patientFromAppointment(appointment);

          cubit.updateSelectedPatient(reschedulePatient);
          cubit.updateSelectedDoctor(
            widget.doctorId ?? appointment.doctorId,
            widget.doctorName ?? appointment.doctorName,
            autoLoadSlots: false,
          );
          cubit.updateSelectedDate(
            date: appointment.dateTime,
            doctorId: widget.doctorId ?? appointment.doctorId,
          );
          return cubit;
        }

        if (resolvedPatient != null) {
          cubit.updateSelectedPatient(resolvedPatient);
        }
        if (widget.doctorId != null) {
          cubit.updateSelectedDoctor(widget.doctorId!, widget.doctorName ?? '');
        }
        return cubit;
      },
      child: BlocConsumer<AppointmentScheduleCubit, AppointmentScheduleState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.pushReplacement('/appointments/success');
          }
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
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
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: _previousStep,
              ),
            ),
            body: Column(
              children: [
                _buildStepper(context),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: theme.colorScheme.outlineVariant.withAlpha(60),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                          child: child,
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      key: ValueKey(_activeStep),
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 120),
                      physics: const BouncingScrollPhysics(),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildCurrentStep(state),
                              if (state.errorMessage != null) _buildErrorWidget(context, state),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _buildFloatingAction(context, state),
          );
        },
      ),
    );
  }

  Widget _buildStepper(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: EasyStepper(
        activeStep: _activeStep,
        lineStyle: LineStyle(
          lineLength: 56,
          lineType: LineType.normal,
          defaultLineColor: theme.colorScheme.outlineVariant.withAlpha(100),
          finishedLineColor: theme.colorScheme.primary,
        ),
        activeStepTextColor: theme.colorScheme.primary,
        finishedStepTextColor: theme.colorScheme.primary,
        unreachedStepTextColor: theme.colorScheme.onSurfaceVariant,
        internalPadding: 8,
        showLoadingAnimation: false,
        stepRadius: 20,
        showStepBorder: false,
        enableStepTapping: false,
        steps: [
          EasyStep(
            customStep: _buildStepIcon(Icons.person_outline_rounded, 0),
            title: 'patient_and_doctor_info'.tr(),
          ),
          EasyStep(
            customStep: _buildStepIcon(Icons.calendar_month_rounded, 1),
            title: 'select_schedule'.tr(),
          ),
          EasyStep(
            customStep: _buildStepIcon(Icons.assignment_turned_in_rounded, 2),
            title: 'visit_details'.tr(),
          ),
        ],
        onStepReached: (index) => setState(() => _activeStep = index),
      ),
    );
  }

  Widget _buildStepIcon(IconData icon, int step) {
    final theme = Theme.of(context);
    final isFinished = _activeStep > step;
    final isActive = _activeStep == step;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : (isFinished
                  ? theme.colorScheme.primary.withAlpha(30)
                  : theme.colorScheme.surfaceContainerHighest),
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withAlpha(60),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        size: 20,
        color: isActive
            ? theme.colorScheme.onPrimary
            : (isFinished ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildCurrentStep(AppointmentScheduleState state) {
    switch (_activeStep) {
      case 0:
        return StepParticipants(
          isPatientMode: widget.isPatientMode,
          initialPatient: widget.patient,
        );
      case 1:
        return const StepDateTime();
      case 2:
        return StepDetails(reasonController: _reasonController, notesController: _notesController);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFloatingAction(BuildContext context, AppointmentScheduleState state) {
    final theme = Theme.of(context);
    final isValid = _isStepValid(_activeStep, state);
    final isLastStep = _activeStep == 2;

    return AnimatedScale(
      scale: isValid || state.isLoading ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 200),
      child: AnimatedOpacity(
        opacity: isValid || state.isLoading ? 1.0 : 0.6,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 280,
          height: 56,
          margin: const EdgeInsets.only(bottom: 8),
          child: FloatingActionButton.extended(
            onPressed: isValid ? () => _nextStep(context, state) : null,
            backgroundColor: isValid ? theme.colorScheme.primary : theme.disabledColor,
            elevation: isValid ? 6 : 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            label: state.isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                  )
                : Text(
                    isLastStep
                        ? (widget.mode == AppointmentScreenMode.reschedule
                              ? 'save_changes'.tr()
                              : 'confirm_appointment'.tr())
                        : 'next'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, AppointmentScheduleState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: AppointmentsInlineError(
        message: state.errorMessage,
        onRetry: () {
          if (state.selectedDoctorId != null) {
            context.read<AppointmentScheduleCubit>().updateSelectedDate(
              date: state.selectedDate,
              doctorId: state.selectedDoctorId!,
            );
          }
        },
      ),
    );
  }

  PatientEntity _patientFromAppointment(AppointmentEntity appointment) {
    return PatientEntity(
      id: appointment.patientId,
      name: appointment.patientName,
      email: '',
      phone: appointment.patientPhone ?? '',
      dateOfBirth: DateTime(1970),
      medicalHistory: '',
      address: '',
    );
  }
}
