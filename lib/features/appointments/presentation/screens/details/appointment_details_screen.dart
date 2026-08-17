import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../data/models/appointments_overview_view_mode.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../cubit/details/appointment_details_cubit.dart';
import '../../cubit/details/appointment_details_state.dart';
import '../form/schedule_appointment_screen.dart';
import 'appointment_status_dialog.dart';
import 'cancellation_reason_dialog.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final AppointmentEntity? appointment;
  final String? appointmentId;
  final AppointmentsOverviewMode role;
  final VoidCallback? onDataChanged;

  const AppointmentDetailsScreen({
    super.key,
    this.appointment,
    this.appointmentId,
    this.role = AppointmentsOverviewMode.generic,
    this.onDataChanged,
  });

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // سيتم التحميل في الـ bloc provider عند إنشائه
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<AppointmentDetailsCubit>();
        if (widget.appointment != null) {
          cubit.setAppointment(widget.appointment!);
        } else if (widget.appointmentId != null) {
          cubit.loadAppointmentById(widget.appointmentId!);
        }
        return cubit;
      },
      child: BlocConsumer<AppointmentDetailsCubit, AppointmentDetailsState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          // حالة التحميل
          if (state.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final appointment = state.appointment ?? widget.appointment;

          if (appointment == null) {
            return Scaffold(
              appBar: AppBar(title: Text('appointment_details'.tr())),
              body: Center(
                child: Text(
                  'appointment_not_found'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            );
          }

          final theme = Theme.of(context);
          final locale = context.locale.toString();

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'appointment_details'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      _buildHeader(theme, appointment),
                      const SizedBox(height: 32),
                      _buildBodyContent(theme, appointment, locale),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: _buildBottomActions(
              context,
              state,
              appointment,
            ),
          );
        },
      ),
    );
  }

  // باقي الدوال كما هي مع بعض التعديلات في استخدام appointment

  Widget _buildHeader(ThemeData theme, AppointmentEntity appointment) {
    final isPatient = widget.role == AppointmentsOverviewMode.patient;
    final name = isPatient ? appointment.doctorName : appointment.patientName;
    final subtitle = isPatient ? 'medical_specialist'.tr() : 'patient'.tr();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Icon(
              Icons.medical_services_rounded,
              size: 150,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person_rounded,
                          color: theme.colorScheme.primary,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildWhiteStatusChip(appointment.status),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 40, color: Colors.white24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _headerInfoItem(
                      Icons.calendar_today_rounded,
                      'date'.tr(),
                      DateFormat('dd MMM').format(appointment.dateTime),
                    ),
                    _headerInfoItem(
                      Icons.access_time_rounded,
                      'time'.tr(),
                      DateFormat.jm().format(appointment.dateTime),
                    ),
                    _headerInfoItem(
                      Icons.confirmation_number_rounded,
                      'queue'.tr(),
                      appointment.queueNumber?.toString() ?? '--',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 20),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildWhiteStatusChip(AppointmentStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name.tr().toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildBodyContent(
    ThemeData theme,
    AppointmentEntity appointment,
    String locale,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          theme,
          'preparation'.tr(),
          Icons.lightbulb_outline_rounded,
        ),
        const SizedBox(height: 16),
        _buildPreparationCard(theme),
        const SizedBox(height: 32),
        _buildSectionHeader(
          theme,
          'visit_details'.tr(),
          Icons.info_outline_rounded,
        ),
        const SizedBox(height: 16),
        _buildDetailCard(
          theme,
          title: 'reason_for_visit'.tr(),
          content: appointment.reason ?? 'no_reason_provided'.tr(),
          icon: Icons.notes_rounded,
        ),
        const SizedBox(height: 16),
        _buildDetailCard(
          theme,
          title: 'additional_notes'.tr(),
          content: appointment.notes ?? 'no_notes_available'.tr(),
          icon: Icons.description_outlined,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildPreparationCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          _preparationRow(
            Icons.description_outlined,
            'bring_previous_reports'.tr(),
            theme,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              indent: 40,
              endIndent: 20,
              color: Colors.black12,
            ),
          ),
          _preparationRow(
            Icons.history_toggle_off_rounded,
            'arrive_15_mins_early'.tr(),
            theme,
          ),
        ],
      ),
    );
  }

  Widget _preparationRow(IconData icon, String text, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    ThemeData theme, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              height: 1.5,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildBottomActions(
    BuildContext context,
    AppointmentDetailsState state,
    AppointmentEntity appointment,
  ) {
    if (appointment.status.isReadOnly ||
        appointment.status.allowedTransitions.isEmpty) {
      return null;
    }

    final canReschedule =
        appointment.status.canTransitionTo(AppointmentStatus.scheduled) ||
        appointment.status == AppointmentStatus.scheduled;
    final canCancel = appointment.status.canTransitionTo(
      AppointmentStatus.cancelled,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Row(
        children: [
          if (canReschedule)
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleSecondaryAction(context, appointment),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.role == AppointmentsOverviewMode.patient
                      ? 'reschedule'.tr()
                      : 'change_status'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (canReschedule && canCancel) const SizedBox(width: 16),
          if (canCancel) _cancelButton(context),
        ],
      ),
    );
  }

  Widget _cancelButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: IconButton(
        onPressed: () => _showCancelConfirmation(context),
        icon: const Icon(Icons.close_rounded, color: Colors.red),
        padding: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleStateChanges(
    BuildContext context,
    AppointmentDetailsState state,
  ) {
    if (state.isCancelled || state.isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('success'.tr()), backgroundColor: Colors.green),
      );
      widget.onDataChanged?.call();
      context.pop(true);
    }
    if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleSecondaryAction(
    BuildContext context,
    AppointmentEntity appointment,
  ) {
    if (widget.role == AppointmentsOverviewMode.patient) {
      _rescheduleAppointment(context, appointment);
    } else {
      _showStatusDialog(context, appointment);
    }
  }

  void _showStatusDialog(BuildContext context, AppointmentEntity appointment) {
    showAppointmentStatusDialog(
      context: context,
      currentStatus: appointment.status, // استخدام appointment الحالي
      onStatusSelected: (status) =>
          context.read<AppointmentDetailsCubit>().updateStatus(status),
    );
  }

  void _showCancelConfirmation(BuildContext context) async {
    final appointment = context
        .read<AppointmentDetailsCubit>()
        .state
        .appointment;
    if (appointment == null) return;

    final String? reason = await showCancellationReasonDialog(context);
    if (reason != null && context.mounted) {
      final String cancelledBy = widget.role == AppointmentsOverviewMode.patient
          ? 'patient'
          : 'staff';
      context.read<AppointmentDetailsCubit>().cancelAppointment(
        cancelledBy: cancelledBy,
        reason: reason,
      );
    }
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
    if (result == true) widget.onDataChanged?.call();
  }
}
