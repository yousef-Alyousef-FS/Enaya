import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/services/patient_session.dart';
import '../../../data/models/appointments_overview_view_mode.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../cubit/list/patient_appointments_cubit.dart';
import '../../cubit/list/patient_appointments_state.dart';
import '../../widgets/shared/appointment_card.dart';

class PatientAppointmentHistoryScreen extends StatefulWidget {
  const PatientAppointmentHistoryScreen({super.key});

  @override
  State<PatientAppointmentHistoryScreen> createState() =>
      _PatientAppointmentHistoryScreenState();
}

class _PatientAppointmentHistoryScreenState
    extends State<PatientAppointmentHistoryScreen> {
  AppointmentStatus? _statusFilter;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final patientId = PatientSession().patientId;
      if (patientId != null) {
        context.read<PatientAppointmentsCubit>().loadNextPage(patientId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('appointments_history'.tr()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterBar(theme),
          Expanded(
            child:
                BlocBuilder<PatientAppointmentsCubit, PatientAppointmentsState>(
                  builder: (context, state) {
                    final history = state.pastAppointments.where((app) {
                      if (_statusFilter == null) return true;
                      return app.status == _statusFilter;
                    }).toList();

                    if (state.status == PatientAppointmentsStatus.loading &&
                        history.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (history.isEmpty) {
                      return _buildEmptyState();
                    }

                    final patientId = PatientSession().patientId;
                    if (patientId == null)
                      return const Center(child: Text('Session Error'));

                    return RefreshIndicator(
                      onRefresh: () => context
                          .read<PatientAppointmentsCubit>()
                          .loadAppointments(patientId),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            history.length + (state.isPageLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == history.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: AppointmentCard(
                              appointment: history[index],
                              mode: AppointmentsOverviewMode.patient,
                              layout: AppointmentCardLayout.compact,
                              onTap: () =>
                                  _openDetails(context, history[index]),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ThemeData theme) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FilterChip(
            label: 'all'.tr(),
            isSelected: _statusFilter == null,
            onTap: () => setState(() => _statusFilter = null),
          ),
          _FilterChip(
            label: 'completed'.tr(),
            isSelected: _statusFilter == AppointmentStatus.completed,
            onTap: () =>
                setState(() => _statusFilter = AppointmentStatus.completed),
          ),
          _FilterChip(
            label: 'cancelled'.tr(),
            isSelected: _statusFilter == AppointmentStatus.cancelled,
            onTap: () =>
                setState(() => _statusFilter = AppointmentStatus.cancelled),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 64,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'no_appointments_found'.tr(),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _openDetails(BuildContext context, dynamic appointment) {
    context.push(
      '/appointments/details',
      extra: {
        'appointment': appointment,
        'role': AppointmentsOverviewMode.patient,
        'onDataChanged': () {
          final patientId = PatientSession().patientId;
          if (patientId != null) {
            context.read<PatientAppointmentsCubit>().loadAppointments(
              patientId,
            );
          }
        },
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: theme.colorScheme.primaryContainer,
      ),
    );
  }
}
