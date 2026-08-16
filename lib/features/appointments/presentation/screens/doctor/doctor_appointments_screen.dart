import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/section_header.dart';
import '../../../data/models/appointments_overview_view_mode.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_status.dart';
import '../../cubit/list/doctor_appointments_cubit.dart';
import '../../cubit/list/doctor_appointments_state.dart';
import '../../widgets/doctor/appointment_table_skeleton.dart';
import '../../widgets/doctor/doctor_appointments_filter_bar.dart';
import '../../widgets/doctor/doctor_appointments_header.dart';
import '../../widgets/shared/appointment_status_card.dart';
import '../../widgets/shared/appointments_feedback_state.dart';
import '../../widgets/tables/generic_table.dart';

enum _DoctorAppointmentsQuickView { today, completed }

/// [ARCH_FLAG]: High-level dashboard for Doctors.
/// Focused on confirmed appointments for the current day or selected range.
class DoctorAppointmentsScreen extends StatefulWidget {
  final String doctorId;
  final bool isEmbedded;

  const DoctorAppointmentsScreen({
    super.key,
    required this.doctorId,
    this.isEmbedded = false,
  });

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  final ScrollController _scrollController = ScrollController();
  _DoctorAppointmentsQuickView _selectedView =
      _DoctorAppointmentsQuickView.today;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadTodayAppointments();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (widget.isEmbedded) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<DoctorAppointmentsCubit>().loadNextPage(widget.doctorId);
    }
  }

  Future<void> _loadTodayAppointments({bool silent = false}) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    await context.read<DoctorAppointmentsCubit>().loadAppointments(
      widget.doctorId,
      date: start,
      endDate: end,
      silent: silent,
    );

    if (!mounted) return;
    setState(() {
      _selectedView = _DoctorAppointmentsQuickView.today;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorAppointmentsCubit, DoctorAppointmentsState>(
      builder: (context, state) {
        final visibleAppointments = _appointmentsForSelectedView(state);
        final completedCount = state.filteredAppointments
            .where(
              (appointment) =>
                  appointment.status == AppointmentStatus.completed,
            )
            .length;
        final todayCount = _todayConfirmedAppointments(
          state.filteredAppointments,
        ).length;

        final content = Align(
          alignment: Alignment
              .topCenter, // [UI_FIX]: Prevents vertical jumping during loading
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1300),
            child: RefreshIndicator(
              onRefresh: () async => _reloadCurrentRange(state),
              child: ListView(
                controller: widget.isEmbedded ? null : _scrollController,
                padding: widget.isEmbedded
                    ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                    : const EdgeInsets.fromLTRB(
                        24,
                        8,
                        24,
                        16,
                      ), // [UI_FIX]: Consistent top/bottom padding
                shrinkWrap: widget.isEmbedded,
                physics: widget.isEmbedded
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                children: [
                  if (!widget.isEmbedded) ...[
                    DoctorAppointmentsHeader(
                      isLoading:
                          state.status == DoctorAppointmentsStatus.loading,
                      onManageSchedule: () => context.push(
                        Uri(
                          path: AppRouter.doctorSchedule,
                          queryParameters: {'doctorId': widget.doctorId},
                        ).toString(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  DoctorAppointmentsFilterBar(
                    searchQuery: state.searchQuery,
                    selectedDate: state.selectedDate,
                    selectedEndDate: state.selectedEndDate,
                    onSearchChanged: (query) => context
                        .read<DoctorAppointmentsCubit>()
                        .updateSearchQuery(query),
                    onPickRange: () => _pickRange(state),
                  ),
                  const SizedBox(height: 12), // توحيد المسافة
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      AppointmentStatusCard(
                        status: AppointmentStatus.completed,
                        label: 'status_completed'.tr(),
                        count: completedCount,
                        isSelected:
                            _selectedView ==
                            _DoctorAppointmentsQuickView.completed,
                        onTap: () {
                          setState(() {
                            _selectedView =
                                _DoctorAppointmentsQuickView.completed;
                          });
                        },
                      ),
                      AppointmentStatusCard(
                        status: AppointmentStatus.confirmed,
                        label: 'today_appointments'.tr(),
                        count: todayCount,
                        isSelected:
                            _selectedView == _DoctorAppointmentsQuickView.today,
                        onTap: () async {
                          await _loadTodayAppointments();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // مسافة مناسبة قبل الـ Header
                  AppSectionHeader(
                    title:
                        _selectedView == _DoctorAppointmentsQuickView.completed
                        ? 'status_completed'.tr()
                        : 'today_appointments'.tr(),
                    isLoading: state.status == DoctorAppointmentsStatus.loading,
                  ),
                  const SizedBox(height: 12), // تقليل المسافة
                  if (state.status == DoctorAppointmentsStatus.failure &&
                      state.errorMessage != null) ...[
                    AppointmentsInlineError(
                      message: state.errorMessage,
                      onRetry: () => _reloadCurrentRange(state),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (state.status == DoctorAppointmentsStatus.loading &&
                      state.appointments.isEmpty)
                    const AppointmentTableSkeleton()
                  else if (visibleAppointments.isEmpty)
                    AppointmentsInlineEmpty(
                      title: 'no_appointments_found'.tr(),
                      subtitle: 'adjust_filters_to_find_appointments'.tr(),
                    )
                  else
                    GenericTableShell<AppointmentEntity>(
                      data: visibleAppointments,
                      isLoading:
                          state.status == DoctorAppointmentsStatus.loading,
                      isPageLoading: state.isPageLoading,
                      onRowTap: (appointment) =>
                          _openDetails(context, appointment),
                      onLoadMore: widget.isEmbedded
                          ? null
                          : () => context
                                .read<DoctorAppointmentsCubit>()
                                .loadNextPage(widget.doctorId),
                      columns: [
                        // ... (الأعمدة كما هي)
                      ],
                    ),
                  const SizedBox(height: 8), // مسافة نهائية صغيرة
                ],
              ),
            ),
          ),
        );
        if (widget.isEmbedded) {
          return content;
        }

        return Scaffold(body: SafeArea(child: content));
      },
    );
  }

  Future<void> _pickRange(DoctorAppointmentsState state) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final initialRange = DateTimeRange(
      start: state.selectedDate.isBefore(today) ? today : state.selectedDate,
      end: state.selectedEndDate.isBefore(today)
          ? today
          : state.selectedEndDate,
    );

    final lastDate = DateTime(now.year + 1, now.month, now.day);

    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      firstDate: today,
      lastDate: lastDate,
      locale: const Locale('en', 'US'),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              headerBackgroundColor: theme.colorScheme.primary,
              headerForegroundColor: theme.colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null || !mounted) return;

    final start = DateTime(
      picked.start.year,
      picked.start.month,
      picked.start.day,
    );
    final end = DateTime(
      picked.end.year,
      picked.end.month,
      picked.end.day,
      23,
      59,
      59,
      999,
    );

    if (mounted) {
      await context.read<DoctorAppointmentsCubit>().updateDateRange(
        widget.doctorId,
        start,
        end,
      );
    }
  }

  Future<void> _reloadCurrentRange(DoctorAppointmentsState state) async {
    await context.read<DoctorAppointmentsCubit>().loadAppointments(
      widget.doctorId,
      date: state.selectedDate,
      endDate: state.selectedEndDate,
    );
  }

  // [VIEW_LOGIC]: Filters visible items locally based on 'Today' vs 'Completed' tabs.
  List<AppointmentEntity> _appointmentsForSelectedView(
    DoctorAppointmentsState state,
  ) {
    final appointments = state.filteredAppointments;

    switch (_selectedView) {
      case _DoctorAppointmentsQuickView.completed:
        return appointments
            .where(
              (appointment) =>
                  appointment.status == AppointmentStatus.completed,
            )
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
      case _DoctorAppointmentsQuickView.today:
        return _todayConfirmedAppointments(appointments);
    }
  }

  List<AppointmentEntity> _todayConfirmedAppointments(
    List<AppointmentEntity> appointments,
  ) {
    final today = DateTime.now();
    return appointments.where((appointment) {
      return appointment.status == AppointmentStatus.confirmed &&
          _isSameDay(appointment.dateTime, today);
    }).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _openDetails(BuildContext context, AppointmentEntity appointment) {
    context.push(
      AppRouter.appointmentDetails,
      extra: {
        'appointment': appointment,
        'role': AppointmentsOverviewMode.doctor,
        'onDataChanged': () => context
            .read<DoctorAppointmentsCubit>()
            .loadAppointments(widget.doctorId),
      },
    );
  }
}
