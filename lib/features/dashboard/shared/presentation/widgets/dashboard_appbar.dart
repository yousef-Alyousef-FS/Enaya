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
  final bool showNotifications;
  final bool showUserMenu;

  const DashboardAppBar({
    super.key,
    this.titleText,
    this.showNotifications = true,
    this.showUserMenu = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 56,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 1,
      centerTitle: true,

      /// Page title (defaults to "Today Overview")
      title: Text(
        titleText ?? 'today_overview'.tr(),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      /// Right-side actions (notifications + user menu)
      actions: [
        if (showNotifications) _buildNotificationIcon(context),
        if (showUserMenu) _buildUserMenu(context),
        const SizedBox(width: 12),
      ],
    );
  }

  /// Builds the notification icon with a small red badge.
  /// Currently shows a static "3" as a placeholder.
  Widget _buildNotificationIcon(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined),
          onPressed: () => _showComingSoon(context, 'notifications'.tr()),
        ),

        /// Notification badge
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
            constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
            child: const Text(
              '3',
              style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the user menu (profile, settings, logout).
  /// Logout triggers the AuthCubit.
  Widget _buildUserMenu(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      icon: const CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=reception'),
        backgroundColor: Colors.grey,
      ),
      onSelected: (value) {
        if (value == 'logout') {
          /// Trigger logout from AuthCubit
          context.read<AuthCubit>().logout();
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

  /// Shows a "Coming Soon" snackbar for unimplemented features.
  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${'feature_coming_soon'.tr()}: $feature'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
