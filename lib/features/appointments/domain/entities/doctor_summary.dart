import 'package:equatable/equatable.dart';

class DoctorSummary extends Equatable {
  final String id;
  final String name;

  const DoctorSummary({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
