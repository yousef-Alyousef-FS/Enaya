import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/doctor_availability_model.dart';
import 'package:enaya/core/widgets/cards/app_base_card.dart';

class ExceptionCard extends StatelessWidget {
  final AvailabilityException exception;
  final VoidCallback onDelete;

  const ExceptionCard({super.key, required this.exception, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat.yMMMMEEEEd(context.locale.toString()).format(exception.date);
    final subtitle = exception.isOff
        ? 'slot_off'.tr()
        : '${exception.customHours?.startTime?.format(context) ?? '--:--'} - ${exception.customHours?.endTime?.format(context) ?? '--:--'}';

    return AppBaseCard(
      borderRadius: 16,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateText, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline)),
        ],
      ),
    );
  }
}
