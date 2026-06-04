import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Dropdown-like selector for filtering appointments by doctor.
class DoctorSelectorButton extends StatelessWidget {
  /// Available doctors to pick from.
  final List<DoctorOption> doctors;

  /// Currently selected doctor display name.
  final String? selectedDoctorName;

  /// Triggered when user chooses "all doctors".
  final VoidCallback onClearSelection;

  /// Triggered when user selects a specific doctor option.
  final void Function(DoctorOption doctor) onSelected;

  /// Alignment for the button within its parent. Defaults to start (left).
  final AlignmentGeometry alignment;

  const DoctorSelectorButton({
    super.key,
    required this.doctors,
    required this.selectedDoctorName,
    required this.onClearSelection,
    required this.onSelected,
    this.alignment = AlignmentDirectional.centerStart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double controlHeight = 56.0;

    return SizedBox(
      height: controlHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: OutlinedButton.icon(
          onPressed: () => _openDoctorsSheet(context),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(60, controlHeight),
            side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.22)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          ),
          icon: const Icon(Icons.person_search_rounded, size: 20),
          label: Text(
            selectedDoctorName ?? "select_doctor".tr(),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  /// Opens modal doctor picker with a selectable list.
  Future<void> _openDoctorsSheet(BuildContext context) async {
    final theme = Theme.of(context);
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "select_doctor".tr(),
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const SizedBox.expand(),
                ),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520, maxHeight: 520),
                  child: ScaleTransition(
                    scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                    child: FadeTransition(
                      opacity: animation,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'select_doctor'.tr(),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    onClearSelection();
                                    Navigator.pop(context);
                                  },
                                  child: Text('all_doctors'.tr()),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.close_rounded),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (doctors.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: Text(
                                    'no_doctors_available'.tr(),
                                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                                  ),
                                ),
                              )
                            else
                              Flexible(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: doctors.length,
                                  separatorBuilder: (context, index) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final doctor = doctors[index];
                                    final isSelected = doctor.name == selectedDoctorName;

                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundColor: theme.colorScheme.primary.withValues(
                                          alpha: 0.12,
                                        ),
                                        child: Icon(
                                          Icons.medical_services_rounded,
                                          color: theme.colorScheme.primary,
                                          size: 20,
                                        ),
                                      ),
                                      title: Text(doctor.name),
                                      trailing: isSelected
                                          ? Icon(
                                              Icons.check_circle,
                                              color: theme.colorScheme.primary,
                                              size: 22,
                                            )
                                          : null,
                                      onTap: () {
                                        onSelected(doctor);
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // End doctor sheet interaction flow.
  }
}

/// Minimal doctor option model used by [DoctorSelectorButton].
class DoctorOption {
  final String id;
  final String name;

  const DoctorOption({required this.id, required this.name});
}
