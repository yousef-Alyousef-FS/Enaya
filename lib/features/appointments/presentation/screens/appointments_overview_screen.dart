import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/core/di/injection.dart';
import 'package:enaya/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_status.dart';
import '../cubit/appointments_cubit_imports.dart';

enum AppointmentsOverviewMode { generic, receptionist, doctor, patient }

class AppointmentsOverviewConfig {
  final AppointmentsOverviewMode mode;
  final bool showDateFilter;
  final bool showPagination;
  final bool showRefreshAction;
  final bool showTodayShortcut;
  final int pageSize;
  final String titleKey;
  final String emptyStateKey;

  const AppointmentsOverviewConfig({
    this.mode = AppointmentsOverviewMode.generic,
    this.showDateFilter = true,
    this.showPagination = true,
    this.showRefreshAction = true,
    this.showTodayShortcut = true,
    this.pageSize = 20,
    this.titleKey = 'appointments_title',
    this.emptyStateKey = 'no_appointments_found',
  });
}

class AppointmentsOverviewScreen extends StatelessWidget {
  final AppointmentsOverviewConfig config;

  const AppointmentsOverviewScreen({super.key, this.config = const AppointmentsOverviewConfig()});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AppointmentsOverviewCubit>()..loadInitialData(pageSize: config.pageSize),
      child: _AppointmentsOverviewBody(config: config),
    );
  }
}

class _AppointmentsOverviewBody extends StatefulWidget {
  final AppointmentsOverviewConfig config;

  const _AppointmentsOverviewBody({required this.config});

  @override
  State<_AppointmentsOverviewBody> createState() => _AppointmentsOverviewBodyState();
}

class _AppointmentsOverviewBodyState extends State<_AppointmentsOverviewBody> {
  Future<void> _pickDate(BuildContext context, AppointmentsOverviewCubit cubit) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: cubit.state.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      await cubit.updateSelectedDate(picked, pageSize: widget.config.pageSize);
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    return DateFormat('EEE, dd MMM yyyy', context.locale.toString()).format(date);
  }

  String _formatLongDate(BuildContext context, DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy', context.locale.toString()).format(date);
  }

  void _refreshCurrentView(AppointmentsOverviewCubit cubit) {
    cubit.refreshCurrentView();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentsOverviewCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.config.titleKey.tr()),
        actions: [
          if (widget.config.showRefreshAction)
            IconButton(
              onPressed: () => _refreshCurrentView(cubit),
              icon: const Icon(Icons.refresh),
              tooltip: 'refresh'.tr(),
            ),
        ],
      ),
      body: BlocBuilder<AppointmentsOverviewCubit, AppointmentsOverviewState>(
        builder: (context, state) {
          if (state.isLoading && state.appointments.isEmpty) {
            return _buildLoadingShimmer();
          }

          if (state.hasError && state.appointments.isEmpty) {
            return _buildEmptyState(
              title: 'error_occurred'.tr(),
              message: state.errorMessage,
              icon: Icons.error_outline,
              isError: true,
            );
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                child: _buildHeader(state),
              ),
              if (widget.config.showDateFilter || widget.config.showTodayShortcut)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    children: [
                      if (widget.config.showDateFilter)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickDate(context, cubit),
                            icon: const Icon(Icons.calendar_month),
                            label: Text(_formatDate(context, state.selectedDate)),
                          ),
                        ),
                      if (widget.config.showDateFilter && widget.config.showTodayShortcut)
                        SizedBox(width: 12.w),
                      if (widget.config.showTodayShortcut)
                        FilledButton.tonalIcon(
                          onPressed: () => cubit.loadInitialData(pageSize: widget.config.pageSize),
                          icon: const Icon(Icons.today),
                          label: Text('today'.tr()),
                        ),
                    ],
                  ),
                ),
              if (widget.config.showPagination)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: state.currentPage > 1 && !state.isPageLoading
                            ? () => cubit.loadPreviousPage()
                            : null,
                        icon: const Icon(Icons.chevron_left),
                        tooltip: 'previous_page'.tr(),
                      ),
                      Text('${'page'.tr()} ${state.currentPage}'),
                      IconButton(
                        onPressed: state.hasMore && !state.isPageLoading
                            ? () => cubit.loadNextPage()
                            : null,
                        icon: const Icon(Icons.chevron_right),
                        tooltip: 'next_page'.tr(),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _refreshCurrentView(cubit),
                  child: state.appointments.isEmpty
                      ? _buildEmptyState(
                          title: widget.config.emptyStateKey.tr(),
                          message: null,
                          icon: Icons.event_busy,
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          itemCount: state.appointments.length,
                          separatorBuilder: (context, index) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final appointment = state.appointments[index];
                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: AppColors.gray200),
                              ),
                              child: ListTile(
                                onTap: () => _showAppointmentDetails(context, appointment),
                                contentPadding: EdgeInsets.all(16.w),
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primaryExtraLight,
                                  child: Text(
                                    DateFormat('HH:mm').format(appointment.dateTime),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  _buildPrimaryTitle(
                                    appointment.patientName,
                                    appointment.doctorName,
                                  ),
                                ),
                                subtitle: Text(
                                  _buildSubtitle(
                                    appointment.doctorName,
                                    appointment.patientName,
                                    appointment.dateTime,
                                  ),
                                ),
                                trailing: _buildStatusChip(appointment.status),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(AppointmentsOverviewState state) {
    final subtitle = _formatLongDate(context, state.selectedDate);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.event_note, color: Colors.white),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.config.titleKey.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withAlpha(220), fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${state.appointments.length}',
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  String _buildPrimaryTitle(String patientName, String doctorName) {
    switch (widget.config.mode) {
      case AppointmentsOverviewMode.doctor:
        return patientName;
      case AppointmentsOverviewMode.patient:
        return doctorName;
      case AppointmentsOverviewMode.receptionist:
      case AppointmentsOverviewMode.generic:
        return patientName;
    }
  }

  String _buildSubtitle(String doctorName, String patientName, DateTime dateTime) {
    final timeText = DateFormat('HH:mm').format(dateTime);
    switch (widget.config.mode) {
      case AppointmentsOverviewMode.doctor:
        return '${'patient'.tr()}: $patientName • $timeText';
      case AppointmentsOverviewMode.patient:
        return '${'doctor'.tr()}: $doctorName • $timeText';
      case AppointmentsOverviewMode.receptionist:
        return '${'doctor'.tr()}: $doctorName • $timeText';
      case AppointmentsOverviewMode.generic:
        return '${'doctor'.tr()}: $doctorName • ${'patient'.tr()}: $patientName • $timeText';
    }
  }

  void _showAppointmentDetails(BuildContext context, AppointmentEntity appointment) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _buildPrimaryTitle(appointment.patientName, appointment.doctorName),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(height: 12.h),
              Text('${'patient'.tr()}: ${appointment.patientName}'),
              SizedBox(height: 6.h),
              Text('${'doctor'.tr()}: ${appointment.doctorName}'),
              SizedBox(height: 6.h),
              Text(
                DateFormat(
                  'EEE, dd MMM yyyy - HH:mm',
                  context.locale.toString(),
                ).format(appointment.dateTime),
              ),
              SizedBox(height: 6.h),
              Text('${'status'.tr()}: ${_buildStatusLabel(appointment.status)}'),
              if (appointment.reason != null && appointment.reason!.isNotEmpty) ...[
                SizedBox(height: 6.h),
                Text('${'reason'.tr()}: ${appointment.reason}'),
              ],
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    final (Color background, Color foreground, String label) = switch (status) {
      AppointmentStatus.scheduled => (
        AppColors.primaryExtraLight,
        AppColors.primaryDark,
        'scheduled'.tr(),
      ),
      AppointmentStatus.confirmed => (const Color(0xFFE8F7EF), AppColors.success, 'confirmed'.tr()),
      AppointmentStatus.arrived => (const Color(0xFFFFF4E5), AppColors.warning, 'arrived'.tr()),
      AppointmentStatus.inProgress => (const Color(0xFFEAF2FF), AppColors.info, 'in_progress'.tr()),
      AppointmentStatus.completed => (const Color(0xFFE8F7EF), AppColors.success, 'completed'.tr()),
      AppointmentStatus.cancelled => (const Color(0xFFFFEBEE), AppColors.error, 'cancelled'.tr()),
      AppointmentStatus.noShow => (AppColors.gray100, AppColors.gray600, 'no_show'.tr()),
      AppointmentStatus.rescheduled => (
        const Color(0xFFF0ECFF),
        AppColors.accent,
        'rescheduled'.tr(),
      ),
    };

    return Chip(
      label: Text(
        label,
        style: TextStyle(color: foreground, fontSize: 12, fontWeight: FontWeight.w600),
      ),
      backgroundColor: background,
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _buildStatusLabel(AppointmentStatus status) {
    return switch (status) {
      AppointmentStatus.scheduled => 'scheduled'.tr(),
      AppointmentStatus.confirmed => 'confirmed'.tr(),
      AppointmentStatus.arrived => 'arrived'.tr(),
      AppointmentStatus.inProgress => 'in_progress'.tr(),
      AppointmentStatus.completed => 'completed'.tr(),
      AppointmentStatus.cancelled => 'cancelled'.tr(),
      AppointmentStatus.noShow => 'no_show'.tr(),
      AppointmentStatus.rescheduled => 'rescheduled'.tr(),
    };
  }

  Widget _buildEmptyState({
    required String title,
    required String? message,
    required IconData icon,
    bool isError = false,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: isError ? AppColors.error.withAlpha(15) : AppColors.primaryExtraLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 34,
                color: isError ? AppColors.error : AppColors.primaryDark,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              ),
            ),
            if (message != null && message.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.gray600),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.gray200,
          highlightColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 14.h, width: double.infinity, color: Colors.white),
                      SizedBox(height: 10.h),
                      Container(height: 12.h, width: 160.w, color: Colors.white),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 72.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
