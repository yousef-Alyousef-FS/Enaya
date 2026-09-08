import 'package:equatable/equatable.dart';

class DoctorSummary extends Equatable {
  final String id;
  final String name;
  final String? specialty;

  const DoctorSummary({required this.id, required this.name, this.specialty});

  @override
  List<Object?> get props => [id, name, specialty];
}
