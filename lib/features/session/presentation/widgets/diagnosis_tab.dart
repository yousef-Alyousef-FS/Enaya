import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/theme/app_colors.dart';
import '../../domain/entities/session_entity.dart';

class DiagnosisTab extends StatefulWidget {
  final SessionEntity session;
  final Function(String diagnosis) onDataChanged;

  const DiagnosisTab({
    super.key, 
    required this.session,
    required this.onDataChanged,
  });

  @override
  State<DiagnosisTab> createState() => _DiagnosisTabState();
}

class _DiagnosisTabState extends State<DiagnosisTab> {
  late TextEditingController diagnosisController;

  @override
  void initState() {
    super.initState();
    diagnosisController = TextEditingController(text: widget.session.diagnosis);
    diagnosisController.addListener(() {
      widget.onDataChanged(diagnosisController.text);
    });
  }

  @override
  void dispose() {
    diagnosisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark ? AppColors.gray800 : AppColors.gray100,
          ),
        ),
        color: isDark ? AppColors.darkSurface : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.analytics_rounded, color: AppColors.primary, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    "diagnosis".tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: diagnosisController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "diagnosis_hint".tr(),
                  hintStyle: TextStyle(color: AppColors.gray400),
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurfaceSoft : AppColors.gray50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
