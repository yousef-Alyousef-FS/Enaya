import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/theme/app_colors.dart';

import 'logic/prescription_form_controllers.dart';
import 'logic/drug_search_service.dart';
import 'logic/prescription_suggestions_service.dart';

import 'widgets/prescription_input_field.dart';
import 'widgets/drug_suggestions_panel.dart';
import 'widgets/prescription_option_chips.dart';

/// Clean UI-only form. All logic is separated into controllers & services.
class PrescriptionForm extends StatefulWidget {
  final String? initialDrugName;
  final String? initialDosage;
  final String? initialFrequency;
  final String? initialInstruction;
  final String? initialDuration;

  final Function(String) onDrugChanged;
  final Function(String) onDosageChanged;
  final Function(String) onFrequencyChanged;
  final Function(String) onInstructionChanged;
  final Function(String) onDurationChanged;

  const PrescriptionForm({
    super.key,
    this.initialDrugName,
    this.initialDosage,
    this.initialFrequency,
    this.initialInstruction,
    this.initialDuration,
    required this.onDrugChanged,
    required this.onDosageChanged,
    required this.onFrequencyChanged,
    required this.onInstructionChanged,
    required this.onDurationChanged,
  });

  @override
  State<PrescriptionForm> createState() => _PrescriptionFormState();
}

class _PrescriptionFormState extends State<PrescriptionForm> {
  late final PrescriptionFormControllers controllers;

  @override
  void initState() {
    super.initState();

    controllers = PrescriptionFormControllers(
      onDrugChanged: widget.onDrugChanged,
      onDosageChanged: widget.onDosageChanged,
      onFrequencyChanged: widget.onFrequencyChanged,
      onInstructionChanged: widget.onInstructionChanged,
      onDurationChanged: widget.onDurationChanged,
      drugSearchService: DrugSearchService(),
      suggestionsService: PrescriptionSuggestionsService(),

      /// 🔥 أهم تعديل: ربط الـ controllers بالـ UI
      onStateChanged: () => setState(() {}),
    );

    controllers.prefillInitialValues(
      initialDrug: widget.initialDrugName,
      initialDosage: widget.initialDosage,
      initialFrequency: widget.initialFrequency,
      initialInstruction: widget.initialInstruction,
      initialDuration: widget.initialDuration,
    );
  }

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.gray800 : AppColors.gray100,
        ),
      ),
      child: Column(
        children: [
          // ---------------- DRUG FIELD ----------------
          PrescriptionInputField(
            label: 'drug_name'.tr(),
            icon: Icons.medication_rounded,
            controller: controllers.drugController,
            hint: "drug_name_hint".tr(),
          ),

          const SizedBox(height: 10),

          /// 🔥 الآن سيظهر لأن setState يعمل
          if (controllers.drugSuggestions.isNotEmpty ||
              controllers.isLoadingDrugSuggestions)
            DrugSuggestionsPanel(
              isLoading: controllers.isLoadingDrugSuggestions,
              suggestions: controllers.drugSuggestions,
              onSelect: (drug) {
                controllers.selectDrug(drug);
                setState(() {});
              },
            ),

          const SizedBox(height: 16),

          // ---------------- DOSAGE + DURATION ----------------
          Row(
            children: [
              Expanded(
                child: PrescriptionInputField(
                  label: 'dosage'.tr(),
                  icon: Icons.scale_rounded,
                  controller: controllers.dosageController,
                  hint: "dosage_hint".tr(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrescriptionInputField(
                  label: 'duration'.tr(),
                  icon: Icons.calendar_today_rounded,
                  controller: controllers.durationController,
                  hint: "duration_hint".tr(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          PrescriptionOptionChips(
            label: "dosage_suggestions".tr(),
            options: controllers.dosageOptions,
            onSelected: (value) {
              controllers.dosageController.text = value.tr();
              setState(() {});
            },
          ),

          const SizedBox(height: 16),

          // ---------------- FREQUENCY ----------------
          PrescriptionInputField(
            label: 'frequency'.tr(),
            icon: Icons.repeat_rounded,
            controller: controllers.frequencyController,
            hint: "frequency_hint".tr(),
          ),

          const SizedBox(height: 10),

          PrescriptionOptionChips(
            label: "frequency_suggestions".tr(),
            options: controllers.frequencyFiltered,
            onSelected: (value) {
              controllers.frequencyController.text = value.tr();
              setState(() {});
            },
          ),

          const SizedBox(height: 16),

          // ---------------- INSTRUCTIONS ----------------
          PrescriptionInputField(
            label: 'instructions'.tr(),
            icon: Icons.info_outline_rounded,
            controller: controllers.instructionsController,
            hint: "instructions_hint".tr(),
            maxLines: 3,
          ),

          const SizedBox(height: 10),

          PrescriptionOptionChips(
            label: "instruction_suggestions".tr(),
            options: controllers.instructionOptions,
            onSelected: (value) {
              controllers.instructionsController.text = value.tr();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
