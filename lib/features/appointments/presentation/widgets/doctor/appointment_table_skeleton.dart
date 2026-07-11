import 'package:flutter/material.dart';
import '../../../../../core/widgets/common/shimmer_loading.dart';

class AppointmentTableSkeleton extends StatelessWidget {
  const AppointmentTableSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: SkeletonLoader(width: double.infinity, height: 72, borderRadius: 16),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: SkeletonLoader(width: double.infinity, height: 72, borderRadius: 16),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: SkeletonLoader(width: double.infinity, height: 72, borderRadius: 16),
        ),
      ],
    );
  }
}
