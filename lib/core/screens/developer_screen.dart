import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routing/app_router.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Sandbox'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Authentication', [
            _buildItem(context, 'Login Screen', AppRouter.login),
            _buildItem(context, 'Signup Screen', AppRouter.signup),
            _buildItem(context, 'Forgot Password', AppRouter.forgotPassword),
            _buildItem(context, 'Verify Email', '${AppRouter.verifyEmail}?email=test@enaya.com'),
          ]),
          const SizedBox(height: 20),
          _buildSection('Dashboards', [
            _buildItem(context, 'Doctor Dashboard', AppRouter.doctorHome),
            _buildItem(context, 'Patient Dashboard', AppRouter.patientHome),
            _buildItem(context, 'Receptionist Dashboard', AppRouter.receptionistHome),
          ]),
          const SizedBox(height: 20),
          _buildSection('Appointments', [
            _buildItem(context, 'Appointments Overview (General)', AppRouter.appointmentsOverview),
            _buildItem(
              context,
              'Appointments (Doctor Mode)',
              '${AppRouter.appointmentsOverview}?mode=doctor',
            ),
            _buildItem(
              context,
              'Appointments (Patient Mode)',
              '${AppRouter.appointmentsOverview}?mode=patient',
            ),
          ]),
          const SizedBox(height: 20),
          _buildSection('System & Misc', [
            _buildItem(context, 'Splash Screen', AppRouter.splash),
            _buildItem(context, 'No Internet Screen', AppRouter.noInternet),
          ]),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Dev Mode is ACTIVE',
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

  Widget _buildItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => context.push(route),
    );
  }
}
