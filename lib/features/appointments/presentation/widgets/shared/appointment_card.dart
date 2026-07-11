import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../data/models/appointments_overview_view_mode.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import 'appointment_status_chip.dart';
import 'package:enaya/core/widgets/cards/app_base_card.dart';

enum AppointmentCardLayout { simple, featured, compact }

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final AppointmentsOverviewMode mode;
  final AppointmentCardLayout layout;
  final VoidCallback? onTap;
  final VoidCallback? onAction; 
  final VoidCallback? onSecondaryAction;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.mode,
    this.layout = AppointmentCardLayout.simple,
    this.onTap,
    this.onAction,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    switch (layout) {
      case AppointmentCardLayout.featured:
        return _buildFeaturedLayout(context);
      case AppointmentCardLayout.compact:
        return _buildCompactLayout(context);
      default:
        return _buildSimpleLayout(context);
    }
  }

  Widget _buildFeaturedLayout(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = context.locale.toString();
    final time = DateFormat('hh:mm a', locale).format(appointment.dateTime);
    final date = DateFormat('EEEE, dd MMMM', locale).format(appointment.dateTime);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
            ? [theme.colorScheme.primary.withValues(alpha: 0.2), theme.colorScheme.surface]
            : [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: _buildDoctorAvatar(theme, size: 54),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appointment.doctorName,
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                appointment.reason ?? 'general_checkup'.tr(),
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildWhiteStatusChip(appointment.status),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildCountdownIfTodayWhite(theme),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoTileWhite(Icons.calendar_today_rounded, date),
                      _infoTileWhite(Icons.access_time_filled_rounded, time),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _glassButton(
                          context,
                          label: 'reschedule'.tr(),
                          onPressed: onSecondaryAction,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onAction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Text('view_details'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildWhiteStatusChip(AppointmentStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name.tr().toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  Widget _infoTileWhite(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.8)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _glassButton(BuildContext context, {required String label, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        alignment: Alignment.center,
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildCountdownIfTodayWhite(ThemeData theme) {
    final now = DateTime.now();
    final isToday = appointment.dateTime.year == now.year &&
        appointment.dateTime.month == now.month &&
        appointment.dateTime.day == now.day;

    if (!isToday || appointment.dateTime.isBefore(now)) return const SizedBox.shrink();

    final diff = appointment.dateTime.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    String text = hours > 0 
      ? 'starts_in_hours'.tr(args: [hours.toString(), minutes.toString()])
      : 'starts_in_minutes'.tr(args: [minutes.toString()]);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 16, color: Colors.orangeAccent),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSimpleLayout(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.toString();
    final time = DateFormat.jm(locale).format(appointment.dateTime);
    DateFormat('dd MMM', locale).format(appointment.dateTime);
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 16, height: 16,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.primary, width: 4),
                ),
              ),
              Expanded(
                child: Container(
                  width: 2, 
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [theme.colorScheme.primary.withValues(alpha: 0.2), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: AppBaseCard(
                onTap: onTap,
                padding: const EdgeInsets.all(16),
                borderRadius: 24,
                elevation: 0,
                backgroundColor: theme.colorScheme.surface,
                borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(time.split(' ')[0], style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w900, fontSize: 16)),
                          Text(time.split(' ')[1], style: TextStyle(color: theme.colorScheme.primary.withValues(alpha: 0.7), fontWeight: FontWeight.bold, fontSize: 10)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appointment.doctorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(
                            appointment.reason ?? 'general_checkup'.tr(), 
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppointmentStatusChip(status: appointment.status),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Compact Layout
  Widget _buildCompactLayout(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: appointment.status.color.withValues(alpha: 0.1),
        child: Icon(Icons.history, color: appointment.status.color, size: 18),
      ),
      title: Text(appointment.doctorName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(DateFormat('dd/MM/yyyy • hh:mm a').format(appointment.dateTime), style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, size: 18),
    );
  }

  // --- Helpers ---


  Widget _buildDoctorAvatar(ThemeData theme, {double size = 48}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person_rounded, color: theme.colorScheme.primary, size: size * 0.6),
    );
  }


}
