import 'package:flutter/material.dart';
import '../models/dashboard_nav_item.dart';

const List<DashboardNavItem> receptionistNavigationItems = [
  DashboardNavItem(
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    labelKey: 'dashboard',
  ),
  DashboardNavItem(icon: Icons.people_outline, selectedIcon: Icons.people, labelKey: 'patients'),
  DashboardNavItem(
    icon: Icons.calendar_today_outlined,
    selectedIcon: Icons.calendar_today,
    labelKey: 'appointments',
  ),
  DashboardNavItem(
    icon: Icons.how_to_reg_outlined,
    selectedIcon: Icons.how_to_reg,
    labelKey: 'queue',
  ),
  DashboardNavItem(
    icon: Icons.note_add_outlined,
    selectedIcon: Icons.note_add,
    labelKey: 'registrations',
    showDividerAfter: true,
  ),
  DashboardNavItem(
    icon: Icons.receipt_outlined,
    selectedIcon: Icons.receipt,
    labelKey: 'billing',
    isEnabled: false,
  ),
  DashboardNavItem(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    labelKey: 'settings',
    isEnabled: false,
  ),
];

const List<DashboardNavItem> doctorNavigationItems = [
  DashboardNavItem(
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    labelKey: 'today_overview',
  ),
  DashboardNavItem(
    icon: Icons.calendar_today_outlined,
    selectedIcon: Icons.calendar_today,
    labelKey: 'appointments_title',
  ),
  DashboardNavItem(
    icon: Icons.access_time,
    selectedIcon: Icons.access_time_filled,
    labelKey: 'doctor_work_schedule',
    showDividerAfter: true,
  ),
  DashboardNavItem(
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
    labelKey: 'patients_management',
    isEnabled: false,
  ),
  DashboardNavItem(
    icon: Icons.receipt_outlined,
    selectedIcon: Icons.receipt,
    labelKey: 'billing_payments',
    isEnabled: false,
  ),
  DashboardNavItem(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    labelKey: 'settings',
    isEnabled: false,
  ),
];

const List<DashboardNavItem> patientNavigationItems = [
  DashboardNavItem(
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    labelKey: 'today_overview',
  ),
  DashboardNavItem(
    icon: Icons.calendar_today_outlined,
    selectedIcon: Icons.calendar_today,
    labelKey: 'appointments_title',
    showDividerAfter: true,
  ),
  DashboardNavItem(
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
    labelKey: 'patients_management',
    isEnabled: false,
  ),
  DashboardNavItem(
    icon: Icons.receipt_outlined,
    selectedIcon: Icons.receipt,
    labelKey: 'billing_payments',
    isEnabled: false,
  ),
  DashboardNavItem(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    labelKey: 'settings',
    isEnabled: false,
  ),
];
