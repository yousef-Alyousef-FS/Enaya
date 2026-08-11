import 'package:flutter/material.dart';

import 'drug_model.dart';
import 'drug_search_service.dart';
import 'prescription_options_catalog.dart';
import 'prescription_suggestions_service.dart';

class PrescriptionFormControllers {
  final DrugSearchService drugSearchService;
  final PrescriptionSuggestionsService suggestionsService;

  // Controllers
  final TextEditingController drugController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  // Drug selection state
  List<DrugModel> drugSuggestions = [];
  bool isLoadingDrugSuggestions = false;
  DrugModel? selectedDrug;

  List<String> _masterDosagePool = PrescriptionOptionsCatalog.genericDosageOptions;
  List<String> _masterFrequencyPool = PrescriptionOptionsCatalog.genericFrequencyOptions;
  List<String> _masterInstructionPool = PrescriptionOptionsCatalog.genericInstructionOptions;

  List<String> dosageOptions = [];
  List<String> frequencyFiltered = [];
  List<String> instructionOptions = [];

  // Internal guards
  bool _suppressDrugListener = false;
  int _drugSearchRequestId = 0;

  // Callbacks out to the parent widget
  final Function(String) onDrugChanged;
  final Function(String) onDosageChanged;
  final Function(String) onFrequencyChanged;
  final Function(String) onInstructionChanged;
  final Function(String) onDurationChanged;

  // NEW: callback to notify UI
  final VoidCallback onStateChanged;

  PrescriptionFormControllers({
    required this.onDrugChanged,
    required this.onDosageChanged,
    required this.onFrequencyChanged,
    required this.onInstructionChanged,
    required this.onDurationChanged,
    required this.onStateChanged,
    DrugSearchService? drugSearchService,
    PrescriptionSuggestionsService? suggestionsService,
  })  : drugSearchService = drugSearchService ?? DrugSearchService(),
        suggestionsService = suggestionsService ?? PrescriptionSuggestionsService() {
    _initListeners();
    _filterAll();
  }

  // ------------------------------------------------------------------
  // INIT
  // ------------------------------------------------------------------

  void _initListeners() {
    drugController.addListener(_onDrugTextChanged);

    dosageController.addListener(() {
      onDosageChanged(dosageController.text);
      dosageOptions = suggestionsService.filter(dosageController.text, _masterDosagePool);
      onStateChanged();
    });

    frequencyController.addListener(() {
      onFrequencyChanged(frequencyController.text);
      frequencyFiltered = suggestionsService.filter(frequencyController.text, _masterFrequencyPool);
      onStateChanged();
    });

    instructionsController.addListener(() {
      onInstructionChanged(instructionsController.text);
      instructionOptions = suggestionsService.filter(instructionsController.text, _masterInstructionPool);
      onStateChanged();
    });

    durationController.addListener(() {
      onDurationChanged(durationController.text);
      onStateChanged();
    });
  }

  // ------------------------------------------------------------------
  // DRUG FIELD
  // ------------------------------------------------------------------

  void _onDrugTextChanged() {
    if (_suppressDrugListener) return;

    final text = drugController.text.trim();
    onDrugChanged(text);

    final stillMatchesSelected = selectedDrug != null &&
        selectedDrug!.name.toLowerCase() == text.toLowerCase();

    if (stillMatchesSelected) return;

    if (selectedDrug != null) {
      selectedDrug = null;
      _applyPoolsFor(null);
    }

    if (text.isEmpty) {
      drugSuggestions = [];
      isLoadingDrugSuggestions = false;
      onStateChanged();
    } else {
      updateDrugSuggestions(text);
    }

    _filterAll();
    onStateChanged();
  }

  Future<void> updateDrugSuggestions(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      drugSuggestions = [];
      isLoadingDrugSuggestions = false;
      onStateChanged();
      return;
    }

    final requestId = ++_drugSearchRequestId;
    isLoadingDrugSuggestions = true;
    onStateChanged();

    final results = await drugSearchService.searchByName(normalized);

    if (requestId != _drugSearchRequestId) return;

    if (drugController.text.trim().toLowerCase() != normalized.toLowerCase()) return;

    if (selectedDrug != null &&
        selectedDrug!.name.toLowerCase() == normalized.toLowerCase()) {
      isLoadingDrugSuggestions = false;
      onStateChanged();
      return;
    }

    drugSuggestions = results;
    isLoadingDrugSuggestions = false;
    onStateChanged();
  }

  void selectDrug(DrugModel drug) {
    _drugSearchRequestId++;

    selectedDrug = drug;

    _suppressDrugListener = true;
    drugController
      ..text = drug.name
      ..selection = TextSelection.collapsed(offset: drug.name.length);
    _suppressDrugListener = false;

    drugSuggestions = [];
    isLoadingDrugSuggestions = false;

    _applyPoolsFor(drug.type);
    _filterAll();
    onStateChanged();
  }

  // ------------------------------------------------------------------
  // POOL SELECTION
  // ------------------------------------------------------------------

  void _applyPoolsFor(String? drugType) {
    _masterDosagePool = PrescriptionOptionsCatalog.dosageFor(drugType);
    _masterFrequencyPool = PrescriptionOptionsCatalog.frequencyFor(drugType);
    _masterInstructionPool = PrescriptionOptionsCatalog.instructionsFor(drugType);
  }

  void _filterAll() {
    dosageOptions = suggestionsService.filter(dosageController.text, _masterDosagePool);
    frequencyFiltered = suggestionsService.filter(frequencyController.text, _masterFrequencyPool);
    instructionOptions = suggestionsService.filter(instructionsController.text, _masterInstructionPool);
  }

  // ------------------------------------------------------------------
  // PREFILL
  // ------------------------------------------------------------------

  Future<void> prefillInitialValues({
    String? initialDrug,
    String? initialDosage,
    String? initialFrequency,
    String? initialInstruction,
    String? initialDuration,
  }) async {
    if (initialDrug != null && initialDrug.isNotEmpty) {
      _suppressDrugListener = true;
      drugController.text = initialDrug;
      _suppressDrugListener = false;

      final matches = await drugSearchService.searchByName(initialDrug);
      final exactMatch = matches.where(
        (d) => d.name.toLowerCase() == initialDrug.toLowerCase(),
      );

      if (exactMatch.isNotEmpty) {
        selectedDrug = exactMatch.first;
        _applyPoolsFor(selectedDrug!.type);
      } else {
        selectedDrug = null;
        _applyPoolsFor(null);
      }
    }

    if (initialDosage != null) dosageController.text = initialDosage;
    if (initialFrequency != null) frequencyController.text = initialFrequency;
    if (initialInstruction != null) instructionsController.text = initialInstruction;
    if (initialDuration != null) durationController.text = initialDuration;

    _filterAll();
    onStateChanged();
  }

  // ------------------------------------------------------------------
  // CLEANUP
  // ------------------------------------------------------------------

  void dispose() {
    drugController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    durationController.dispose();
    instructionsController.dispose();
  }
}
