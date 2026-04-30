import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A reusable pagination control widget.
class AppPaginationControls extends StatelessWidget {
  final int currentPage;
  final bool hasMore;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const AppPaginationControls({
    super.key,
    required this.currentPage,
    required this.hasMore,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(
            onPressed: currentPage > 1 ? onPrevious : null,
            icon: Icons.arrow_back_ios_new_rounded,
            label: 'previous'.tr(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryExtraLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${'page'.tr()} $currentPage',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
            ),
          ),
          _buildButton(
            onPressed: hasMore ? onNext : null,
            icon: Icons.arrow_forward_ios_rounded,
            label: 'next'.tr(),
            isForward: true,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    bool isForward = false,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: onPressed != null ? AppColors.primary : AppColors.gray300),
          borderRadius: BorderRadius.circular(12),
          color: onPressed != null ? Colors.white : AppColors.gray50,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isForward)
              Icon(
                icon,
                size: 16,
                color: onPressed != null ? AppColors.primary : AppColors.gray400,
              ),
            if (!isForward) const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: onPressed != null ? AppColors.primary : AppColors.gray400,
              ),
            ),
            if (isForward) const SizedBox(width: 8),
            if (isForward)
              Icon(
                icon,
                size: 16,
                color: onPressed != null ? AppColors.primary : AppColors.gray400,
              ),
          ],
        ),
      ),
    );
  }
}
