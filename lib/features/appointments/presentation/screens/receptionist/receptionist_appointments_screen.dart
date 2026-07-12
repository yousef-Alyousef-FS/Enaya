import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/app_router.dart';
import '../../cubit/list/receptionist_appointments_cubit.dart';
import '../../cubit/list/receptionist_appointments_state.dart';
import '../../widgets/receptionist/appointment_table_config.dart';
import '../../widgets/tables/generic_table.dart';

import '../../../data/models/appointments_overview_view_mode.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_entity.dart';
import 'package:enaya/features/appointments/presentation/widgets/receptionist/appointments_filter.dart';
import '../../widgets/shared/appointments_feedback_state.dart';
import '../../widgets/receptionist/receptionist_stats_grid.dart';
import '../../../../../core/widgets/common/shimmer_loading.dart';
import '../../../../../core/widgets/common/responsive_stats_grid.dart';

/// [ARCH_FLAG]: Admin/Receptionist focal point for medical facility management.
/// Integrates filtering, statistical grids, and a configurable data table.
class ReceptionistAppointmentsScreen extends StatelessWidget {
  /// Whether it's embedded in another scrollable view (e.g., Home Page).
  final bool isEmbedded;

  /// Keeps the search/filter row visible inside embedded dashboard content.
  final bool showFiltersWhenEmbedded;

  const ReceptionistAppointmentsScreen({
    super.key,
    this.isEmbedded = false,
    this.showFiltersWhenEmbedded = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceptionistAppointmentsCubit, ReceptionistAppointmentsState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        final content = Center(
          child: Container(
            constraints: isEmbedded ? null : const BoxConstraints(maxWidth: 1400),
            child: ListView(
              padding: isEmbedded
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              shrinkWrap: isEmbedded,
              physics: isEmbedded
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              children: [
                _buildStatsSection(state),
                const SizedBox(height: 16),
                _buildErrorSection(context, state),
                _buildFilterSection(state),
                _buildTableSection(context, state),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );

        if (isEmbedded) return content;

        return Scaffold(
          body: content,
          floatingActionButton: _buildFab(context, theme),
        );
      },
    );
  }

  /// 1. Stats Section (Shimmer while loading)
  Widget _buildStatsSection(ReceptionistAppointmentsState state) {
    if (isEmbedded) return const SizedBox.shrink();

    return Column(
      children: [
        if (state.stats != null)
          ReceptionistStatsGrid(data: state.stats!)
        else
          ResponsiveStatsGrid(
            children: List.generate(
              4,
              (_) => const SkeletonLoader(width: double.infinity, height: 100),
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  /// 2. Inline Error Section
  Widget _buildErrorSection(BuildContext context, ReceptionistAppointmentsState state) {
    if (state.errorMessage == null) return const SizedBox.shrink();

    return Column(
      children: [
        AppointmentsInlineError(
          message: state.errorMessage,
          onRetry: () => context.read<ReceptionistAppointmentsCubit>().refreshCurrentView(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// 3. Filter Section
  Widget _buildFilterSection(ReceptionistAppointmentsState state) {
    if (isEmbedded && !showFiltersWhenEmbedded) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppointmentsFilterWidget(
        appointments: state.appointments,
        showDateRange: !isEmbedded,
        showStatusChips: !isEmbedded,
        showSearch: true,
        showDoctorSelector: true,
      ),
    );
  }

  /// 4. Table / Empty State Section
  Widget _buildTableSection(BuildContext context, ReceptionistAppointmentsState state) {
    if (!state.isLoading && state.errorMessage == null && state.filteredAppointments.isEmpty) {
      return AppointmentsInlineEmpty(
        title: 'no_appointments_found'.tr(),
        subtitle: _getEmptySubtitle(state),
        icon: Icons.filter_alt_off_outlined,
      );
    }

    return GenericTableShell<AppointmentEntity>(
      data: state.filteredAppointments,
      isLoading: state.isLoading,
      isPageLoading: state.isPageLoading, // [API_READY]: Pass pagination state
      onRowTap: (app) => _onViewAppointment(context, app),
      onRowLongPress: (app) => _onViewAppointment(context, app),
      onLoadMore: () => context.read<ReceptionistAppointmentsCubit>().loadNextPage(),
      // [CONFIG_FLAG]: Table schema is abstracted in AppointmentTableConfig to keep Screen file focused on layout.
      columns: AppointmentTableConfig.build(
        context: context,
        appointments: state.filteredAppointments,
        onView: (app) => _onViewAppointment(context, app),
        onEdit: (app) => _onEditAppointment(context, app),
        onStatusChange: (app, status, reason) =>
            context.read<ReceptionistAppointmentsCubit>().updateStatus(
                  app.id,
                  status,
                  reason: reason,
                ),
      ),
    );
  }

  String _getEmptySubtitle(ReceptionistAppointmentsState state) {
    final selected = state.filter.startDate;
    final now = DateTime.now();
    final isToday = now.year == selected.year &&
        now.month == selected.month &&
        now.day == selected.day;

    if (isToday) return 'adjust_filters_to_find_appointments'.tr();
    return '${DateFormat.yMMMd('en_US').format(selected)} • ${'adjust_filters_to_find_appointments'.tr()}';
  }

  void _onViewAppointment(BuildContext context, AppointmentEntity app) {
    context.push(
      AppRouter.appointmentDetails,
      extra: {
        'appointment': app,
        'role': AppointmentsOverviewMode.receptionist,
        'onDataChanged': () => context.read<ReceptionistAppointmentsCubit>().refreshCurrentView(),
      },
    );
  }

  Future<void> _onEditAppointment(BuildContext context, AppointmentEntity app) async {
    final result = await context.push(
      AppRouter.editAppointment,
      extra: {'appointment': app},
    );

    if (result == true && context.mounted) {
      context.read<ReceptionistAppointmentsCubit>().refreshCurrentView();
    }
  }

  Widget _buildFab(BuildContext context, ThemeData theme) {
    return FloatingActionButton.extended(
      onPressed: () => context.push(AppRouter.scheduleAppointment),
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.8),
      elevation: 4,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: Text(
        'new_appointment'.tr(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
