import 'package:easy_localization/easy_localization.dart';
import '../../../../appointments/domain/entities/appointment_stats_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/common/section_header.dart';
import '../../widgets/receptionist/appointment_table_config.dart';
import '../../../../../core/widgets/tables/appointments_table/generic_table_shell.dart';
import '../../widgets/shared/app_filter_date_range_picker.dart';
import '../../cubit/appointments_overview_cubit.dart';
import '../../cubit/appointments_overview_state.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_entity.dart';
import 'package:enaya/features/appointments/presentation/widgets/receptionist/doctor_selector_button.dart';
import '../../widgets/receptionist/receptionist_stats_grid.dart';
import '../../widgets/receptionist/appointment_search_bar.dart';
import '../../widgets/receptionist/sort_indicator.dart';
import '../appointment_details_screen.dart';

// Appointments Overview Screen
class ReceptionistAppointmentsScreen extends StatelessWidget {
  final VoidCallback? onAddAppointment;

  const ReceptionistAppointmentsScreen({super.key, this.onAddAppointment});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsManagerCubit, AppointmentsOverviewState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final doctorMap = <String, String>{};
        for (final appointment in state.appointments) {
          doctorMap.putIfAbsent(appointment.doctorId, () => appointment.doctorName);
        }

        final doctorOptions =
            doctorMap.entries
                .map((entry) => DoctorOption(id: entry.key, name: entry.value))
                .toList()
              ..sort((a, b) => a.name.compareTo(b.name));

        return Scaffold(
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                physics: const BouncingScrollPhysics(),
                children: [
                  // 1. Stats Sections
                  ReceptionistStatsGrid(
                    data: const AppointmentStats(
                      totalAppointments: 11,
                      scheduled: 3,
                      confirmed: 0,
                      completed: 7,
                      cancelled: 1,
                      noShow: 0,
                      utilizationRate: 0,
                      completionRate: 0,
                      byDoctor: [],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppSectionHeader(title: 'appointments_list'.tr(), isLoading: state.isLoading),
                  const SizedBox(height: 16),
                  // 2. Search, Date Range & Doctor Picker - Responsive Layout
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 768;

                      if (isMobile) {
                        // Mobile: Stack layout - Search full width, then Date + Doctor below
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppointmentSearchBar(
                              onSearch: (query) {
                                context.read<AppointmentsManagerCubit>().updateSearchQuery(query);
                              },
                              onClear: () {
                                context.read<AppointmentsManagerCubit>().clearSearch();
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: AppFilterDateRangePicker(
                                    label: 'appointment_date',
                                    startDate: state.selectedDate,
                                    endDate: state.endDate,
                                    onRangeSelected: (range) {
                                      context.read<AppointmentsManagerCubit>().updateDateRange(
                                        range.start,
                                        range.end,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DoctorSelectorButton(
                                    doctors: doctorOptions,
                                    selectedDoctorName: state.selectedDoctorName,
                                    onClearSelection: () {
                                      context
                                          .read<AppointmentsManagerCubit>()
                                          .clearDoctorSelection();
                                    },
                                    onSelected: (doctor) {
                                      context.read<AppointmentsManagerCubit>().selectDoctor(
                                        doctorId: doctor.id,
                                        doctorName: doctor.name,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        // Desktop: Original Row layout
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: AppointmentSearchBar(
                                onSearch: (query) {
                                  context.read<AppointmentsManagerCubit>().updateSearchQuery(query);
                                },
                                onClear: () {
                                  context.read<AppointmentsManagerCubit>().clearSearch();
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 260,
                              child: AppFilterDateRangePicker(
                                label: 'appointment_date',
                                startDate: state.selectedDate,
                                endDate: state.endDate,
                                onRangeSelected: (range) {
                                  context.read<AppointmentsManagerCubit>().updateDateRange(
                                    range.start,
                                    range.end,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 260,
                              child: DoctorSelectorButton(
                                doctors: doctorOptions,
                                selectedDoctorName: state.selectedDoctorName,
                                onClearSelection: () {
                                  context.read<AppointmentsManagerCubit>().clearDoctorSelection();
                                },
                                onSelected: (doctor) {
                                  context.read<AppointmentsManagerCubit>().selectDoctor(
                                    doctorId: doctor.id,
                                    doctorName: doctor.name,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. Selected Doctor Indicator
                  if (state.selectedDoctorName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SortIndicator(
                        selectedDoctorName: state.selectedDoctorName,
                        onClear: () {
                          context.read<AppointmentsManagerCubit>().clearDoctorSelection();
                        },
                      ),
                    ),

                  // 4. Table Header (Using Shared AppSectionHeader)
                  const SizedBox(height: 16),

                  // 5. Table Widget
                  GenericTableShell<AppointmentEntity>(
                    data: state.filteredAppointments,
                    isLoading: state.isLoading,
                    columns: AppointmentTableConfig.build(
                      context: context,
                      appointments: state.filteredAppointments,
                      onView: (app) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppointmentDetailsScreen(appointment: app),
                          ),
                        );
                      },
                      onEdit: (app) {},
                      onCheckIn: (app) {},
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: onAddAppointment,
            backgroundColor: theme.colorScheme.primary,
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
