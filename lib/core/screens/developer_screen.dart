import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routing/app_router.dart';

/// Developer-only shortcut screen used to jump directly into common flows.
class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('developer_sandbox'.tr()),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('developer_authentication'.tr(), [
            _buildItem(context, 'developer_login_screen'.tr(), AppRouter.login),
            _buildItem(context, 'developer_signup_screen'.tr(), AppRouter.signup),
            _buildItem(context, 'developer_forgot_password'.tr(), AppRouter.forgotPassword),
            _buildItem(
              context,
              'developer_verify_email'.tr(),
              '${AppRouter.verifyEmail}?email=test@enaya.com',
            ),
          ]),
          const SizedBox(height: 20),
          _buildSection('developer_dashboards'.tr(), [
            _buildItem(context, 'developer_doctor_dashboard'.tr(), AppRouter.doctorHome),
            _buildItem(context, 'developer_patient_dashboard'.tr(), AppRouter.patientHome),
            _buildItem(
              context,
              'developer_receptionist_dashboard'.tr(),
              AppRouter.receptionistHome,
            ),
          ]),
          const SizedBox(height: 20),
          _buildSection('developer_system_misc'.tr(), [
            _buildItem(context, 'developer_splash_screen'.tr(), AppRouter.splash),
            _buildItem(context, 'developer_no_internet_screen'.tr(), AppRouter.noInternet),
          ]),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'developer_dev_mode_active'.tr(),
              style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  /// Creates one tappable launcher entry for the requested route.
  Widget _buildItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => context.push(route),
    );
  }
}
