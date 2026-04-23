import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';

class DoctorDashboardPage extends StatelessWidget {
  const DoctorDashboardPage({super.key});

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
            title: const Text('Doctor Dashboard'),
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
                  Icons.medical_services,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome, Doctor!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                const Text(
                  'View patient records, manage appointments, and provide care.',
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
