import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../receptionist/appointment_search_bar.dart';
import 'date_range_button.dart';

class DoctorAppointmentsFilterBar extends StatelessWidget {
  final String searchQuery;
  final DateTime selectedDate;
  final DateTime selectedEndDate;
  final Function(String) onSearchChanged;
  final VoidCallback onPickRange;

  const DoctorAppointmentsFilterBar({
    super.key,
    required this.searchQuery,
    required this.selectedDate,
    required this.selectedEndDate,
    required this.onSearchChanged,
    required this.onPickRange,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.spaceBetween,
          children: [
            SizedBox(
              width: isMobile ? constraints.maxWidth : constraints.maxWidth * 0.5,
              child: AppointmentSearchBar(
                height: 56,
                hintText: 'search_patient_or_appointment'.tr(),
                onSearch: onSearchChanged,
                onClear: () => onSearchChanged(''),
              ),
            ),
            SizedBox(
              width: isMobile ? constraints.maxWidth : 200,
              child: DateRangeButton(
                label: _formatRangeLabel(context, selectedDate, selectedEndDate),
                onPressed: onPickRange,
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatRangeLabel(BuildContext context, DateTime start, DateTime end) {
    final locale = context.locale.toString();
    final formatter = DateFormat('dd/MM/yyyy', locale);
    final formatter2 = DateFormat('dd/MM', locale);
    if (_isSameDay(start, end)) {
      return formatter.format(start);
    }
    return '${formatter2.format(start)} - ${formatter2.format(end)}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
