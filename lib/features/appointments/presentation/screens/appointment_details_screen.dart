// ignore_for_file:use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/appointments_overview_view_mode.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_status.dart';
import '../../domain/usecases/cancel_appointment_usecase.dart';
import '../../domain/usecases/reschedule_appointment_usecase.dart';
import '../../domain/usecases/update_appointment_status_usecase.dart';
import '../widgets/shared/appointment_status_chip.dart';
import 'appointment_status_dialog.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final AppointmentEntity appointment;
  final AppointmentsOverviewMode role;
  final VoidCallback? onDataChanged; // 🔄 لإعلام الشاشة السابقة بأي تغيير

  const AppointmentDetailsScreen({
    super.key,
    required this.appointment,
    this.role = AppointmentsOverviewMode.generic,
    this.onDataChanged,
  });

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  bool _isLoading = false;

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
            _buildActionRow(context),
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
      padding: EdgeInsets.all(8.w),
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
            widget.appointment.patientName,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8.h),
          Text(
            '${'doctor'.tr()}: ${widget.appointment.doctorName}',
            style: TextStyle(color: Colors.white.withAlpha(220), fontSize: 14),
          ),
          SizedBox(height: 12.h),
          AppointmentStatusChip(status: widget.appointment.status),
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
          ).format(widget.appointment.dateTime),
        ),
        _LabeledValue(label: 'appointment_id'.tr(), value: widget.appointment.id),
        if (widget.appointment.queueNumber != null)
          _LabeledValue(
            label: 'queue_number'.tr(),
            value: widget.appointment.queueNumber.toString(),
          ),
      ],
    );
  }

  Widget _buildReasonCard(BuildContext context) {
    final reason = (widget.appointment.reason == null || widget.appointment.reason!.trim().isEmpty)
        ? 'no_reason_provided'.tr()
        : widget.appointment.reason!;
    final notes = (widget.appointment.notes == null || widget.appointment.notes!.trim().isEmpty)
        ? 'no_notes'.tr()
        : widget.appointment.notes!;

    return _SectionCard(
      title: 'reason'.tr(),
      children: [
        _LabeledValue(label: 'reason'.tr(), value: reason),
        _LabeledValue(label: 'notes'.tr(), value: notes),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context) {
    final isFuture = widget.appointment.dateTime.isAfter(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.role == AppointmentsOverviewMode.receptionist) ...[
          FilledButton.tonal(
            onPressed: _isLoading ? null : () => _showStatusDialog(context),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('change_status'.tr()),
          ),
          SizedBox(height: 10.h),
          FilledButton(
            onPressed: _isLoading ? null : () => _showCancelConfirmation(context),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('cancel_appointment'.tr()),
          ),
        ],
        if (widget.role == AppointmentsOverviewMode.doctor) ...[
          FilledButton(
            onPressed: _isLoading ? null : () => _startAppointment(context), // استخدم UseCase حقيقي
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('start_appointment'.tr()),
          ),
          SizedBox(height: 10.h),
          FilledButton.tonal(
            onPressed: _isLoading ? null : () => _addMedicalNote(context),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('add_medical_note'.tr()),
          ),
        ],
        if (widget.role == AppointmentsOverviewMode.patient && isFuture) ...[
          FilledButton(
            onPressed: _isLoading ? null : () => _showCancelConfirmation(context),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('cancel_appointment'.tr()),
          ),
          SizedBox(height: 10.h),
          FilledButton.tonal(
            onPressed: _isLoading ? null : () => _rescheduleAppointment(context),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('reschedule'.tr()),
          ),
        ],
      ],
    );
  }

  // ================== الإجراءات (مع حالة تحميل) ==================

  Future<void> _updateAppointmentStatus(BuildContext context, AppointmentStatus status) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final result = await getIt<UpdateAppointmentStatusUseCase>().call(
      UpdateAppointmentStatusParams(appointmentId: widget.appointment.id, status: status),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        if (!mounted) return;
        _showError(context, failure.message);
      },
      (updated) {
        if (!mounted) return;
        _showSuccess(context, 'status_changed'.tr());
        widget.onDataChanged?.call();
        Navigator.pop(context, true);
      },
    );
  }

  Future<void> _cancelAppointment(BuildContext context) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final cancelledBy = widget.role == AppointmentsOverviewMode.patient
        ? 'patient'
        : 'receptionist';
    final result = await getIt<CancelAppointmentUseCase>().call(
      CancelAppointmentParams(
        appointmentId: widget.appointment.id,
        cancelledBy: cancelledBy,
        reason: null,
      ),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        if (!mounted) return;
        _showError(context, failure.message);
      },
      (_) {
        if (!mounted) return;
        _showSuccess(context, 'appointment_cancelled'.tr());
        widget.onDataChanged?.call();
        Navigator.pop(context, true);
      },
    );
  }

  Future<void> _rescheduleAppointment(BuildContext context) async {
    if (_isLoading) return;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.appointment.dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.appointment.dateTime),
    );
    if (pickedTime == null || !mounted) return;

    final newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (!mounted) return;
    setState(() => _isLoading = true);
    final result = await getIt<RescheduleAppointmentUseCase>().call(
      RescheduleAppointmentParams(appointmentId: widget.appointment.id, newDateTime: newDateTime),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        if (mounted) {
          _showError(context, failure.message);
        }
      },
      (_) {
        if (mounted) {
          _showSuccess(context, 'appointment_rescheduled'.tr());
          widget.onDataChanged?.call();
          Navigator.pop(context, true);
        }
      },
    );
  }

  // مؤقتاً – يجب استبدالها بـ UseCase حقيقي
  Future<void> _startAppointment(BuildContext context) async {
    // TODO: استدعاء StartAppointmentUseCase
    _showInfo(context, 'start_appointment_feature_coming_soon'.tr());
  }

  Future<void> _addMedicalNote(BuildContext context) async {
    // TODO: فتح شاشة إضافة ملاحظة طبية
    _showInfo(context, 'add_medical_note_feature_coming_soon'.tr());
  }

  // ================== حوارات مساعدة ==================

  void _showStatusDialog(BuildContext context) {
    showAppointmentStatusDialog(
      context: context,
      currentStatus: widget.appointment.status,
      onStatusSelected: (newStatus) {
        _updateAppointmentStatus(context, newStatus);
      },
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('cancel_appointment'.tr()),
        content: Text('confirm_action'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('cancel'.tr())),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelAppointment(context);
            },
            child: Text('confirm'.tr()),
          ),
        ],
      ),
    );
  }

  // ================== ملاحظات ورسائل ==================

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.error));
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.success));
  }

  void _showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.info));
  }
}

// ================== ويدجيتات مساعدة (يمكن نقلها لاحقاً) ==================

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
