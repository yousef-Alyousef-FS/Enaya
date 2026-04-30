import 'package:enaya/features/appointments/presentation/widgets/receptionist/appointment_table_config.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/tables/appointments_table/generic_table_shell.dart';
import '../../../../appointments/domain/entities/appointment_entity.dart';
import '../../domain/entities/receptionist_dashboard_stats.dart';

class AppointmentsTable extends StatelessWidget {
  final ReceptionistDashboardStats? stats;

  const AppointmentsTable({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final appointments = stats?.appointments ?? const [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GenericTableShell<AppointmentEntity>(
        data: appointments,
        isLoading: false,
        columns: AppointmentTableConfig.build(
          context: context,
          appointments: appointments,
          onView: (app) {},
          onEdit: (app) {},
          onCheckIn: (app) {},
        ),
      ),
    );
  }
}
