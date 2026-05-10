import 'package:enaya/features/appointments/domain/entities/appointment_status.dart';
import 'package:flutter/material.dart';

/// A reusable badge for displaying appointment statuses with consistent styling.
///
/// Features:
/// - Color-coded by status (theme-aware)
/// - Optional icon display
/// - Responsive sizing with proper spacing
/// - Read-only visual indicator for completed/cancelled statuses
class StatusBadge extends StatelessWidget {
  final AppointmentStatus status;
  final bool showIcon;
  final bool isReadOnly;

  const StatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = status.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(100), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(status.icon, size: 16, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            status.displayName,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.3,
            ),
          ),
          if (isReadOnly) ...[
            const SizedBox(width: 6),
            Icon(
              Icons.lock,
              size: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );
  }
}
