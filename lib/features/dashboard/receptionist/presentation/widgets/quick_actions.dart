import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:enaya/core/theme/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        // تحديد عدد الأعمدة بناءً على العرض المتاح
        int crossAxisCount;
        if (maxWidth < 500) {
          crossAxisCount = 1;
        } else if (maxWidth < 720) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 4;
        }

        // المسافات بين البطاقات (spacing, runSpacing)
        const spacing = 15.0;
        // حساب العرض المتاح لكل بطاقة بعد خصم المسافات
        final totalSpacing = spacing * (crossAxisCount - 1);
        final itemWidth = (maxWidth - totalSpacing) / crossAxisCount;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 2.4, // يمكن تعديل النسبة حسب طول النص (مثلاً 3.2 أو 4)
          children: [
            _action(
              context,
              width: itemWidth,
              title: 'register_new_patient'.tr(),
              icon: Icons.person_add_alt_1_rounded,
              color: AppColors.primary,
              onTap: () {},
            ),
            _action(
              context,
              width: itemWidth,
              title: 'confirm_check_in'.tr(),
              icon: Icons.check_circle_rounded,
              color: AppColors.medicalGreen,
              onTap: () {},
            ),
            _action(
              context,
              width: itemWidth,
              title: 'search_patient'.tr(),
              icon: Icons.search_rounded,
              color: AppColors.accent,
              onTap: () {},
            ),
            _action(
              context,
              width: itemWidth,
              title: 'view_appointments'.tr(),
              icon: Icons.calendar_today_rounded,
              color: AppColors.primaryDark,
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  Widget _action(
    BuildContext context, {
    required double width,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width, // أصبح العرض مرنًا ومحسوبًا
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color,
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
      ),
    );
  }
}
