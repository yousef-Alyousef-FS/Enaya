import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_entity.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_status.dart';
import 'package:flutter/material.dart';

/// Dialog for changing appointment status with reason/note input.
///
/// Displays current status and allowed transitions with a reason/note field
/// for documentation. Particularly useful for status changes like NoShow → Arrived.
class AppointmentStatusChangeDialog extends StatefulWidget {
  final AppointmentEntity appointment;
  final AppointmentStatus newStatus;
  final Function(AppointmentStatus, String? reason) onConfirm;

  const AppointmentStatusChangeDialog({
    super.key,
    required this.appointment,
    required this.newStatus,
    required this.onConfirm,
  });

  @override
  State<AppointmentStatusChangeDialog> createState() =>
      _AppointmentStatusChangeDialogState();
}

class _AppointmentStatusChangeDialogState
    extends State<AppointmentStatusChangeDialog> {
  late final TextEditingController _reasonController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  bool get _needsReason {
    // NoShow transitions require a reason
    return widget.appointment.status == AppointmentStatus.noShow ||
        widget.newStatus == AppointmentStatus.noShow;
  }

  bool get _canConfirm {
    if (_needsReason) {
      return _reasonController.text.trim().isNotEmpty;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('change_appointment_status'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current status info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.appointment.status.color.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.appointment.status.color.withAlpha(100),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.appointment.status.icon,
                    size: 20,
                    color: widget.appointment.status.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'current_status'.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.appointment.status.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.appointment.status.color,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Arrow/transition indicator
            Center(
              child: Icon(
                Icons.arrow_downward,
                color: theme.colorScheme.primary.withAlpha(150),
                size: 20,
              ),
            ),
            const SizedBox(height: 16),

            // New status
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.newStatus.color.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.newStatus.color.withAlpha(100),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.newStatus.icon,
                    size: 20,
                    color: widget.newStatus.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'new_status'.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.newStatus.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.newStatus.color,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Reason/Note input (if needed)
            if (_needsReason) ...[
              Text(
                'reason_required'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                maxLines: 3,
                minLines: 2,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'enter_reason'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ] else ...[
              Text(
                'note_optional'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                maxLines: 2,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'add_note'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text('cancel'.tr()),
        ),
        ElevatedButton.icon(
          onPressed: _isLoading || !_canConfirm ? null : _onConfirm,
          icon: _isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      theme.colorScheme.onPrimary,
                    ),
                  ),
                )
              : Icon(widget.newStatus.icon, size: 18),
          label: Text(_isLoading ? 'applying'.tr() : 'apply'.tr()),
        ),
      ],
    );
  }

  Future<void> _onConfirm() async {
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pop(context);
        widget.onConfirm(
          widget.newStatus,
          _reasonController.text.trim().isNotEmpty
              ? _reasonController.text.trim()
              : null,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
