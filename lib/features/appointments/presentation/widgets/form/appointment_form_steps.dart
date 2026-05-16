import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/cards/app_base_card.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../patients/domain/entities/patient_entity.dart';
import '../../cubit/appointments_cubit_imports.dart';
import '../receptionist/doctor_selector_button.dart';
import '../shared/calendar_horizontal.dart';
import '../shared/time_slot_picker.dart';
import '../shared/patient_search_field.dart';

/// Step 1: Selecting the Patient and the Doctor.
class StepParticipants extends StatelessWidget {
  final bool isPatientMode;
  final PatientEntity? initialPatient;

  const StepParticipants({super.key, required this.isPatientMode, this.initialPatient});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentScheduleCubit, AppointmentScheduleState>(
      builder: (context, state) {
        final patientWidget = isPatientMode
            ? const SizedBox.shrink()
            : PatientSearchField(
                initialPatient: initialPatient,
                showLabel: false,
                height: 56,
                onPatientSelected: (p) =>
                    context.read<AppointmentScheduleCubit>().updateSelectedPatient(p),
                onClearPatient: () =>
                    context.read<AppointmentScheduleCubit>().clearSelectedPatient(),
              );

        final doctorInputWidget = state.selectedDoctorId == null
            ? state.isDoctorsLoading
                  ? const LinearProgressIndicator()
                  : DoctorSelectorButton(
                      doctors: state.availableDoctors
                          .map((d) => DoctorOption(id: d.id, name: d.name))
                          .toList(),
                      selectedDoctorName: state.selectedDoctorName,
                      onClearSelection: () =>
                          context.read<AppointmentScheduleCubit>().clearSelectedDoctor(),
                      onSelected: (d) => context
                          .read<AppointmentScheduleCubit>()
                          .updateSelectedDoctor(d.id, d.name),
                    )
            : _buildSelectedInfoRow(
                context,
                Icons.medical_services_rounded,
                'doctor'.tr(),
                state.selectedDoctorName ?? '',
                onEdit: () => context.read<AppointmentScheduleCubit>().clearSelectedDoctor(),
              );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel(context, 'patient_and_doctor_info'.tr()),
            const SizedBox(height: 12),
            _buildCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isPatientMode) ...[
                    Text(
                      'select_patient'.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    patientWidget,
                    const SizedBox(height: 14),
                  ],
                  Text(
                    'select_doctor'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(width: double.infinity, child: doctorInputWidget),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class StepDateTime extends StatelessWidget {
  const StepDateTime({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentScheduleCubit, AppointmentScheduleState>(
      builder: (context, state) {
        final availableSlots = state.availableSlots.where((s) => s.isAvailable).toList();
        final doctorId = state.selectedDoctorId;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel(context, 'select_schedule'.tr()),
            const SizedBox(height: 16),
            _buildCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (doctorId != null)
                    CalendarHorizontal(
                      selectedDate: state.selectedDate,
                      startDate: DateTime.now().add(const Duration(days: 1)),
                      daysCount: 30,
                      onDateSelected: (date) => context
                          .read<AppointmentScheduleCubit>()
                          .updateSelectedDate(date: date, doctorId: doctorId),
                    )
                  else
                    _buildMissingDoctorState(context),
                  const Divider(height: 40),
                  Text(
                    'select_time'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (availableSlots.isEmpty)
                    _buildNoSlotsState(context)
                  else
                    TimeSlotPicker(
                      slots: availableSlots,
                      selectedSlot: state.selectedTimeSlot,
                      onSlotSelected: context
                          .read<AppointmentScheduleCubit>()
                          .updateSelectedTimeSlot,
                      showStatusLabels: false,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMissingDoctorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(Icons.person_off_rounded, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              'select_doctor'.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSlotsState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(Icons.event_busy_rounded, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              'no_slots_available'.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

/// Step 3: Additional details and final confirmation summary.
class StepDetails extends StatelessWidget {
  final TextEditingController reasonController;
  final TextEditingController notesController;

  const StepDetails({super.key, required this.reasonController, required this.notesController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentScheduleCubit, AppointmentScheduleState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel(context, 'visit_details'.tr()),
            const SizedBox(height: 16),
            _buildCard(
              context,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: reasonController,
                    label: 'reason_for_visit'.tr(),
                    hintText: 'reason_hint'.tr(),
                    prefixIcon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                    minLines: 1,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: notesController,
                    label: 'additional_notes'.tr(),
                    hintText: 'notes_hint'.tr(),
                    prefixIcon: const Icon(Icons.description_outlined, size: 20),
                    minLines: 1,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionLabel(context, 'appointment_summary'.tr()),
            const SizedBox(height: 16),
            _buildCard(
              context,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSummaryRow(
                    context,
                    Icons.person_outline,
                    'patient'.tr(),
                    state.selectedPatient?.name ?? '',
                  ),
                  const Divider(height: 20),
                  _buildSummaryRow(
                    context,
                    Icons.medical_services_outlined,
                    'doctor'.tr(),
                    state.selectedDoctorName ?? '',
                  ),
                  const Divider(height: 20),
                  _buildSummaryRow(
                    context,
                    Icons.event_available,
                    'date'.tr(),
                    state.selectedTimeSlot != null
                        ? DateFormat(
                            'EEEE, MMM d @ HH:mm',
                            'en_US',
                          ).format(state.selectedTimeSlot!.dateTime)
                        : '',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 11),
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Shared Helper UI Widgets ---

Widget _buildSectionLabel(BuildContext context, String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    ),
  );
}

Widget _buildCard(BuildContext context, {required Widget child}) {
  final theme = Theme.of(context);
  return AppBaseCard(
    padding: const EdgeInsets.all(16),
    borderRadius: 20,
    elevation: 1,
    backgroundColor: theme.colorScheme.surfaceContainerLow,
    borderSide: BorderSide.none,
    child: child,
  );
}

Widget _buildSelectedInfoRow(
  BuildContext context,
  IconData icon,
  String label,
  String value, {
  VoidCallback? onEdit,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withAlpha(isDark ? 40 : 15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: theme.colorScheme.primary),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 11)),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      if (onEdit != null)
        IconButton(
          icon: Icon(Icons.edit_outlined, size: 20, color: theme.colorScheme.primary),
          onPressed: onEdit,
        ),
    ],
  );
}
