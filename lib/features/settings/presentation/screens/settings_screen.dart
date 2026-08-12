import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/language/language_manager.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/services/settings_service.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class SettingsScreen extends StatelessWidget {
  final bool showAppBar;

  const SettingsScreen({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    final content = ListView(
      children: [
        // ====== Appearance Section ======
        _SettingsHeader(title: 'appearance'.tr()),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final isDark = state.themeMode == ThemeMode.dark;
            return SwitchListTile.adaptive(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              value: isDark,
              onChanged: (_) {
                context.read<ThemeCubit>().setThemeMode(
                  isDark ? ThemeMode.light : ThemeMode.dark,
                );
              },
              title: Text('dark_mode'.tr()),
              subtitle: Text(isDark ? 'enabled'.tr() : 'disabled'.tr()),
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            );
          },
        ),

        const Divider(height: 1),

        // ====== Language Section ======
        _SettingsHeader(title: 'language'.tr()),
        ListTile(
          dense: true,
          leading: const Icon(Icons.language),
          title: Text('change_language'.tr()),
          subtitle: Text(
            '${'current_language'.tr()}: '
            '${currentLocale.languageCode == 'ar' ? 'arabic'.tr() : 'english'.tr()}',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguagePicker(context),
        ),

        const Divider(height: 1),

        // ====== Account Section ======
        _SettingsHeader(title: 'account'.tr()),
        ListTile(
          dense: true,
          leading: const Icon(Icons.logout, color: Colors.red),
          title: Text(
            'logout'.tr(),
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () => _showLogoutConfirmation(context),
        ),
        const Divider(height: 1),
      ],
    );

    if (!showAppBar) return content;

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr()), centerTitle: true),
      body: content,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logout'.tr()),
        content: Text('logout_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              context.read<AuthCubit>().logout();
              context.go(AppRouter.login);
            },
            child: Text(
              'logout'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final currentLocale = context.locale;

    final selectedLocale = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.translate),
              title: Text('arabic'.tr()),
              trailing: currentLocale.languageCode == 'ar'
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () => Navigator.pop(context, arabicLocale),
            ),
            ListTile(
              leading: const Icon(Icons.translate),
              title: Text('english'.tr()),
              trailing: currentLocale.languageCode == 'en'
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () => Navigator.pop(context, englishLocale),
            ),
          ],
        );
      },
    );

    if (selectedLocale != null && context.mounted) {
      await context.setLocale(selectedLocale);
      if (context.mounted) {
        await getIt<SettingsService>().saveLanguage(
          selectedLocale.languageCode,
        );
      }
    }
  }
}

class _SettingsHeader extends StatelessWidget {
  final String title;

  const _SettingsHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
