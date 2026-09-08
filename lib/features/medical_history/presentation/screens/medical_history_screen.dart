import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/medical_history_cubit.dart';
import '../cubit/medical_history_state.dart';
import '../widgets/timeline_item.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MedicalHistoryCubit>().loadMedicalHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('medical_history'.tr()), centerTitle: true),
      body: BlocBuilder<MedicalHistoryCubit, MedicalHistoryState>(
        builder: (context, state) {
          if (state is MedicalHistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is MedicalHistoryError) {
            return Center(child: Text(state.message));
          }

          if (state is MedicalHistoryLoaded) {
            if (state.sessions.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<MedicalHistoryCubit>().loadMedicalHistory(),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16, bottom: 32),
                itemCount: state.sessions.length,
                itemBuilder: (context, index) {
                  return TimelineItem(
                    session: state.sessions[index],
                    onTap: () => _openDetail(state.sessions[index]),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 80,
            color: AppColors.gray300,
          ),
          const SizedBox(height: 16),
          Text(
            'no_medical_records'.tr(),
            style: TextStyle(color: AppColors.gray500, fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _openDetail(dynamic session) {
    context.push('/medical-history/detail', extra: session);
  }
}
