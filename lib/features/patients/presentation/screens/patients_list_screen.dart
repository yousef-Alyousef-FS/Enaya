import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../domain/entities/patient_entity.dart';
import '../state/patients_cubit.dart';
import '../state/patients_state.dart';

class PatientsListScreen extends StatefulWidget {
  final bool embedded;
  final bool readOnly;
  final String? doctorId;

  const PatientsListScreen({
    super.key,
    this.embedded = false,
    this.readOnly = false,
    this.doctorId,
  });

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatientsCubit>().loadPatients(doctorId: widget.doctorId);
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
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'patients'.tr(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => context.read<PatientsCubit>().loadPatients(
                    doctorId: widget.doctorId,
                  ),
                  tooltip: 'refresh'.tr(),
                ),
                if (!widget.readOnly)
                  IconButton.filledTonal(
                    icon: const Icon(Icons.person_add, size: 20),
                    onPressed: _openRegistration,
                    tooltip: 'register_new_patient'.tr(),
                  ),
              ],
            ),
          ),
          Expanded(child: listContent),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('patients'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PatientsCubit>().loadPatients(
              doctorId: widget.doctorId,
            ),
          ),
        ],
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
          padding: const EdgeInsets.all(16.0),
          child: SearchBar(
            hintText: 'search_patient'.tr(),
            leading: const Icon(Icons.search),
            onChanged: (query) =>
                context.read<PatientsCubit>().searchPatients(query),
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(
              scheme.surfaceContainerHighest.withAlpha(isDark ? 80 : 150),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: scheme.error),
                      const SizedBox(height: 16),
                      Text(state.errorMessage ?? 'unknown_error'.tr()),
                      TextButton(
                        onPressed: () => context
                            .read<PatientsCubit>()
                            .loadPatients(doctorId: widget.doctorId),
                        child: Text('retry'.tr()),
                      ),
                    ],
                  ),
                );
              }

              if (state.patients.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: scheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_patients_found'.tr(),
                        style: TextStyle(color: scheme.outline),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => context.read<PatientsCubit>().loadPatients(
                  doctorId: widget.doctorId,
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  itemCount: state.patients.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final patient = state.patients[index];
                    return _PatientCard(
                      patient: patient,
                      onTap: () => _openPatientDetails(patient),
                    );
                  },
                ),
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

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant.withAlpha(100)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: scheme.primaryContainer,
                child: Text(
                  _getInitials(patient.name),
                  style: TextStyle(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
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
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: scheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          patient.phone,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.outline),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }
}
