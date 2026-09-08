import 'package:enaya/features/patients/domain/entities/patient_entity.dart';

import '../di/injection.dart';
import 'session_manager.dart';

/// Resolves the active patient profile for patient-facing screens.
class PatientSession {
  final SessionManager _sessionManager;

  PatientSession._(this._sessionManager);

  factory PatientSession() => PatientSession._(getIt<SessionManager>());

  Map<String, dynamic>? get userData => _sessionManager.currentUser;

  bool get isGuest => userData == null;

  String? get patientId => _sessionManager.currentUserId;

  String? get patientName => _sessionManager.currentUserName;

  String? get patientEmail => _sessionManager.currentUserEmail;

  String? get patientPhone => _sessionManager.currentUserPhone;

  PatientEntity? get patientEntity {
    final id = patientId;
    if (id == null) return null;

    return PatientEntity(
      id: id,
      name: patientName ?? 'Unknown',
      email: patientEmail ?? '',
      phone: patientPhone ?? '',
      dateOfBirth: DateTime(1990, 1, 1),
      job: '',
      address: '',
    );
  }
}
