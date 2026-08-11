class PrescriptionOptionsCatalog {
  const PrescriptionOptionsCatalog._();

  // --------------------------------------------------------------------
  // GENERIC POOLS — used when the drug is unknown, or has no type entry.
  // --------------------------------------------------------------------

  static const List<String> genericDosageOptions = [
    'dosage_one_pill',
    'dosage_half_pill',
    'dosage_two_pills',
    'dosage_one_spoon',
    'dosage_half_spoon',
    'dosage_one_drop',
    'dosage_one_spray',
    'dosage_one_suppository',
    'dosage_one_injection',
    'dosage_one_sachet',
  ];

  static const List<String> genericFrequencyOptions = [
    'frequency_once_daily',
    'frequency_twice_daily',
    'frequency_three_times_daily',
    'frequency_four_times_daily',
    'frequency_every_8_hours',
    'frequency_every_12_hours',
    'frequency_when_needed',
    'frequency_once_weekly',
  ];

  static const List<String> genericInstructionOptions = [
    'instr_after_food',
    'instr_before_food',
    'instr_when_needed',
    'instr_shake_well',
    'instr_keep_away_children',
  ];

  // --------------------------------------------------------------------
  // DOSAGE — per drug type
  // --------------------------------------------------------------------

  static const Map<String, List<String>> dosageByType = {
    'tablet': [
      'dosage_tablet_half',
      'dosage_tablet_one',
      'dosage_tablet_two',
    ],
    'syrup': [
      'dosage_syrup_5ml',
      'dosage_syrup_10ml',
      'dosage_syrup_15ml',
    ],
    'capsule': [
      'dosage_capsule_one',
      'dosage_capsule_two',
    ],
    'spray': [
      'dosage_spray_one_puff',
      'dosage_spray_two_puffs',
    ],
    'gel': [
      'dosage_topical_thin_layer',
      'dosage_topical_pea_size',
    ],
    'ointment': [
      'dosage_topical_thin_layer',
      'dosage_topical_pea_size',
    ],
    'cream': [
      'dosage_topical_thin_layer',
      'dosage_topical_pea_size',
    ],
    'drops_eye': [
      'dosage_drops_one_two',
      'dosage_drops_two_three',
    ],
    'drops_ear': [
      'dosage_drops_two_three',
      'dosage_drops_three_four',
    ],
    'drops_nose': [
      'dosage_drops_one_two',
      'dosage_drops_two_three',
    ],
    'suppository': [
      'dosage_suppository_one',
      'dosage_suppository_half',
    ],
    'injection_im': [
      'dosage_injection_1ml',
      'dosage_injection_2ml',
    ],
    'injection_iv': [
      'dosage_injection_iv_single_dose',
      'dosage_injection_iv_infusion',
    ],
    'inhaler': [
      'dosage_inhaler_one_puff',
      'dosage_inhaler_two_puffs',
    ],
    'patch': [
      'dosage_patch_one',
    ],
    'powder': [
      'dosage_powder_one_sachet',
      'dosage_powder_half_sachet',
    ],
    'mouthwash': [
      'dosage_mouthwash_10ml_rinse',
      'dosage_mouthwash_15ml_rinse',
    ],
  };

  // --------------------------------------------------------------------
  // FREQUENCY — per drug type
  // --------------------------------------------------------------------

  static const Map<String, List<String>> frequencyByType = {
    'tablet': [
      'frequency_once_daily',
      'frequency_twice_daily',
      'frequency_three_times_daily',
    ],
    'syrup': [
      'frequency_twice_daily',
      'frequency_three_times_daily',
      'frequency_every_8_hours',
    ],
    'capsule': [
      'frequency_once_daily',
      'frequency_twice_daily',
    ],
    'spray': [
      'frequency_twice_daily',
      'frequency_three_times_daily',
      'frequency_when_needed',
    ],
    'gel': ['frequency_twice_daily', 'frequency_three_times_daily'],
    'ointment': ['frequency_twice_daily', 'frequency_three_times_daily'],
    'cream': ['frequency_twice_daily', 'frequency_three_times_daily'],
    'drops_eye': [
      'frequency_three_times_daily',
      'frequency_four_times_daily',
      'frequency_every_8_hours',
    ],
    'drops_ear': [
      'frequency_twice_daily',
      'frequency_three_times_daily',
    ],
    'drops_nose': [
      'frequency_twice_daily',
      'frequency_three_times_daily',
      'frequency_when_needed',
    ],
    'suppository': [
      'frequency_once_daily',
      'frequency_twice_daily',
    ],
    'injection_im': [
      'frequency_once_daily',
      'frequency_once_weekly',
    ],
    'injection_iv': [
      'frequency_once_daily',
      'frequency_when_needed',
    ],
    'inhaler': [
      'frequency_twice_daily',
      'frequency_when_needed',
    ],
    'patch': [
      'frequency_once_daily',
      'frequency_once_weekly',
    ],
    'powder': [
      'frequency_once_daily',
      'frequency_twice_daily',
    ],
    'mouthwash': [
      'frequency_twice_daily',
      'frequency_three_times_daily',
    ],
  };

  // --------------------------------------------------------------------
  // INSTRUCTIONS — per drug type
  // --------------------------------------------------------------------

  static const Map<String, List<String>> instructionsByType = {
    'tablet': [
      'instr_after_food',
      'instr_before_food',
      'instr_with_water',
    ],
    'syrup': [
      'instr_shake_well',
      'instr_after_food',
      'instr_use_measuring_cup',
    ],
    'capsule': [
      'instr_after_food',
      'instr_before_food',
      'instr_do_not_crush',
    ],
    'spray': [
      'instr_shake_well',
      'instr_avoid_eyes',
    ],
    'gel': ['instr_external_use_only', 'instr_avoid_eyes'],
    'ointment': ['instr_external_use_only', 'instr_avoid_eyes'],
    'cream': ['instr_external_use_only', 'instr_avoid_eyes'],
    'drops_eye': [
      'instr_wash_hands_before_use',
      'instr_avoid_touching_tip',
    ],
    'drops_ear': [
      'instr_warm_to_room_temp',
      'instr_avoid_touching_tip',
    ],
    'drops_nose': [
      'instr_blow_nose_before_use',
      'instr_avoid_touching_tip',
    ],
    'suppository': [
      'instr_wash_hands_before_use',
      'instr_keep_refrigerated',
    ],
    'injection_im': [
      'instr_administered_by_professional',
    ],
    'injection_iv': [
      'instr_administered_by_professional',
    ],
    'inhaler': [
      'instr_shake_well',
      'instr_rinse_mouth_after_use',
    ],
    'patch': [
      'instr_apply_clean_dry_skin',
      'instr_rotate_application_site',
    ],
    'powder': [
      'instr_dissolve_in_water',
    ],
    'mouthwash': [
      'instr_do_not_swallow',
      'instr_do_not_rinse_after',
    ],
  };

  // --------------------------------------------------------------------
  // LOOKUP HELPERS — the only entry points callers should use.
  // --------------------------------------------------------------------

  static List<String> dosageFor(String? drugType) {
    if (drugType == null) return genericDosageOptions;
    return dosageByType[drugType] ?? genericDosageOptions;
  }

  static List<String> frequencyFor(String? drugType) {
    if (drugType == null) return genericFrequencyOptions;
    return frequencyByType[drugType] ?? genericFrequencyOptions;
  }

  static List<String> instructionsFor(String? drugType) {
    if (drugType == null) return genericInstructionOptions;
    return instructionsByType[drugType] ?? genericInstructionOptions;
  }
}