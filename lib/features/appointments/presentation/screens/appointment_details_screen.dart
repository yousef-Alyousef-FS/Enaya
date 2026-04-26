import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_status.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final AppointmentEntity appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('appointment_details'.tr())),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainInfoCard(context),
            SizedBox(height: 16.h),
            _buildMetaCard(context),
            SizedBox(height: 16.h),
            _buildReasonCard(context),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('done'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.patientName,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8.h),
          Text(
            '${'doctor'.tr()}: ${appointment.doctorName}',
            style: TextStyle(color: Colors.white.withAlpha(220), fontSize: 14),
          ),
          SizedBox(height: 12.h),
          _buildStatusChip(appointment.status),
        ],
      ),
    );
  }

  Widget _buildMetaCard(BuildContext context) {
    return _SectionCard(
      title: 'scheduled_for'.tr(),
      children: [
        _LabeledValue(
          label: 'scheduled_for'.tr(),
          value: DateFormat(
            'EEEE, d MMMM yyyy - HH:mm',
            context.locale.toString(),
          ).format(appointment.dateTime),
        ),
        _LabeledValue(label: 'appointment_id'.tr(), value: appointment.id),
        if (appointment.queueNumber != null)
          _LabeledValue(label: 'queue_number'.tr(), value: appointment.queueNumber.toString()),
      ],
    );
  }

  Widget _buildReasonCard(BuildContext context) {
    final reason = (appointment.reason == null || appointment.reason!.trim().isEmpty)
        ? 'no_reason_provided'.tr()
        : appointment.reason!;
    final notes = (appointment.notes == null || appointment.notes!.trim().isEmpty)
        ? 'no_notes'.tr()
        : appointment.notes!;

    return _SectionCard(
      title: 'reason'.tr(),
      children: [
        _LabeledValue(label: 'reason'.tr(), value: reason),
        _LabeledValue(label: 'notes'.tr(), value: notes),
      ],
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(999)),
      child: Text(
        label,
        style: TextStyle(color: foreground, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          ...children,
        ],
      ),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  final String label;
  final String value;

  const _LabeledValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
          SizedBox(height: 3.h),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gray800,
            ),
          ),
        ],
      ),
    );
  }
}
