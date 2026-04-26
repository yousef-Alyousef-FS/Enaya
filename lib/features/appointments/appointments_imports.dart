// Entities
export 'domain/entities/appointment_entity.dart';
export 'domain/entities/appointment_stats_entity.dart';
export 'domain/entities/appointment_status.dart';
export 'domain/entities/patient_appointments_entity.dart';
export 'domain/entities/patient_cancellation_result.dart';

// Repositories
export 'domain/repositories/appointment_management_repository.dart';
export 'domain/repositories/patient_appointments_repository.dart';
export 'data/repositories/appointment_management_repository_impl.dart';
export 'data/repositories/patient_appointments_repository_impl.dart';

// Data Sources
export 'data/datasources/appointment_remote_data_source.dart';

// Models
export 'data/models/appointment_model.dart';

// Use Cases
export 'domain/usecases/get_appointments_by_date_usecase.dart';
export 'domain/usecases/get_today_appointments_usecase.dart';
export 'domain/usecases/create_appointment_usecase.dart';
export 'domain/usecases/update_appointment_status_usecase.dart';
export 'domain/usecases/cancel_appointment_usecase.dart';
export 'domain/usecases/reschedule_appointment_usecase.dart';
export 'domain/usecases/get_appointment_by_id_usecase.dart';
export 'domain/usecases/get_appointments_by_doctor_usecase.dart';
export 'domain/usecases/delete_appointment_usecase.dart';

// MVP Completion Use Cases
export 'domain/usecases/get_available_slots_usecase.dart';
export 'domain/usecases/get_appointments_stats_usecase.dart';
export 'domain/usecases/get_patient_appointments_usecase.dart';

// Cubit
export 'presentation/cubit/appointments_cubit_imports.dart';

// Screens
export 'presentation/screens/appointments_overview_screen.dart';
export 'presentation/screens/schedule_appointment_screen.dart';
export 'presentation/screens/appointment_details_screen.dart';
