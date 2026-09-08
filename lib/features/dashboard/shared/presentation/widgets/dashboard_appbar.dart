import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A reusable AppBar widget designed specifically for the dashboard layout.
/// It supports:
/// - Dynamic title text
/// - Notification icon with badge
/// - User menu (profile, settings, logout)
/// - Localization via easy_localization
/// - Integration with AuthCubit for logout functionality
class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final String? subtitleText;
  final bool showNotifications;
  final bool showUserMenu;
  final int notificationCount;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationsTap;

  const DashboardAppBar({
    super.key,
    this.titleText,
    this.subtitleText,
    this.showNotifications = true,
    this.showUserMenu = true,
    this.notificationCount = 3,
    this.onProfileTap,
    this.onNotificationsTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitleText == null ? 55 : 64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      titleSpacing: 8, // Reduced spacing for better alignment
      leading: showNotifications ? _buildNotificationIcon(context) : null,
      actions: [
        if (showUserMenu) _buildUserMenu(context),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          tooltip: 'notifications'.tr(),
          icon: const Icon(Icons.notifications_none_outlined),
          onPressed:
              onNotificationsTap ??
              () => _showComingSoon(context, 'notifications'.tr()),
        ),
        if (notificationCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: notificationCount > 9 ? 22 : 18,
              height: 18,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: color.surface, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                notificationCount > 9 ? '9+' : '$notificationCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserMenu(BuildContext context) {
    return GestureDetector(
      onTap: onProfileTap ?? () => _showComingSoon(context, 'profile'.tr()),
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: const CircleAvatar(
          radius: 17,
          backgroundImage: NetworkImage(
            'https://i.pravatar.cc/150?u=reception',
          ),
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${'feature_coming_soon'.tr()}: $feature'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
