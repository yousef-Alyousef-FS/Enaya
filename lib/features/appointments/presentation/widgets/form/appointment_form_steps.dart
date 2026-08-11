import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/routing/app_router.dart';
import '../../../../../core/widgets/cards/app_base_card.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../patients/domain/entities/patient_entity.dart';
import '../../cubit/appointments_cubit_imports.dart';
import '../receptionist/doctor_selector_button.dart';
import '../shared/calendar_horizontal.dart';
import '../shared/patient_search_field.dart';
import '../shared/time_slot_picker.dart';

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
                  ? const _DoctorSkeletonLoading()
                  : DoctorSelectorButton(
                      doctors: state.availableDoctors
                          .map((d) => DoctorOption(id: d.id, name: d.name, specialty: d.specialty))
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
            if (!isPatientMode) ...[
              _buildSectionLabel(context, 'patient_and_doctor_info'.tr()),
              const SizedBox(height: 16),
            ],
            _buildCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isPatientMode) ...[
                    _buildInputLabel(context, 'select_patient'.tr(), Icons.person_search_rounded),
                    const SizedBox(height: 10),
                    patientWidget,
                    const SizedBox(height: 24),
                  ],
                  _buildInputLabel(context, 'select_doctor'.tr(), Icons.medical_services_rounded),
                  const SizedBox(height: 10),
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

Widget _buildInputLabel(BuildContext context, String text, IconData icon) {
  final theme = Theme.of(context);
  return Row(
    children: [
      Icon(icon, size: 16, color: theme.colorScheme.primary),
      const SizedBox(width: 8),
      Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          letterSpacing: 0.2,
        ),
      ),
    ],
  );
}

class _DoctorSkeletonLoading extends StatelessWidget {
  const _DoctorSkeletonLoading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
      period: const Duration(milliseconds: 1500),
      child: Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
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
                  if (doctorId != null) ...[
                    if (state.isLoading && state.availableDays.isEmpty)
                      const _AvailableDaysSkeletonLoading()
                    else if (state.availableDays.isEmpty)
                      _buildNoAvailabilityState(context)
                    else ...[
                      _buildSelectedDateHeader(context, state.selectedDate),
                      const SizedBox(height: 16),
                      CalendarHorizontal(
                        selectedDate: state.selectedDate,
                        startDate: DateTime.now(),
                        daysCount: 30,
                        onDateSelected: (date) => context
                            .read<AppointmentScheduleCubit>()
                            .updateSelectedDate(date: date, doctorId: doctorId),
                      ),
                    ],
                  ] else
                    _buildMissingDoctorState(context),
                  const Divider(height: 40),
                  _buildInputLabel(context, 'select_time'.tr(), Icons.access_time_filled_rounded),
                  const SizedBox(height: 16),
                  if (state.isLoading)
                    const _SlotsSkeletonLoading()
                  else if (availableSlots.isEmpty)
                    _buildNoSlotsState(context)
                  else
                    TimeSlotPicker(
                      slots: availableSlots,
                      selectedSlot: state.selectedTimeSlot,
                      onSlotSelected: context
                          .read<AppointmentScheduleCubit>()
                          .updateSelectedTimeSlot,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectedDateHeader(BuildContext context, DateTime date) {
    final theme = Theme.of(context);
    final locale = context.locale.toString();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.event_available_rounded, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            DateFormat('EEEE, dd MMMM', locale).format(date),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissingDoctorState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          style: BorderStyle.none,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.person_off_rounded,
            size: 48,
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'select_doctor'.tr(),
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAvailabilityState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Icon(Icons.event_busy_rounded, size: 52, color: Colors.red.withValues(alpha: 0.55)),
          const SizedBox(height: 16),
          Text(
            'doctor_no_available_slots'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red.withValues(alpha: 0.72),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => context.go(AppRouter.patientHome),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.arrow_back_rounded),
              label: Text('back_to_dashboard'.tr()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSlotsState(BuildContext context) {
    Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(Icons.event_busy_rounded, size: 48, color: Colors.red.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'no_slots_available'.tr(),
            style: TextStyle(
              color: Colors.red.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailableDaysSkeletonLoading extends StatelessWidget {
  const _AvailableDaysSkeletonLoading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
        period: const Duration(milliseconds: 1500),
        child: Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 4 ? 10 : 0),
                child: Container(
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _SlotsSkeletonLoading extends StatelessWidget {
  const _SlotsSkeletonLoading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
        period: const Duration(milliseconds: 1500),
        child: Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 4 ? 10 : 0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Step 3: Additional details
class StepDetails extends StatelessWidget {
  final TextEditingController reasonController;
  final TextEditingController notesController;

  const StepDetails({super.key, required this.reasonController, required this.notesController});

  static final List<String> _quickReasons = [
    'general_checkup',
    'consultation',
    'follow_up',
    'emergency',
    'prescription_renewal',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'reason_for_visit'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickReasons.map((reason) {
                      final label = reason.tr();
                      final isSelected = reasonController.text == label;
                      return ChoiceChip(
                        label: Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : theme.colorScheme.primary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) reasonController.text = label;
                        },
                        selectedColor: theme.colorScheme.primary,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
                        ),
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: reasonController,
                    label: 'other_reason'.tr(),
                    hintText: 'reason_hint'.tr(),
                    errorText: state.fieldErrors?['reason'],
                    prefixIcon: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                  const Divider(height: 40),
                  Text(
                    'additional_notes'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: notesController,
                    label: 'notes'.tr(),
                    hintText: 'notes_hint'.tr(),
                    errorText: state.fieldErrors?['notes'],
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    minLines: 3,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Step 4: Final Review Summary.
class StepReview extends StatelessWidget {
  final String reason;

  const StepReview({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentScheduleCubit, AppointmentScheduleState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final locale = context.locale.toString();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel(context, 'review_your_booking'.tr()),
            const SizedBox(height: 16),
            _buildMedicalPass(context, state, theme, locale),
            const SizedBox(height: 24),
            _buildDisclaimer(theme),
          ],
        );
      },
    );
  }

  Widget _buildMedicalPass(
    BuildContext context,
    AppointmentScheduleState state,
    ThemeData theme,
    String locale,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Part (Doctor Info)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.selectedDoctorName ?? '',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'medical_specialist'.tr(),
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Dashed Divider
          const _DashedLine(),

          // Bottom Part (Appointment Details)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildPassRow(
                  Icons.calendar_today_rounded,
                  'date'.tr(),
                  state.selectedTimeSlot != null
                      ? DateFormat(
                          'EEEE, dd MMMM yyyy',
                          locale,
                        ).format(state.selectedTimeSlot!.dateTime)
                      : DateFormat('EEEE, dd MMMM yyyy', locale).format(state.selectedDate),
                  theme,
                ),
                const SizedBox(height: 20),
                _buildPassRow(
                  Icons.access_time_filled_rounded,
                  'time'.tr(),
                  state.selectedTimeSlot != null
                      ? DateFormat.jm(locale).format(state.selectedTimeSlot!.dateTime)
                      : '--:--',
                  theme,
                ),
                const SizedBox(height: 20),
                _buildPassRow(
                  Icons.person_pin_rounded,
                  'patient'.tr(),
                  state.selectedPatient?.name ?? '',
                  theme,
                ),
                const SizedBox(height: 20),
                _buildPassRow(
                  Icons.medical_information_rounded,
                  'reason'.tr(),
                  reason.isNotEmpty ? reason : 'general_checkup'.tr(),
                  theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassRow(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildDisclaimer(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'booking_disclaimer'.tr(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 12, child: _HalfCircle(isLeft: true)),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  (constraints.constrainWidth() / 10).floor(),
                  (index) => SizedBox(
                    width: 5,
                    height: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12, child: _HalfCircle(isLeft: false)),
      ],
    );
  }
}

class _HalfCircle extends StatelessWidget {
  final bool isLeft;
  const _HalfCircle({required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 10,
      child: CustomPaint(
        painter: _HalfCirclePainter(isLeft: isLeft, color: Colors.grey.withValues(alpha: 0.1)),
      ),
    );
  }
}

class _HalfCirclePainter extends CustomPainter {
  final bool isLeft;
  final Color color;
  _HalfCirclePainter({required this.isLeft, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    if (isLeft) {
      canvas.drawArc(Rect.fromLTWH(0, 0, size.width * 2, size.height), 1.5, 3, true, paint);
    } else {
      canvas.drawArc(
        Rect.fromLTWH(-size.width, 0, size.width * 2, size.height),
        -1.5,
        3,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: theme.colorScheme.primary.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        if (onEdit != null)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.edit_rounded, size: 18, color: theme.colorScheme.primary),
              ),
            ),
          ),
      ],
    ),
  );
}
