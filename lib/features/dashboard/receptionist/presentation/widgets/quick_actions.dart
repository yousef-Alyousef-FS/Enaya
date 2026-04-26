import 'package:flutter/material.dart';
import 'package:enaya/core/helpers/responsive_helper.dart';
import 'package:enaya/core/theme/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final width = isMobile ? double.infinity : 200.0;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _action(
          context,
          width,
          title: 'Register New Patient',
          icon: Icons.person_add_alt_1_rounded,
          color: AppColors.primary,
          onTap: () {},
        ),
        _action(
          context,
          width,
          title: 'Confirm Check-in',
          icon: Icons.check_circle_rounded,
          color: AppColors.medicalGreen,
          onTap: () {},
        ),
        _action(
          context,
          width,
          title: 'Search Patient',
          icon: Icons.search_rounded,
          color: AppColors.accent,
          onTap: () {},
        ),
        _action(
          context,
          width,
          title: 'View Appointments',
          icon: Icons.calendar_today_rounded,
          color: AppColors.primaryDark,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _action(
    BuildContext context,
    double width, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withAlpha((0.12 * 255).round()),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gray200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.03 * 255).round()),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha((0.12 * 255).round()),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
