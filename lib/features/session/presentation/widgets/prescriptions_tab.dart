import 'package:easy_localization/easy_localization.dart';
import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';
import 'package:enaya/features/prescriptions/presentation/cubit/prescription_cubit.dart';
import 'package:enaya/features/prescriptions/presentation/screens/prescription_detail_screen.dart';
import 'package:enaya/features/prescriptions/presentation/widgets/prescription_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Tab that displays prescriptions list for a given appointment
/// and floating action button to add new one.
class PrescriptionsTab extends StatelessWidget {
  final int appointmentId;
  final int sessionId;
  final List<PrescriptionEntity> prescriptions;

  const PrescriptionsTab({
    super.key,
    required this.appointmentId,
    required this.sessionId,
    required this.prescriptions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: prescriptions.isEmpty
          ? Center(child: Text("no_prescriptions".tr()))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                final prescription = prescriptions[index];
                return PrescriptionItemCard(
                  prescription: prescription,
                  onTap: () {
                    final prescriptionCubit = context.read<PrescriptionCubit>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrescriptionDetailScreen(
                          appointmentId: appointmentId,
                          sessionId: sessionId,
                          prescription: prescription,
                          prescriptionCubit: prescriptionCubit,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/doctor/prescription/add/$appointmentId/$sessionId');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
