import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/presentation/cubit/prescription_cubit.dart';
import 'package:enaya/features/prescriptions/presentation/cubit/prescription_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../cubit/session_cubit.dart';
import '../cubit/session_state.dart';

import '../widgets/complaint_notes_tab.dart';
import '../widgets/diagnosis_tab.dart';
import '../widgets/prescriptions_tab.dart';

class SessionScreen extends StatefulWidget {
  final int appointmentId;

  const SessionScreen({super.key, required this.appointmentId});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  String? editedComplaint;
  String? editedNotes;
  String? editedDiagnosis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<SessionCubit, SessionState>(
      listener: (context, state) {
        if (state is SessionEnded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('success'.tr())),
          );
          context.pop();
        }
      },
      builder: (context, state) {
        if (state is SessionLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        if (state is SessionError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(state.message, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<SessionCubit>().loadOrStartSession(widget.appointmentId),
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is SessionLoaded || state is SessionEnded) {
          final session = (state is SessionLoaded)
              ? state.session
              : (state as SessionEnded).session;

          final prescriptionState = context.watch<PrescriptionCubit>().state;
          final prescriptions = prescriptionState is PrescriptionLoaded
              ? prescriptionState.prescriptions
              : <PrescriptionEntity>[];

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
              appBar: AppBar(
                title: Text(
                  "session_title".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                foregroundColor: isDark ? Colors.white : AppColors.gray900,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.darkSurface,
                              AppColors.darkSurfaceSoft,
                            ]
                          : [
                              const Color(0xFFF8FBFF),
                              const Color(0xFFEAF4FF),
                            ],
                    ),
                  ),
                ),
                bottom: TabBar(
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.gray500,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  splashFactory: InkRipple.splashFactory,
                  overlayColor: WidgetStatePropertyAll(AppColors.primary.withOpacity(0.06)),
                  tabs: [
                    Tab(text: "complaint_notes".tr()),
                    Tab(text: "diagnosis".tr()),
                    Tab(text: "prescriptions".tr()),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  ComplaintNotesTab(
                    session: session,
                    onDataChanged: (complaint, notes) {
                      editedComplaint = complaint;
                      editedNotes = notes;
                    },
                  ),
                  DiagnosisTab(
                    session: session,
                    onDataChanged: (diagnosis) {
                      editedDiagnosis = diagnosis;
                    },
                  ),
                  PrescriptionsTab(
                    appointmentId: session.appointmentId,
                    prescriptions: prescriptions,
                  ),
                ],
              ),
              bottomNavigationBar: (state is SessionLoaded)
                  ? Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          context.read<SessionCubit>().endSession(
                            sessionId: session.id,
                            patientComplaint: editedComplaint ?? session.patientComplaint ?? "",
                            notes: editedNotes ?? session.notes ?? "",
                            diagnosis: editedDiagnosis ?? session.diagnosis ?? "",
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline),
                            const SizedBox(width: 8),
                            Text(
                              "end_session".tr(),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: Text("tap_to_load_session".tr()),
          ),
        );
      },
    );
  }
}
