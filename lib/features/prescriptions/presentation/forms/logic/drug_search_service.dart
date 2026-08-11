import 'drug_model.dart';
import 'drug_dictionary_repository.dart';

class DrugSearchService {
  final DrugDictionaryRepository _repository;

  DrugSearchService({DrugDictionaryRepository? repository})
      : _repository = repository ?? DrugDictionaryRepository.instance;

  Future<List<DrugModel>> searchByName(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return const [];

    final all = await _repository.loadAll();
    return all
        .where((drug) => drug.name.toLowerCase().contains(normalized))
        .toList();
  }
}