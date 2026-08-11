import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/features/prescriptions/presentation/forms/logic/drug_model.dart';
import 'package:flutter/material.dart';
import 'package:enaya/core/theme/app_colors.dart';

/// Panel that displays drug suggestions under the drug input field.
///
/// Each dictionary entry is shown as its own row, including its type
/// (e.g. "Panadol — tablet" and "Panadol — syrup" as two separate rows).
/// This is what makes a same-name, multi-type drug unambiguous the moment
/// the user taps a row.
class DrugSuggestionsPanel extends StatelessWidget {
  final bool isLoading;
  final List<DrugModel> suggestions;
  final Function(DrugModel) onSelect;

  const DrugSuggestionsPanel({
    super.key,
    required this.isLoading,
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSoft : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.gray800 : AppColors.gray100,
        ),
      ),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: isDark ? AppColors.gray800 : AppColors.gray100,
              ),
              itemBuilder: (context, index) {
                final drug = suggestions[index];
                return ListTile(
                  dense: true,
                  title: Text(drug.name),
                  // drug_type_<type> keys, e.g. drug_type_tablet, drug_type_syrup
                  subtitle: Text('drug_type_${drug.type}'.tr()),
                  onTap: () => onSelect(drug),
                );
              },
            ),
    );
  }
}