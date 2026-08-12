import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/theme/app_colors.dart';
import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/presentation/cubit/prescription_cubit.dart';
import 'package:enaya/features/prescriptions/presentation/cubit/prescription_state.dart';
import 'package:enaya/features/prescriptions/presentation/screens/add_prescription_screen.dart';
import 'package:enaya/features/prescriptions/presentation/widgets/prescription_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  final int appointmentId;
  final int sessionId;
  final PrescriptionEntity prescription;
  final String? doctorName;
  final PrescriptionCubit prescriptionCubit;

  // Flag to determine if the user has permission to Edit/Delete
  // Default is true to maintain current doctor-side functionality
  final bool canEdit;

  const PrescriptionDetailScreen({
    super.key,
    required this.appointmentId,
    required this.sessionId,
    required this.prescription,
    required this.prescriptionCubit,
    this.doctorName,
    this.canEdit = true, // Set this to false for the patient side
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('details'.tr()), centerTitle: true),
      body: SingleChildScrollView(
        // Reduce bottom padding if there is no action bar
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, canEdit ? 120.0 : 16.0),
        child: PrescriptionDetailCard(
          prescription: prescription,
          doctorName: doctorName,
        ),
      ),
      // Only show the action bar (Edit/Delete) if canEdit is true
      bottomNavigationBar: canEdit ? _buildActionBar(context) : null,
    );
  }

  /// Builds the action bar containing Edit and Delete buttons
  Widget _buildActionBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: () => _handleEdit(context),
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(
                    'edit'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.primary.withOpacity(0.35),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text(
                    'Delete',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Navigates to the Add/Edit screen
  void _handleEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (routeContext) => BlocProvider.value(
          value: prescriptionCubit,
          child: AddPrescriptionScreen(
            appointmentId: appointmentId,
            sessionId: sessionId,
            prescription: prescription,
          ),
        ),
      ),
    );
  }

  /// Shows a confirmation dialog before deleting
  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete prescription?'),
          content: const Text(
            'This action will remove the prescription permanently.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) return;

    await prescriptionCubit.deletePrescription(
      sessionId: sessionId,
      prescriptionId: prescription.id,
      appointmentId: appointmentId,
    );

    if (!context.mounted) return;

    final state = prescriptionCubit.state;
    if (state is PrescriptionError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (state is PrescriptionLoaded) {
      Navigator.pop(context);
    }
  }
}
