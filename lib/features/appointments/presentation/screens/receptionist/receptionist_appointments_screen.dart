import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/widgets/section_header.dart';
import '../../widgets/receptionist/appointment_table_config.dart';
import '../../widgets/tables/generic_table.dart';
import '../../cubit/appointments_overview_cubit.dart';
import '../../cubit/appointments_overview_state.dart';
import '../../../data/models/appointments_overview_view_mode.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_entity.dart';
import 'package:enaya/features/appointments/presentation/widgets/receptionist/appointments_filter.dart';
import '../../widgets/shared/appointments_feedback_state.dart';
import '../../widgets/receptionist/receptionist_stats_grid.dart';

/// Receptionist-facing appointments overview with filters, stats, and table actions.
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
    return BlocBuilder<AppointmentsManagerCubit, AppointmentsOverviewState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        final content = Center(
          child: Container(
            constraints: isEmbedded ? null : const BoxConstraints(maxWidth: 1400),
            child: ListView(
              padding: isEmbedded
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              shrinkWrap: isEmbedded,
              physics: isEmbedded
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              children: [
                // 1. Stats Sections (Only in standalone page)
                if (!isEmbedded) ...[
                  if (state.stats != null)
                    ReceptionistStatsGrid(data: state.stats!)
                  else
                    const Center(child: LinearProgressIndicator()),
                  const SizedBox(height: 24),
                ],

                const SizedBox(height: 16),

                if (state.errorMessage != null) ...[
                  AppointmentsInlineError(
                    message: state.errorMessage,
                    onRetry: () => context.read<AppointmentsManagerCubit>().refreshCurrentView(),
                  ),
                  const SizedBox(height: 16),
                ],

                // 3. Conditional Filters (Modular & Responsive)
                if (!isEmbedded || showFiltersWhenEmbedded) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppointmentsFilterWidget(
                      appointments: state.appointments,
                      showDateRange: !isEmbedded, // 🚨 Hidden in Home Page
                      showStatusChips: !isEmbedded, // Hidden in Home Page for cleaner look
                      showSearch: true, // Always visible
                      showDoctorSelector: true, // Always visible
                    ),
                  ),
                ],

                // 4. The Table
                if (!state.isLoading &&
                    state.errorMessage == null &&
                    state.filteredAppointments.isEmpty) ...[
                  AppointmentsInlineEmpty(
                    title: 'no_appointments_found'.tr(),
                    subtitle: (() {
                      final selected = state.filter.startDate;
                      final now = DateTime.now();
                      final isToday =
                          now.year == selected.year &&
                          now.month == selected.month &&
                          now.day == selected.day;
                      if (isToday) {
                        return 'adjust_filters_to_find_appointments'.tr();
                      }
                      return '${DateFormat.yMMMd('en_US').format(selected)} • ${'adjust_filters_to_find_appointments'.tr()}';
                    })(),
                    icon: Icons.filter_alt_off_outlined,
                  ),
                ] else
                  GenericTableShell<AppointmentEntity>(
                    data: state.filteredAppointments,
                    isLoading: state.isLoading,
                    columns: AppointmentTableConfig.build(
                      context: context,
                      appointments: state.filteredAppointments,
                      onView: (app) {
                        context.push(
                          AppRouter.appointmentDetails,
                          extra: {
                            'appointment': app,
                            'role': AppointmentsOverviewMode.receptionist,
                            'onDataChanged': () =>
                                context.read<AppointmentsManagerCubit>().refreshCurrentView(),
                          },
                        );
                      },
                      onEdit: (app) async {
                        final result = await context.push(
                          AppRouter.editAppointment,
                          extra: {'appointment': app},
                        );

                        if (result == true && context.mounted) {
                          context.read<AppointmentsManagerCubit>().refreshCurrentView();
                        }
                      },
                      onStatusChange: (app, status, reason) {
                        context.read<AppointmentsManagerCubit>().updateStatus(
                          app.id,
                          status,
                          reason: reason,
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );

        if (isEmbedded) {
          return content;
        }

        return Scaffold(
          body: content,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.push(AppRouter.scheduleAppointment);
            },
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
          ),
        );
      },
    );
  }
}
