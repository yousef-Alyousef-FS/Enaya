// ignore_for_file:use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/features/appointments/presentation/cubit/details/appointment_details_cubit.dart';
import 'package:enaya/features/appointments/presentation/cubit/details/appointment_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cards/app_base_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/routing/app_router.dart';
import '../../data/models/appointments_overview_view_mode.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_status.dart';
import 'schedule_appointment_screen.dart';
import '../widgets/shared/appointment_status_chip.dart';
import 'appointment_status_dialog.dart';
import 'cancellation_reason_dialog.dart';

/// Refined Appointment Details screen with structured sections and clear visual hierarchy.
class AppointmentDetailsScreen extends StatefulWidget {
  final AppointmentEntity appointment;
  final AppointmentsOverviewMode role;
  final VoidCallback? onDataChanged;

  const AppointmentDetailsScreen({
    super.key,
    required this.appointment,
    this.role = AppointmentsOverviewMode.generic,
    this.onDataChanged,
  });

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (_) {
        final cubit = getIt<AppointmentDetailsCubit>();
        cubit.setAppointment(widget.appointment);
        return cubit;
      },
      child: BlocListener<AppointmentDetailsCubit, AppointmentDetailsState>(
        listener: (context, state) {
          if (state.isCancelled) {
            _showSuccess(context, 'appointment_cancelled'.tr());
            widget.onDataChanged?.call();
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) context.pop(true);
            });
          }

          if (state.isRescheduled) {
            _showSuccess(context, 'appointment_rescheduled'.tr());
            widget.onDataChanged?.call();
          }

          if (state.isDeleted) {
            _showSuccess(context, 'appointment_deleted'.tr());
            widget.onDataChanged?.call();
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) context.pop(true);
            });
          }

          if (state.errorMessage != null) {
            _showError(context, state.errorMessage!);
          }
        },
        child: BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
          builder: (context, state) {
            final appointment = state.appointment ?? widget.appointment;

            return Scaffold(
              backgroundColor: isDark
                  ? AppColors.darkBackground
                  : AppColors.background,
              appBar: AppBar(
                title: Text('appointment_details'.tr()),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
              ),
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeaderCard(context, appointment),
                              const SizedBox(height: 24),

                              if (_isFinalStatus(appointment)) ...[
                                _buildStatusBanner(context, appointment),
                                const SizedBox(height: 24),
                              ],

                              _buildInfoSection(context, appointment),
                              const SizedBox(height: 24),

                              _buildClinicalSection(context, appointment),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomActions(context, state),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, AppointmentEntity appointment) {
    final theme = Theme.of(context);
    return AppBaseCard(
      padding: EdgeInsets.zero,
      borderRadius: 24,
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withAlpha(200),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.calendar_month,
                size: 140,
                color: Colors.white.withAlpha(20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRoleBadge(),
                      AppointmentStatusChip(status: appointment.status),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    appointment.patientName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.medical_services_outlined,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        appointment.doctorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withAlpha(230),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_roleIcon(widget.role), color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            _roleLabel(widget.role),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    AppointmentEntity appointment,
  ) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(title: 'appointment_info'.tr()),
            const SizedBox(height: 12),
            if (isCompact) ...[
              _buildInfoCard(
                icon: Icons.event_available,
                label: 'date'.tr(),
                value: DateFormat(
                  'EEEE, MMM d',
                  context.locale.toString(),
                ).format(appointment.dateTime),
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.access_time,
                label: 'time'.tr(),
                value: DateFormat.jm(
                  context.locale.toString(),
                ).format(appointment.dateTime),
                color: AppColors.accentMint,
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.event_available,
                      label: 'date'.tr(),
                      value: DateFormat(
                        'EEEE, MMM d',
                        context.locale.toString(),
                      ).format(appointment.dateTime),
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.access_time,
                      label: 'time'.tr(),
                      value: DateFormat.jm(
                        context.locale.toString(),
                      ).format(appointment.dateTime),
                      color: AppColors.accentMint,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.tag,
              label: 'appointment_id'.tr(),
              value: '#${appointment.id}',
              color: theme.brightness == Brightness.dark
                  ? AppColors.darkTextSecondary
                  : AppColors.gray500,
            ),
          ],
        );
      },
    );
  }

  Widget _buildClinicalSection(
    BuildContext context,
    AppointmentEntity appointment,
  ) {
    Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: 'clinical_details'.tr()),
        const SizedBox(height: 12),
        _buildDataBlock(
          context,
          icon: Icons.note_alt_outlined,
          label: 'reason_for_visit'.tr(),
          content: appointment.reason?.isNotEmpty == true
              ? appointment.reason!
              : 'no_reason_provided'.tr(),
        ),
        const SizedBox(height: 16),
        _buildDataBlock(
          context,
          icon: Icons.description_outlined,
          label: 'notes'.tr(),
          content: appointment.notes?.isNotEmpty == true
              ? appointment.notes!
              : 'no_notes_available'.tr(),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return AppBaseCard(
          padding: const EdgeInsets.all(16),
          borderRadius: 16,
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataBlock(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String content,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    AppointmentDetailsState state,
  ) {
    final appointment = state.appointment ?? widget.appointment;
    final isLoading = state.isLoading;
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 520;

    if (appointment.status.isReadOnly) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: _buildReadOnlyActionsHint(context, appointment),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildActionControls(
                context,
                appointment,
                isLoading,
                compact: true,
              ),
            )
          : Row(
              children: _buildActionControls(
                context,
                appointment,
                isLoading,
                compact: false,
              ),
            ),
    );
  }

  List<Widget> _buildActionControls(
    BuildContext context,
    AppointmentEntity appointment,
    bool isLoading, {
    required bool compact,
  }) {
    final controls = <Widget>[];

    if (widget.role == AppointmentsOverviewMode.receptionist) {
      controls.add(
        Expanded(
          child: _buildPrimaryAction(
            label: 'change_status'.tr(),
            icon: Icons.edit_calendar,
            onPressed: isLoading ? null : () => _showStatusDialog(context),
          ),
        ),
      );
      controls.add(const SizedBox(width: 12));
      controls.add(
        _buildCircleAction(
          icon: Icons.cancel_outlined,
          color: AppColors.medicalRed,
          onPressed: isLoading ? null : () => _showCancelConfirmation(context),
        ),
      );
    } else if (widget.role == AppointmentsOverviewMode.doctor) {
      controls.add(
        Expanded(
          child: _buildDoctorPrimaryAction(context, appointment, isLoading),
        ),
      );
      controls.add(const SizedBox(width: 12));
      controls.add(
        _buildCircleAction(
          icon: Icons.more_vert,
          color: AppColors.gray600,
          onPressed: () => _showDoctorMoreActions(context, appointment),
        ),
      );
    } else if (widget.role == AppointmentsOverviewMode.patient) {
      controls.add(
        Expanded(
          child: _buildPrimaryAction(
            label: 'reschedule'.tr(),
            icon: Icons.history_toggle_off,
            onPressed: isLoading ? null : () => _rescheduleAppointment(context),
          ),
        ),
      );
      controls.add(const SizedBox(width: 12));
      controls.add(
        _buildCircleAction(
          icon: Icons.close,
          color: AppColors.medicalRed,
          onPressed: isLoading ? null : () => _showCancelConfirmation(context),
        ),
      );
    }

    if (compact) {
      return controls.map((widget) {
        if (widget is SizedBox) {
          return const SizedBox(height: 12);
        }

        if (widget is Expanded) {
          return SizedBox(width: double.infinity, child: widget.child);
        }

        return Align(alignment: AlignmentDirectional.centerEnd, child: widget);
      }).toList();
    }

    return controls;
  }

  Widget _buildPrimaryAction({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    Color? color,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return FilledButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: color ?? theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircleAction({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      style: IconButton.styleFrom(
        backgroundColor: color.withAlpha(20),
        foregroundColor: color,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildDoctorPrimaryAction(
    BuildContext context,
    AppointmentEntity appointment,
    bool isLoading,
  ) {
    String label = 'confirm_appointment'.tr();
    IconData icon = Icons.check_circle_outline;
    Color color = AppColors.success;
    AppointmentStatus? nextStatus;

    if (appointment.status == AppointmentStatus.scheduled) {
      nextStatus = AppointmentStatus.confirmed;
    } else if (appointment.status == AppointmentStatus.confirmed ||
        appointment.status == AppointmentStatus.arrived) {
      label = 'start_session'.tr();
      icon = Icons.play_arrow_rounded;
      color = AppColors.accentMint;
      nextStatus = AppointmentStatus.inProgress;
    } else if (appointment.status == AppointmentStatus.inProgress) {
      label = 'end_session'.tr();
      icon = Icons.stop_circle_outlined;
      color = AppColors.medicalRed;
      nextStatus = AppointmentStatus.completed;
    }

    return _buildPrimaryAction(
      label: label,
      icon: icon,
      color: color,
      onPressed: isLoading || nextStatus == null
          ? null
          : () => context.read<AppointmentDetailsCubit>().updateStatus(
              nextStatus!,
            ),
    );
  }

  void _showDoctorMoreActions(
    BuildContext context,
    AppointmentEntity appointment,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.history_toggle_off),
              title: Text('reschedule'.tr()),
              onTap: () {
                context.pop();
                _rescheduleAppointment(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.cancel_outlined,
                color: AppColors.medicalRed,
              ),
              title: Text(
                'cancel_appointment'.tr(),
                style: const TextStyle(color: AppColors.medicalRed),
              ),
              onTap: () {
                context.pop();
                _showCancelConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusDialog(BuildContext context) {
    showAppointmentStatusDialog(
      context: context,
      currentStatus: widget.appointment.status,
      onStatusSelected: (newStatus) {
        context.read<AppointmentDetailsCubit>().updateStatus(newStatus);
      },
    );
  }

  void _showCancelConfirmation(BuildContext context) async {
    final String? reason = await showCancellationReasonDialog(context);
    if (reason != null && context.mounted) {
      final cancelledBy = switch (widget.role) {
        AppointmentsOverviewMode.patient => 'patient',
        AppointmentsOverviewMode.doctor => 'doctor',
        AppointmentsOverviewMode.receptionist => 'receptionist',
        _ => 'admin',
      };

      context.read<AppointmentDetailsCubit>().cancelAppointment(
        cancelledBy: cancelledBy,
        reason: reason,
      );
    }
  }

  Future<void> _rescheduleAppointment(BuildContext context) async {
    final result = await context.push(
      AppRouter.scheduleAppointment,
      extra: {
        'appointment': widget.appointment,
        'mode': AppointmentScreenMode.reschedule,
      },
    );

    if (result == true) {
      widget.onDataChanged?.call();
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool _isFinalStatus(AppointmentEntity appointment) {
    return appointment.status == AppointmentStatus.completed ||
        appointment.status == AppointmentStatus.cancelled;
  }

  Widget _buildStatusBanner(
    BuildContext context,
    AppointmentEntity appointment,
  ) {
    final isCancelled = appointment.status == AppointmentStatus.cancelled;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isCancelled ? AppColors.error : AppColors.success).withAlpha(
          12,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: (isCancelled ? AppColors.error : AppColors.success).withAlpha(
            40,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCancelled ? Icons.block_rounded : Icons.verified_rounded,
            color: isCancelled ? AppColors.error : AppColors.success,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isCancelled
                  ? 'appointment_cancelled'.tr()
                  : 'appointment_completed'.tr(),
              style: TextStyle(
                color: isCancelled ? AppColors.error : AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyActionsHint(
    BuildContext context,
    AppointmentEntity appointment,
  ) {
    return Row(
      children: [
        const Icon(Icons.info_outline, color: AppColors.gray500, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'appointment_read_only_hint'.tr(),
            style: const TextStyle(fontSize: 13, color: AppColors.gray600),
          ),
        ),
      ],
    );
  }

  IconData _roleIcon(AppointmentsOverviewMode role) {
    return switch (role) {
      AppointmentsOverviewMode.patient => Icons.person_outline,
      AppointmentsOverviewMode.doctor => Icons.medical_services_outlined,
      AppointmentsOverviewMode.receptionist => Icons.support_agent_rounded,
      _ => Icons.badge_outlined,
    };
  }

  String _roleLabel(AppointmentsOverviewMode role) {
    return switch (role) {
      AppointmentsOverviewMode.patient => 'patient'.tr(),
      AppointmentsOverviewMode.doctor => 'doctor'.tr(),
      AppointmentsOverviewMode.receptionist => 'receptionist'.tr(),
      _ => 'details'.tr(),
    };
  }
}
