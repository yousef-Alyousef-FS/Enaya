import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/dialogs/app_dialogs.dart';
import '../../../medical_history/presentation/cubit/medical_history_cubit.dart';
import '../../../medical_history/presentation/cubit/medical_history_state.dart';
import '../../domain/entities/patient_entity.dart';
import '../state/patients_cubit.dart';
import '../state/patients_state.dart';

class PatientDetailsScreen extends StatefulWidget {
  final PatientEntity patient;
  final bool readOnly;

  const PatientDetailsScreen({super.key, required this.patient, this.readOnly = false});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  late PatientEntity _patient;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
    context.read<MedicalHistoryCubit>().loadMedicalHistory(patientId: _patient.id);
  }

  void _openEdit() async {
    final updated = await context.push<PatientEntity>(AppRouter.editPatient, extra: _patient);
    if (updated != null && mounted) {
      setState(() => _patient = updated);
      context.read<PatientsCubit>().loadPatients();
    }
  }

  void _deletePatient() {
    AppDialogs.showConfirm(
      context,
      title: 'confirm_delete'.tr(),
      message: 'delete_patient_confirmation'.tr(),
      isDanger: true,
      onConfirm: () async {
        await context.read<PatientsCubit>().deletePatient(_patient.id);
        if (mounted) context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return BlocListener<PatientsCubit, PatientsState>(
      listener: (context, state) {
        if (state.isSuccess && state.successMessage == 'patient_deleted_success') {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('patient_details'.tr()),
          actions: [
            if (!widget.readOnly) ...[
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: _openEdit,
                tooltip: 'edit'.tr(),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: _deletePatient,
                tooltip: 'delete'.tr(),
              ),
            ],
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(theme, scheme),
              const SizedBox(height: 24),
              _buildInfoSection(
                theme,
                scheme,
                title: 'personal_information'.tr(),
                icon: Icons.person_outline,
                children: [
                  _buildInfoRow('email'.tr(), _patient.email ?? 'not_available'.tr()),
                  _buildInfoRow('phone_number'.tr(), _patient.phone),
                  _buildInfoRow('address'.tr(), _patient.address ?? 'not_available'.tr()),
                  _buildInfoRow(
                    'date_of_birth'.tr(),
                    _patient.dateOfBirth != null
                        ? DateFormat('yyyy-MM-dd').format(_patient.dateOfBirth!)
                        : 'not_available'.tr(),
                  ),
                  _buildInfoRow('gender'.tr(), _patient.gender?.tr() ?? 'not_available'.tr()),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoSection(
                theme,
                scheme,
                title: 'emergency_information'.tr(),
                icon: Icons.emergency_outlined,
                children: [
                  _buildInfoRow(
                    'emergency_contact'.tr(),
                    _patient.emergencyContact ?? 'not_available'.tr(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildMedicalHistorySection(theme, scheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalHistorySection(ThemeData theme, ColorScheme scheme) {
    return BlocBuilder<MedicalHistoryCubit, MedicalHistoryState>(
      builder: (context, state) {
        final sessions = state is MedicalHistoryLoaded ? state.sessions : const [];

        return _buildInfoSection(
          theme,
          scheme,
          title: 'medical_history'.tr(),
          icon: Icons.history_edu_rounded,
          children: [
            if (state is MedicalHistoryLoading)
              const Center(child: CircularProgressIndicator(strokeWidth: 2))
            else if (state is MedicalHistoryError)
              Text(state.message, style: TextStyle(color: scheme.error))
            else if (sessions.isEmpty)
              Text('no_medical_records'.tr(), style: TextStyle(color: scheme.onSurfaceVariant))
            else ...[
              for (final session in sessions.take(3))
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withAlpha(80),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.diagnosis ?? 'no_diagnosis'.tr(),
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        session.patientComplaint ?? 'patient_complaint'.tr(),
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.startedAt != null
                            ? DateFormat('dd MMM yyyy').format(session.startedAt!)
                            : 'not_available'.tr(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme scheme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: scheme.primaryContainer,
          child: Text(
            _getInitials(_patient.name),
            style: theme.textTheme.displayMedium?.copyWith(
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _patient.name,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (_patient.job != null && _patient.job!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(_patient.job!, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.outline)),
        ],
      ],
    );
  }

  Widget _buildInfoSection(
    ThemeData theme,
    ColorScheme scheme, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant.withAlpha(100)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }
}
