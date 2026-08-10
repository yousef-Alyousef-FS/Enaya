import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/layout/responsive_layout.dart';

/// A single prescription card widget (brief view).
class PrescriptionItem extends StatelessWidget {
  final PrescriptionEntity prescription;
  final VoidCallback? onTap;

  const PrescriptionItem({super.key, required this.prescription, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = ResponsiveLayout.of(context);

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: layout.cardHorizontalPadding,
        vertical: layout.scrollVerticalPadding,
      ),
      child: ListTile(
        onTap: onTap, // later: show prescription details
        title: Text(
          prescription.medicationName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: layout.bodyFontSize,
          ),
        ),
        subtitle: Text(
          "${"dosage".tr()}: ${prescription.dosage}",
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: layout.bodyFontSize,
          ),
        ),
        trailing: Icon(Icons.medical_services, size: layout.iconSize),
      ),
    );
  }
}
