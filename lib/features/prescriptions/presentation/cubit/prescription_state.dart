import 'package:enaya/features/prescriptions/domain/entities/prescription_entity.dart';

abstract class PrescriptionState {}

class PrescriptionInitial extends PrescriptionState {}

class PrescriptionLoading extends PrescriptionState {}

class PrescriptionLoaded extends PrescriptionState {
  final List<PrescriptionEntity> prescriptions;

  PrescriptionLoaded(this.prescriptions);
}

class PrescriptionAdded extends PrescriptionState {
  final PrescriptionEntity prescription;

  PrescriptionAdded(this.prescription);
}

class PrescriptionUpdated extends PrescriptionState {
  final PrescriptionEntity prescription;

  PrescriptionUpdated(this.prescription);
}

class PrescriptionDeleted extends PrescriptionState {}

class PrescriptionError extends PrescriptionState {
  final String message;

  PrescriptionError(this.message);
}
