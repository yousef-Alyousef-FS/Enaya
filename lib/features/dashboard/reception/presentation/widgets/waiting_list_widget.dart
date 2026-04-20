import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../appointments/domain/entities/appointment_entity.dart';

class WaitingListWidget extends StatelessWidget {
  final List<AppointmentEntity> waitingPatients;

  const WaitingListWidget({
    super.key,
    required this.waitingPatients,
  });

  @override
  Widget build(BuildContext context) {
    if (waitingPatients.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Text('No patients in the waiting list'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: waitingPatients.length,
      itemBuilder: (context, index) {
        final patient = waitingPatients[index];
        return Card(
          margin: EdgeInsets.only(bottom: 8.h),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange[100],
              child: Text(
                '${index + 1}', // Simple queue number for now
                style: TextStyle(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              patient.patientName,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('Dr. ${patient.doctorName}'),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'Waiting',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
