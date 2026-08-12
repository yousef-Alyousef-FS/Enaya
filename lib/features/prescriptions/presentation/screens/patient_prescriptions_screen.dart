import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/theme/app_colors.dart';
import 'package:enaya/features/prescriptions/presentation/cubit/prescription_cubit.dart';
import 'package:enaya/features/prescriptions/presentation/cubit/prescription_state.dart';
import 'package:enaya/features/prescriptions/presentation/screens/prescription_detail_screen.dart';
import 'package:enaya/features/prescriptions/presentation/widgets/prescription_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientPrescriptionsScreen extends StatefulWidget {
  final int sessionId;
  final String? doctorName;

  const PatientPrescriptionsScreen({
    super.key,
    required this.sessionId,
    this.doctorName,
  });

  @override
  State<PatientPrescriptionsScreen> createState() =>
      _PatientPrescriptionsScreenState();
}

class _PatientPrescriptionsScreenState
    extends State<PatientPrescriptionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PrescriptionCubit>().loadPrescriptions(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'prescriptions'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsetsDirectional.only(
                start: 50,
                bottom: 16,
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Icon(
                        Icons.medication_rounded,
                        size: 150,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: BlocBuilder<PrescriptionCubit, PrescriptionState>(
              builder: (context, state) {
                if (state is PrescriptionLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else if (state is PrescriptionLoaded) {
                  final filtered = state.prescriptions
                      .where((p) => p.sessionId == widget.sessionId)
                      .toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_late_outlined,
                            size: 80,
                            color: AppColors.gray300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'no_prescriptions'.tr(),
                            style: TextStyle(
                              color: AppColors.gray500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final prescription = filtered[index];
                      return PrescriptionItemCard(
                        prescription: prescription,
                        onTap: () {
                          final prescriptionCubit = context
                              .read<PrescriptionCubit>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PrescriptionDetailScreen(
                                appointmentId:
                                    0, // Not strictly used for patient view
                                sessionId: widget.sessionId,
                                prescription: prescription,
                                prescriptionCubit: prescriptionCubit,
                                doctorName: widget.doctorName,
                                canEdit: false,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is PrescriptionError) {
                  return Center(
                    child: Text('${'error'.tr()}: ${state.message}'),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
