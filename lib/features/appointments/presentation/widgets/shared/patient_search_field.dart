import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../patients/domain/entities/patient_entity.dart';
import '../../../../patients/domain/usecases/search_patients_usecase.dart';

/// A searchable patient selection field with autocomplete and quick-add.
///
/// Allows users to search for and select a patient from a list or register
/// a new patient on-the-fly. Once selected, displays a compact chip summary
/// with patient name and phone. Includes clear (X) button to reset selection.
///
/// Callbacks:
/// - [onPatientSelected]: Called when a patient is chosen from search results
/// - [onAddPatient]: Called when user wants to register a new patient
/// - [onClearPatient]: Called when user clicks the clear button
class PatientSearchField extends StatefulWidget {
  final Function(PatientEntity) onPatientSelected;
  final VoidCallback? onAddPatient;
  final VoidCallback? onClearPatient;
  final PatientEntity? initialPatient;
  final bool showLabel;
  final double? height;

  const PatientSearchField({
    super.key,
    required this.onPatientSelected,
    this.onAddPatient,
    this.onClearPatient,
    this.initialPatient,
    this.showLabel = true,
    this.height,
  });

  @override
  State<PatientSearchField> createState() => _PatientSearchFieldState();
}

class _PatientSearchFieldState extends State<PatientSearchField> {
  bool _isLoading = false;
  PatientEntity? _selectedPatient;
  final TextEditingController _localController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialPatient != null) {
      _selectedPatient = widget.initialPatient;
      _localController.text = widget.initialPatient!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            'select_patient'.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (_selectedPatient == null)
          LayoutBuilder(
            builder: (context, constraints) {
              final double fieldHeight =
                  widget.height ??
                  (constraints.maxHeight.isFinite
                      ? constraints.maxHeight
                      : 48.0);

              return Autocomplete<PatientEntity>(
                displayStringForOption: (PatientEntity p) => p.name,
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text.length < 2) {
                    if (_isLoading && mounted) {
                      setState(() => _isLoading = false);
                    }
                    return const Iterable.empty();
                  }

                  if (!_isLoading && mounted) {
                    setState(() => _isLoading = true);
                  }
                  final result = await getIt<SearchPatientsUseCase>().call(
                    SearchPatientsParams(query: textEditingValue.text),
                  );
                  if (mounted && _isLoading) {
                    setState(() => _isLoading = false);
                  }
                  return result.fold(
                    (_) => const Iterable.empty(),
                    (patients) => patients,
                  );
                },
                onSelected: (PatientEntity patient) {
                  setState(() => _selectedPatient = patient);
                  widget.onPatientSelected(patient);
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      // ensure initial text is forwarded to the autocomplete controller
                      if (_localController.text.isNotEmpty &&
                          controller.text.isEmpty) {
                        controller.text = _localController.text;
                      }

                      final textField = TextField(
                        controller: controller,
                        focusNode: focusNode,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'search_patient_hint'.tr(),
                          prefixIcon: Icon(
                            Icons.person_search,
                            color: colorScheme.primary,
                          ),
                          suffixIcon: _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.person_add),
                                      onPressed: () async {
                                        if (widget.onAddPatient != null) {
                                          widget.onAddPatient!();
                                        } else {
                                          await context.push(
                                            AppRouter.patientRegistration,
                                          );
                                        }
                                      },
                                      tooltip: 'add_patient'.tr(),
                                    ),
                                  ],
                                ),
                          filled: true,
                          fillColor: colorScheme.surface,
                          constraints: BoxConstraints.tightFor(
                            height: fieldHeight,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 1.3,
                            ),
                          ),
                        ),
                      );

                      return SizedBox(height: fieldHeight, child: textField);
                    },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      color: colorScheme.surface,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 300,
                          maxWidth: 520,
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final PatientEntity option = options.elementAt(
                              index,
                            );
                            return ListTile(
                              title: Text(
                                option.name,
                                style: TextStyle(color: colorScheme.onSurface),
                              ),
                              subtitle: Text(
                                option.phone,
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        // Selected patient summary replaces the search field
        if (_selectedPatient != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(
                      _selectedPatient!.name.isNotEmpty
                          ? _selectedPatient!.name[0]
                          : '?',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedPatient!.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedPatient!.phone,
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      setState(() {
                        _selectedPatient = null;
                        _localController.clear();
                      });
                      if (widget.onClearPatient != null)
                        widget.onClearPatient!();
                    },
                    tooltip: 'clear'.tr(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
