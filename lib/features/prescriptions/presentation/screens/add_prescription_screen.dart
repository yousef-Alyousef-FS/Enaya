import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/theme/app_colors.dart';
import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/presentation/cubit/prescription_cubit.dart';
import 'package:enaya/features/prescriptions/presentation/cubit/prescription_state.dart';
import 'package:enaya/features/prescriptions/presentation/forms/prescription_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPrescriptionScreen extends StatefulWidget {
  final int appointmentId;
  final int sessionId;
  final PrescriptionEntity? prescription;

  const AddPrescriptionScreen({
    super.key,
    required this.appointmentId,
    required this.sessionId,
    this.prescription,
  });

  bool get isEditMode => prescription != null;

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  String _drugName = "";
  String _dosage = "";
  String _frequency = "";
  String _instructions = "";
  String _duration = "";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<PrescriptionCubit, PrescriptionState>(
      listener: (context, state) {
        if (state is PrescriptionAdded || state is PrescriptionUpdated) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('saved_successfully'.tr())));
          Navigator.pop(context);
        } else if (state is PrescriptionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        // ⭐ AppBar يستجيب للثيم تلقائيًا
        appBar: AppBar(
          title: Text(
            widget.isEditMode ? 'edit'.tr() : "add_prescription".tr(),
          ),
          centerTitle: true,
          elevation: 0,

          // الخلفية تتبع الثيم
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

          // لون النص يتبع الثيم
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,

          // ⭐ نضيف الـ Gradient فقط في الوضع الفاتح
          flexibleSpace: !isDark
              ? Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFF8FBFF), Color(0xFFEAF4FF)],
                    ),
                  ),
                )
              : null,
        ),

        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 96.0),
                  physics: const BouncingScrollPhysics(),
                  child: PrescriptionForm(
                    initialDrugName: widget.prescription?.medicationName,
                    initialDosage: widget.prescription?.dosage,
                    initialFrequency: widget.prescription?.frequency,
                    initialInstruction: widget.prescription?.instructions,
                    initialDuration: widget.prescription?.durationDays
                        .toString(),
                    onDrugChanged: (v) => _drugName = v,
                    onDosageChanged: (v) => _dosage = v,
                    onFrequencyChanged: (v) => _frequency = v,
                    onInstructionChanged: (v) => _instructions = v,
                    onDurationChanged: (v) => _duration = v,
                  ),
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: _buildSaveButton(),
      ),
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<PrescriptionCubit, PrescriptionState>(
      builder: (context, state) {
        final isLoading = state is PrescriptionLoading;

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                onPressed: isLoading ? null : _savePrescription,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        widget.isEditMode
                            ? 'edit'.tr()
                            : "save_prescription".tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _savePrescription() {
    if (_drugName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('error_occurred'.tr())));
      return;
    }

    final entity = PrescriptionEntity(
      id: widget.prescription?.id ?? 0,
      sessionId: widget.sessionId,
      medicationName: _drugName,
      dosage: _dosage,
      frequency: _frequency,
      durationDays: int.tryParse(_duration) ?? 1,
      instructions: _instructions,
      createdAt: widget.prescription?.createdAt ?? DateTime.now(),
    );

    if (widget.isEditMode) {
      context.read<PrescriptionCubit>().updatePrescription(
        sessionId: widget.sessionId,
        prescriptionId: entity.id,
        entity: entity,
      );
    } else {
      context.read<PrescriptionCubit>().addPrescription(
        sessionId: widget.sessionId,
        entity: entity,
      );
    }
  }
}
