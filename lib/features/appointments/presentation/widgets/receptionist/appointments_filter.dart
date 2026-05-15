import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/features/appointments/domain/entities/appointment_status.dart';
import 'package:enaya/features/appointments/presentation/cubit/list/appointments_overview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../appointments/presentation/widgets/receptionist/doctor_selector_button.dart';
import '../../../../appointments/presentation/widgets/receptionist/appointment_search_bar.dart';
import '../../../../appointments/presentation/widgets/shared/app_filter_date_range_picker.dart';
import '../../../domain/entities/appointment_entity.dart';

/// Clean, responsive filters using Wrap and card-based status toggles.
///
/// Renamed to `AppointmentsFilterWidget` to avoid collision with the filter model.
class AppointmentsFilterWidget extends StatelessWidget {
  static const double _kControlHeight = 57;

  final List<AppointmentEntity> appointments;
  final List<DoctorOption>? doctors; // optional: if not provided we derive from appointments
  final bool showSearch;
  final bool showDoctorSelector;
  final bool showDateRange;
  final bool showStatusChips;

  const AppointmentsFilterWidget({
    super.key,
    this.appointments = const [],
    this.doctors,
    this.showSearch = true,
    this.showDoctorSelector = true,
    this.showDateRange = true,
    this.showStatusChips = true,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentsManagerCubit>(); // 👈 fixed cubit name
    final state = cubit.state;

    // derive doctors from appointments when not provided
    final map = <String, String>{};
    for (final a in appointments) {
      map.putIfAbsent(a.doctorId, () => a.doctorName);
    }

    final derivedDoctors = map.entries.map((e) => DoctorOption(id: e.key, name: e.value)).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    final doctorOptions = (doctors != null && doctors!.isNotEmpty) ? doctors! : derivedDoctors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const double spacing = 12.0;

        const double minSearch = 240.0;
        const double minDoctor = 150.0;
        const double minDate = 220.0;

        Widget buildSearch() => SizedBox(
          height: _kControlHeight,
          child: AppointmentSearchBar(
            onSearch: cubit.updateSearchQuery,
            onClear: cubit.clearSearch,
          ),
        );

        Widget buildDoctor() => SizedBox(
          height: _kControlHeight,
          child: DoctorSelectorButton(
            doctors: doctorOptions,
            selectedDoctorName: state.filter.doctorName,
            onClearSelection: cubit.clearDoctorSelection,
            onSelected: (d) => cubit.selectDoctor(doctorId: d.id, doctorName: d.name),
          ),
        );

        Widget buildDateRange() => SizedBox(
          height: _kControlHeight,
          child: AppFilterDateRangePicker(
            startDate: state.filter.startDate,
            endDate: state.filter.endDate,
            onRangeSelected: (range) => cubit.updateDateRange(range.start, range.end),
          ),
        );

        final controls = <Widget>[];
        if (showSearch) controls.add(buildSearch());
        if (showDoctorSelector) controls.add(buildDoctor());
        if (showDateRange) controls.add(buildDateRange());

        Widget layout;

        if (showSearch && showDoctorSelector && showDateRange) {
          if (width >= minSearch + minDoctor + minDate + spacing * 2) {
            layout = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: buildSearch()),
                const SizedBox(width: spacing),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: minDoctor, maxWidth: 210),
                  child: buildDoctor(),
                ),
                const SizedBox(width: spacing),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: minDate, maxWidth: 280),
                  child: buildDateRange(),
                ),
              ],
            );
          } else if (width >= minSearch + minDoctor + spacing) {
            layout = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSearch(),
                const SizedBox(height: spacing),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: minDoctor),
                        child: buildDoctor(),
                      ),
                    ),
                    const SizedBox(width: spacing),
                    Expanded(
                      flex: 2,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: minDate),
                        child: buildDateRange(),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            layout = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: width, child: buildSearch()),
                const SizedBox(height: spacing),
                SizedBox(width: width, child: buildDoctor()),
                const SizedBox(height: spacing),
                SizedBox(width: width, child: buildDateRange()),
              ],
            );
          }
        } else if (showSearch && showDoctorSelector && !showDateRange) {
          if (width >= minSearch + minDoctor + spacing) {
            layout = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: buildSearch()),
                const SizedBox(width: spacing),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: minDoctor, maxWidth: 180),
                  child: buildDoctor(),
                ),
              ],
            );
          } else {
            layout = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: width, child: buildSearch()),
                const SizedBox(height: spacing),
                SizedBox(width: width, child: buildDoctor()),
              ],
            );
          }
        } else {
          layout = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < controls.length; i++) ...[
                if (i > 0) const SizedBox(height: spacing),
                SizedBox(width: width, child: controls[i]),
              ],
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            layout,
            if (showStatusChips) ...[
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildStatusCard(
                      context,
                      status: null,
                      label: 'all'.tr(),
                      count: state.appointments.length,
                      isSelected: state.filter.status == null,
                      onTap: () => cubit.updateStatusFilter(null),
                    ),
                    const SizedBox(width: 8),
                    ...AppointmentStatus.values.expand((status) {
                      final count = state.appointments.where((a) => a.status == status).length;

                      return [
                        _buildStatusCard(
                          context,
                          status: status,
                          label: status.displayName,
                          count: count,
                          isSelected: state.filter.status == status,
                          onTap: () => cubit.updateStatusFilter(
                            state.filter.status == status ? null : status,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ];
                    }),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildStatusCard(
    BuildContext context, {
    required AppointmentStatus? status,
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final accentColor = status?.color ?? theme.colorScheme.primary;
    final isNeutral = status == null;

    final backgroundColor = isSelected
        ? accentColor.withAlpha(45) // More vibrant when selected
        : isNeutral
        ? theme.colorScheme.surfaceContainerLow
        : accentColor.withAlpha(18); // Subtle tint when unselected

    final borderColor = isSelected
        ? accentColor.withAlpha(220)
        : accentColor.withAlpha(isNeutral ? 60 : 120);

    final labelColor = isSelected ? accentColor : theme.colorScheme.onSurface.withAlpha(220);

    final countBackground = isSelected ? accentColor.withAlpha(50) : accentColor.withAlpha(30);

    final countColor = isSelected ? accentColor : accentColor.withAlpha(240);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: isSelected ? 2.2 : 1.2),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: accentColor.withAlpha(40),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isNeutral)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: accentColor.withAlpha(120), blurRadius: 5, spreadRadius: 1),
                    ],
                  ),
                ),
              if (!isNeutral) const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: countBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(color: countColor, fontSize: 11, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
