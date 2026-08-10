import 'package:easy_localization/easy_localization.dart';

class PrescriptionSuggestionsService {
  List<String> filter(String input, List<String> pool) {
    final normalized = input.trim().toLowerCase();
    if (normalized.isEmpty) return List<String>.from(pool);

    return pool.where((option) {
      final keyMatches = option.toLowerCase().contains(normalized);
      final translatedMatches = option.tr().toLowerCase().contains(normalized);
      return keyMatches || translatedMatches;
    }).toList();
  }
}