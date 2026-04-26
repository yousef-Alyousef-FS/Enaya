import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:enaya/core/helpers/responsive_helper.dart';

enum ReceptionistDashboardSection {
  dashboard,
  patients,
  appointments,
  checkIn,
  registrations,
  billing,
  settings,
}

class ReceptionistSideNavigation extends StatelessWidget {
  final ReceptionistDashboardSection selectedSection;
  final ValueChanged<ReceptionistDashboardSection> onSectionSelected;

  const ReceptionistSideNavigation({
    super.key,
    required this.selectedSection,
    required this.onSectionSelected,
  });

  static const double desktopWidth = 240;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop || context.isTablet;

    return Container(
      width: isDesktop ? desktopWidth : null,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: BorderDirectional(end: BorderSide(color: Theme.of(context).dividerColor, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'enaya_reception'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'receptionist_workspace'.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: _navigationItems(
                    context,
                  ).map((item) => _buildNavigationItem(context, item)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_NavigationItem> _navigationItems(BuildContext context) {
    return [
      _NavigationItem(
        section: ReceptionistDashboardSection.dashboard,
        titleKey: 'dashboard',
        icon: Icons.dashboard,
      ),
      _NavigationItem(
        section: ReceptionistDashboardSection.patients,
        titleKey: 'patients',
        icon: Icons.person_search,
      ),
      _NavigationItem(
        section: ReceptionistDashboardSection.appointments,
        titleKey: 'appointments',
        icon: Icons.calendar_month,
      ),
      _NavigationItem(
        section: ReceptionistDashboardSection.checkIn,
        titleKey: 'check_in',
        icon: Icons.person_add_alt_1,
      ),
      _NavigationItem(
        section: ReceptionistDashboardSection.registrations,
        titleKey: 'registrations',
        icon: Icons.how_to_reg,
      ),
      _NavigationItem(
        section: ReceptionistDashboardSection.billing,
        titleKey: 'billing',
        icon: Icons.receipt_long,
      ),
      _NavigationItem(
        section: ReceptionistDashboardSection.settings,
        titleKey: 'settings',
        icon: Icons.settings,
      ),
    ];
  }

  Widget _buildNavigationItem(BuildContext context, _NavigationItem item) {
    final isSelected = item.section == selectedSection;
    final accentColor = Theme.of(context).colorScheme.primary;
    final selectedTextColor = Theme.of(context).colorScheme.onPrimary;
    final backgroundColor = isSelected
        ? accentColor
        : Theme.of(context).colorScheme.surfaceContainerHighest;
    final contentColor = isSelected ? selectedTextColor : Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onSectionSelected(item.section),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: AlignmentDirectional.centerStart,
            child: Row(
              children: [
                Icon(item.icon, color: contentColor, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.titleKey.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: contentColor,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  final ReceptionistDashboardSection section;
  final String titleKey;
  final IconData icon;

  _NavigationItem({required this.section, required this.titleKey, required this.icon});
}
