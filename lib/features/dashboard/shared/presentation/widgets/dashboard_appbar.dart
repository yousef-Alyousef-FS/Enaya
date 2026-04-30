import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';

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

  const DashboardAppBar({
    super.key,
    this.titleText,
    this.subtitleText,
    this.showNotifications = true,
    this.showUserMenu = true,
    this.notificationCount = 3,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitleText == null ? 64 : 76);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      titleSpacing: 20,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            titleText ?? 'today_overview'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.3),
          ),
          if (subtitleText != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitleText!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),

      actions: [
        if (showNotifications) _buildNotificationIcon(context),
        if (showUserMenu) _buildUserMenu(context),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          tooltip: 'notifications'.tr(),
          icon: const Icon(Icons.notifications_none_outlined),
          onPressed: () => _showComingSoon(context, 'notifications'.tr()),
        ),

        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1.5),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                notificationCount > 9 ? '9+' : '$notificationCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserMenu(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      tooltip: 'profile'.tr(),
      icon: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 1),
        ),
        child: const CircleAvatar(
          radius: 17,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=reception'),
          backgroundColor: Colors.grey,
        ),
      ),
      onSelected: (value) {
        if (value == 'logout') {
          try {
            context.read<AuthCubit>().logout();
          } catch (e) {
            // AuthCubit not provided in the current context - fallback
            _showComingSoon(context, 'logout'.tr());
          }
        } else {
          _showComingSoon(context, value.tr());
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: _menuItem(Icons.account_circle_outlined, 'profile'.tr()),
        ),
        PopupMenuItem(
          value: 'settings',
          child: _menuItem(Icons.settings_outlined, 'settings'.tr()),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: _menuItem(Icons.logout, 'logout'.tr(), color: Colors.red),
        ),
      ],
    );
  }

  /// Helper widget to build a menu item with icon + label.
  Widget _menuItem(IconData icon, String label, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
      ],
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
