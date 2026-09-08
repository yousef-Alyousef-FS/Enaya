import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/services/session_manager.dart';
import '../../../../core/widgets/cards/app_base_card.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/entities/patients_overview_mode.dart';
import '../state/patients_cubit.dart';
import '../state/patients_state.dart';

class PatientsListScreen extends StatefulWidget {
  final bool embedded;
  final bool readOnly;
  final String? doctorId;
  final PatientsOverviewMode role;

  const PatientsListScreen({
    super.key,
    this.embedded = false,
    this.readOnly = false,
    this.doctorId,
    this.role = PatientsOverviewMode.receptionist,
  });

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPatients();
    });
  }

  String? _resolvedDoctorId() {
    if (widget.role == PatientsOverviewMode.doctor) {
      return widget.doctorId ?? getIt<SessionManager>().currentUserId ?? 'd1';
    }
    return null;
  }

  void _loadPatients() {
    final doctorId = _resolvedDoctorId();
    context.read<PatientsCubit>().loadPatients(doctorId: doctorId, role: widget.role.name);
  }

  void _openRegistration() {
    context.push(AppRouter.patientRegistration);
  }

  void _openPatientDetails(PatientEntity patient) {
    context.push(
      AppRouter.patientDetails,
      extra: {'patient': patient, 'readOnly': widget.readOnly},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final listContent = _buildListContent(scheme, isDark);

    if (widget.embedded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Expanded(child: listContent)],
      );
    }

    return Scaffold(
      appBar: AppBar(
        // Removed title and refresh button as requested
        centerTitle: true,
      ),
      body: listContent,
      floatingActionButton: widget.readOnly
          ? null
          : FloatingActionButton.extended(
              onPressed: _openRegistration,
              icon: const Icon(Icons.add),
              label: Text('add'.tr()),
            ),
    );
  }

  Widget _buildListContent(ColorScheme scheme, bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  hintText: 'search_patient_hint'.tr(),
                  leading: Icon(Icons.search, color: scheme.primary),
                  onChanged: (query) => context.read<PatientsCubit>().searchPatients(query),
                  elevation: WidgetStateProperty.all(0),
                  backgroundColor: WidgetStateProperty.all(
                    scheme.surfaceContainerHighest.withAlpha(isDark ? 80 : 150),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
                ),
              ),
              if (widget.embedded && !widget.readOnly) ...[
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  icon: const Icon(Icons.person_add, size: 22),
                  onPressed: _openRegistration,
                  tooltip: 'register_new_patient'.tr(),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<PatientsCubit, PatientsState>(
            builder: (context, state) {
              if (state.isLoading && state.patients.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.isError && state.patients.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: scheme.errorContainer.withAlpha(50),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.error_outline, size: 48, color: scheme.error),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'error_loading_patients'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.errorMessage ?? 'unknown_error'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _loadPatients,
                          icon: const Icon(Icons.refresh),
                          label: Text('retry'.tr()),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state.patients.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest.withAlpha(100),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_search_rounded,
                          size: 64,
                          color: scheme.primary.withAlpha(150),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'search_to_find_patients'.tr(),
                        style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'try_adjusting_search'.tr(),
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                itemCount: state.patients.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final patient = state.patients[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PatientCard(
                      patient: patient,
                      onTap: () => _openPatientDetails(patient),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PatientCard extends StatelessWidget {
  final PatientEntity patient;
  final VoidCallback onTap;

  const _PatientCard({required this.patient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppBaseCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: scheme.primary.withAlpha(15),
              shape: BoxShape.circle,
              border: Border.all(color: scheme.primary.withAlpha(30)),
            ),
            child: Center(
              child: Text(
                _getInitials(patient.name),
                style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone_iphone_rounded, size: 14, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(
                      patient.phone,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withAlpha(100),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: scheme.primary.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, parts[0].length > 1 ? 2 : 1).toUpperCase();
  }
}
