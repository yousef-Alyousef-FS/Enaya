import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';

class PatientDashboardPage extends StatelessWidget {
  const PatientDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isSuccess && state.currentUser == null) {
            context.go(AppRouter.login);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Patient Dashboard'),
            actions: [
              Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: () => context.read<AuthCubit>().logout(),
                );
              }),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome, Patient!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                const Text(
                  'View your medical records, appointments, and health information.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
