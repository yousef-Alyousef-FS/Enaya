import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<String?> showCancellationReasonDialog(BuildContext context) {
  final List<String> commonReasons = [
    'patient_request'.tr(),
    'doctor_emergency'.tr(),
    'system_error'.tr(),
    'no_show'.tr(),
    'rescheduled_outside'.tr(),
  ];

  String? selectedReason;
  final TextEditingController customReasonController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'cancel_reason_title'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...commonReasons.map(
                    (reason) => Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => selectedReason = reason),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: selectedReason == reason,
                                    onChanged: (value) => setState(
                                      () => selectedReason = value == true ? reason : null,
                                    ),
                                    activeColor: Theme.of(context).colorScheme.primary,
                                  ),
                                  Expanded(
                                    child: Text(reason, style: const TextStyle(fontSize: 14)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: customReasonController,
                    decoration: InputDecoration(
                      hintText: 'other_reason_hint'.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    style: const TextStyle(fontSize: 14),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() => selectedReason = null);
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'back'.tr(),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
              ElevatedButton(
                onPressed: (selectedReason == null && customReasonController.text.trim().isEmpty)
                    ? null
                    : () {
                        final finalReason = selectedReason ?? customReasonController.text.trim();
                        Navigator.pop(context, finalReason);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('confirm_cancellation'.tr()),
              ),
            ],
          );
        },
      );
    },
  );
}
