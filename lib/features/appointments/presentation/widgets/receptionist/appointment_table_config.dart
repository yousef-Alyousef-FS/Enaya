import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/widgets/tables/appointments_table/table_column_model.dart';
import '../../../domain/entities/appointment_status.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/appointment_entity.dart';
import '../../../../../core/widgets/badges/status_badge.dart';

class AppointmentTableConfig {
  static List<TableColumn<AppointmentEntity>> build({
    required BuildContext context,
    required List<AppointmentEntity> appointments,
    required void Function(AppointmentEntity app) onView,
    void Function(AppointmentEntity app)? onEdit,
    void Function(AppointmentEntity app)? onCheckIn,
  }) {
    final theme = Theme.of(context);
    final textDirection = Directionality.of(context);

    double measureText(String text, TextStyle style) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: textDirection,
      )..layout();
      return painter.width;
    }

    double columnWidth({
      required String header,
      required Iterable<String> values,
      required double maxWidth,
      double horizontalPadding = 28,
      TextStyle? style,
    }) {
      final contentStyle = style ?? theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
      final headerWidth = measureText(header, theme.textTheme.titleSmall ?? contentStyle);
      final valueWidth = values.isEmpty
          ? 0.0
          : values.map((value) => measureText(value, contentStyle)).reduce((a, b) => a > b ? a : b);

      final baseWidth = (headerWidth > valueWidth ? headerWidth : valueWidth) + horizontalPadding;
      return baseWidth.clamp(72.0, maxWidth);
    }

    final patientWidth = columnWidth(
      header: 'patient'.tr(),
      values: appointments.map((appointment) => appointment.patientName),
      maxWidth: 320,
    );

    final timeWidth = columnWidth(
      header: 'time'.tr(),
      values: appointments.map((appointment) => DateFormat('HH:mm').format(appointment.dateTime)),
      maxWidth: 120,
      horizontalPadding: 24,
    );

    final doctorWidth = columnWidth(
      header: 'doctor'.tr(),
      values: appointments.map((appointment) => appointment.doctorName),
      maxWidth: 260,
    );

    final statusWidth = columnWidth(
      header: 'status'.tr(),
      values: appointments.map((appointment) => appointment.status.displayName),
      maxWidth: 150,
      horizontalPadding: 24,
    );

    final actionCount = 1 + (onEdit != null ? 1 : 0) + (onCheckIn != null ? 1 : 0);
    final actionButtonsWidth = actionCount * 56.0;
    final actionsHeaderWidth = measureText(
      'actions'.tr(),
      theme.textTheme.titleSmall ?? const TextStyle(fontSize: 15),
    );
    final actionsWidth =
        (actionButtonsWidth > actionsHeaderWidth ? actionButtonsWidth : actionsHeaderWidth) + 16;

    Widget _actionButton({
      required IconData icon,
      required Color color,
      required VoidCallback onTap,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(color: color.withAlpha(20), shape: BoxShape.circle),
        child: IconButton(
          icon: Icon(icon, color: color, size: 20),
          onPressed: onTap,
          splashRadius: 22,
        ),
      );
    }

    return [
      TableColumn(
        label: 'patient'.tr(),
        width: patientWidth,
        sortable: true,
        sortValue: (a) => a.patientName,
        cell: (a) =>
            Text(a.patientName, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false),
      ),

      TableColumn(
        label: 'time'.tr(),
        width: timeWidth,
        sortable: true,
        sortValue: (a) => a.dateTime,
        cell: (a) => Text(DateFormat('HH:mm').format(a.dateTime)),
      ),

      TableColumn(
        label: 'doctor'.tr(),
        width: doctorWidth,
        hideOnMobile: true,
        cell: (a) =>
            Text(a.doctorName, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false),
      ),

      TableColumn(
        label: 'status'.tr(),
        width: statusWidth,
        cell: (a) => StatusBadge(status: a.status, showIcon: false),
      ),

      TableColumn(
        label: 'actions'.tr(),
        width: actionsWidth,
        cell: (a) => Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _actionButton(
              icon: Icons.visibility,
              color: const Color(0xFF4A6CF7),
              onTap: () => onView(a),
            ),
            if (onEdit != null)
              _actionButton(
                icon: Icons.edit,
                color: const Color(0xFFFFB300),
                onTap: () => onEdit(a),
              ),
            if (onCheckIn != null)
              _actionButton(
                icon: Icons.check_circle,
                color: const Color(0xFF00C48C),
                onTap: () => onCheckIn(a),
              ),
          ],
        ),
      ),
    ];
  }
}
