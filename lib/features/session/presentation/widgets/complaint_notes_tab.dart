import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/theme/app_colors.dart';
import '../../domain/entities/session_entity.dart';

class ComplaintNotesTab extends StatefulWidget {
  final SessionEntity session;
  final Function(String complaint, String notes) onDataChanged;

  const ComplaintNotesTab({
    super.key, 
    required this.session,
    required this.onDataChanged,
  });

  @override
  State<ComplaintNotesTab> createState() => _ComplaintNotesTabState();
}

class _ComplaintNotesTabState extends State<ComplaintNotesTab> {
  late TextEditingController complaintController;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    complaintController = TextEditingController(text: widget.session.patientComplaint);
    notesController = TextEditingController(text: widget.session.notes);

    complaintController.addListener(_notifyChanges);
    notesController.addListener(_notifyChanges);
  }

  void _notifyChanges() {
    widget.onDataChanged(complaintController.text, notesController.text);
  }

  @override
  void dispose() {
    complaintController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInputCard(
            context,
            label: "patient_complaint".tr(),
            icon: Icons.personal_injury_rounded,
            controller: complaintController,
            hint: "reason_hint".tr(),
            maxLines: 4,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildInputCard(
            context,
            label: "doctor_notes".tr(),
            icon: Icons.note_alt_rounded,
            controller: notesController,
            hint: "notes_hint".tr(),
            maxLines: 6,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(
    BuildContext context, {
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required int maxLines,
    required bool isDark,
  }) {
    return Card(
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
                Icon(icon, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hint,
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
    );
  }
}
