import 'package:flutter/material.dart';

/// Configuration for the greeting section at the top of dashboard overview
class GreetingConfig {
   late String? title;
   late String? subtitle;

   GreetingConfig([this.title, this.subtitle]);

}

/// Configuration for a single stat card
class StatCardConfig {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const StatCardConfig({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });
}

/// Configuration for a dashboard overview section
class DashboardOverviewConfig {
   final GreetingConfig? greeting;
   final List<StatCardConfig>? statCards;
   final String? appointmentsSectionTitle;
   final Widget? appointmentsContent;
   final String? featureSectionTitle;
   final Widget? featureContent;
   final bool isMobile;

  const DashboardOverviewConfig({
    this.greeting,
    this.statCards,
    this.appointmentsSectionTitle,
    this.appointmentsContent,
    this.featureSectionTitle,
    this.featureContent,
    this.isMobile = false
  });
}
