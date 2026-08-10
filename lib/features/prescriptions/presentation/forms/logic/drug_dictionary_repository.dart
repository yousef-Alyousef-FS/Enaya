import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'drug_model.dart';

class DrugDictionaryRepository {
  DrugDictionaryRepository._internal();
  static final DrugDictionaryRepository instance =
      DrugDictionaryRepository._internal();

  static const String _assetPath = 'assets/mock_data/drugs_dictionary.json';

  List<DrugModel>? _cache;

  /// Returns the full dictionary, loading and caching it on first call.
  Future<List<DrugModel>> loadAll() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(raw) as List<dynamic>;

    final drugs = decoded
        .map((item) => DrugModel.fromJson(item as Map<String, dynamic>))
        .toList();

    _cache = drugs;
    return drugs;
  }

  /// Clears the cache.
  void clearCache() {
    _cache = null;
  }
}