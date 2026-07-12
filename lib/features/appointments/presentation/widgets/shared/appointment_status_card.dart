import 'package:flutter/material.dart';

import '../../../domain/entities/appointment_status.dart';

class AppointmentStatusCard extends StatelessWidget {
  final AppointmentStatus? status;
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const AppointmentStatusCard({
    super.key,
    required this.status,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = status?.color ?? theme.colorScheme.primary;
    final isNeutral = status == null;

    final backgroundColor = isSelected
        ? accentColor.withAlpha(45)
        : isNeutral
        ? theme.colorScheme.surfaceContainerLow
        : accentColor.withAlpha(18);

    final borderColor = isSelected
        ? accentColor.withAlpha(220)
        : accentColor.withAlpha(isNeutral ? 60 : 120);

    final labelColor = isSelected ? accentColor : theme.colorScheme.onSurface.withAlpha(220);
    final countBackground = isSelected ? accentColor.withAlpha(50) : accentColor.withAlpha(30);
    final countColor = isSelected ? accentColor : accentColor.withAlpha(240);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: isSelected ? 2.2 : 1.2),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: accentColor.withAlpha(40),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isNeutral)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: accentColor.withAlpha(120), blurRadius: 5, spreadRadius: 1),
                    ],
                  ),
                ),
              if (!isNeutral) const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: countBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(color: countColor, fontSize: 11, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
