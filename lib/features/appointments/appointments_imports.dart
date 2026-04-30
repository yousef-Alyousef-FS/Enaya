// Entities
export 'domain/entities/appointment_entity.dart';
export 'domain/entities/appointment_stats_entity.dart';
export 'domain/entities/appointment_status.dart';
export 'domain/entities/patient_appointments_entity.dart';
export 'domain/entities/patient_cancellation_result.dart';
export 'domain/entities/work_schedule_entry.dart';

// Repositories
export 'domain/repositories/appointment_management_repository.dart';
export 'domain/repositories/patient_appointments_repository.dart';
export 'data/repositories/appointment_management_repository_impl.dart';
export 'data/repositories/patient_appointments_repository_impl.dart';

// Data Sources
export 'data/datasources/appointment_remote_data_source.dart';
export 'data/datasources/appointment_mock_data_source.dart';

// Models
export 'data/models/appointment_model.dart';

// Use Cases
export 'domain/usecases/get_appointments_usecase.dart';
export 'domain/usecases/create_appointment_usecase.dart';
export 'domain/usecases/update_appointment_status_usecase.dart';
export 'domain/usecases/cancel_appointment_usecase.dart';
export 'domain/usecases/reschedule_appointment_usecase.dart';
export 'domain/usecases/get_appointment_by_id_usecase.dart';
export 'domain/usecases/delete_appointment_usecase.dart';
export 'domain/usecases/get_doctor_schedule_usecase.dart';
export 'domain/usecases/save_doctor_schedule_usecase.dart';

// MVP Completion Use Cases
export 'domain/usecases/get_available_slots_usecase.dart';
export 'domain/usecases/get_appointments_stats_usecase.dart';

// Cubit
export 'presentation/cubit/appointments_cubit_imports.dart';

// Pages
export 'presentation/appointments_page.dart';

// Screens
export 'presentation/screens/schedule_appointment_screen.dart';
export 'presentation/screens/appointment_details_screen.dart';
export 'presentation/screens/doctor_work_schedule_screen.dart';
