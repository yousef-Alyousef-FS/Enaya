import 'package:flutter/material.dart';

import '../models/dashboard_nav_item.dart';

const List<DashboardNavItem> receptionistNavigationItems = [
  DashboardNavItem(
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    labelKey: 'nav_overview',
  ),
  DashboardNavItem(
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
    labelKey: 'nav_patients',
  ),
  DashboardNavItem(
    icon: Icons.calendar_today_outlined,
    selectedIcon: Icons.calendar_today,
    labelKey: 'nav_appointments',
  ),
  DashboardNavItem(
    icon: Icons.how_to_reg_outlined,
    selectedIcon: Icons.how_to_reg,
    labelKey: 'nav_queue',
  ),
  DashboardNavItem(
    icon: Icons.note_add_outlined,
    selectedIcon: Icons.note_add,
    labelKey: 'nav_registrations',
    showDividerAfter: true,
  ),
  DashboardNavItem(
    icon: Icons.receipt_outlined,
    selectedIcon: Icons.receipt,
    labelKey: 'nav_billing',
    isEnabled: false,
  ),
  DashboardNavItem(
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    labelKey: 'nav_profile',
  ),
  DashboardNavItem(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    labelKey: 'nav_settings',
  ),
];

const List<DashboardNavItem> doctorNavigationItems = [
  DashboardNavItem(
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    labelKey: 'nav_overview',
  ),
  DashboardNavItem(
    icon: Icons.calendar_today_outlined,
    selectedIcon: Icons.calendar_today,
    labelKey: 'nav_appointments',
  ),
  DashboardNavItem(
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
    labelKey: 'nav_patients',
    showDividerAfter: true,
  ),
  DashboardNavItem(
    icon: Icons.analytics_outlined,
    selectedIcon: Icons.analytics,
    labelKey: 'nav_reports',
    isEnabled: false,
  ),
  DashboardNavItem(
    icon: Icons.receipt_outlined,
    selectedIcon: Icons.receipt,
    labelKey: 'nav_billing',
    isEnabled: false,
  ),
  DashboardNavItem(
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    labelKey: 'nav_profile',
  ),
  DashboardNavItem(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    labelKey: 'nav_settings',
  ),
];

const List<DashboardNavItem> patientNavigationItems = [
  DashboardNavItem(
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    labelKey: 'nav_overview',
  ),
  DashboardNavItem(
    icon: Icons.calendar_today_outlined,
    selectedIcon: Icons.calendar_today,
    labelKey: 'nav_appointments',
    showDividerAfter: true,
  ),
  DashboardNavItem(
    icon: Icons.description_outlined,
    selectedIcon: Icons.description,
    labelKey: 'nav_records',
  ),
  DashboardNavItem(
    icon: Icons.receipt_outlined,
    selectedIcon: Icons.receipt,
    labelKey: 'nav_billing',
    isEnabled: false,
  ),
  DashboardNavItem(
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    labelKey: 'nav_profile',
  ),
  DashboardNavItem(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    labelKey: 'nav_settings',
  ),
];
