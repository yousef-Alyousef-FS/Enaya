import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class DoctorSelectorButton extends StatelessWidget {
  final List<DoctorOption> doctors;
  final String? selectedDoctorName;
  final VoidCallback onClearSelection;
  final void Function(DoctorOption doctor) onSelected;

  const DoctorSelectorButton({
    super.key,
    required this.doctors,
    required this.selectedDoctorName,
    required this.onClearSelection,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 60,
      child: OutlinedButton.icon(
        onPressed: () => _openDoctorsSheet(context),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.22)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        ),
        icon: const Icon(Icons.person_search_rounded),
        label: Text(selectedDoctorName ?? "select_doctor".tr(), overflow: TextOverflow.ellipsis),
      ),
    );
  }

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
                                    style: const TextStyle(color: AppColors.gray600),
                                  ),
                                ),
                              )
                            else
                              Flexible(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: doctors.length,
                                  separatorBuilder: (_, __) => const Divider(height: 1),
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
                                      subtitle: Text(doctor.id),
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
  }
}

class DoctorOption {
  final String id;
  final String name;

  const DoctorOption({required this.id, required this.name});
}
