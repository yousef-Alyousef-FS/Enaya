// Entities (Database-backed objects with Identity)
export '../domain/entities/appointment_entity.dart';
export '../domain/entities/appointment_status.dart';
export '../domain/entities/appointment_stats.dart';

// Models (Data Transfer Objects & Temporary logic-heavy objects)
export '../data/models/appointment_model/appointment_model.dart';
export '../data/models/appointment_stats_model.dart';
export '../data/models/doctor_availability_model.dart';
export '../data/models/time_slot_model.dart';
export '../data/models/work_schedule_model.dart';
export '../data/models/patient_cancellation_result_model.dart';

// Repositories
export '../domain/repositories/appointment_repository.dart';
export '../domain/repositories/doctor_availability_repository.dart';
export '../data/repositories/appointment_repository_impl.dart';
export '../data/repositories/doctor_availability_repository_impl.dart';

// Data Sources
export '../data/datasources/appointment_remote_data_source.dart';

// Use Cases
export '../domain/usecases/get_appointments_usecase.dart';
export '../domain/usecases/get_appointment_details_usecase.dart';
export '../domain/usecases/create_appointment_usecase.dart';
export '../domain/usecases/update_appointment_status_usecase.dart';
export '../domain/usecases/cancel_appointment_usecase.dart';
export '../domain/usecases/reschedule_appointment_usecase.dart';
export '../domain/usecases/get_appointment_by_id_usecase.dart';
export '../domain/usecases/delete_appointment_usecase.dart';
export '../domain/usecases/generate_time_slots_usecase.dart';
export '../domain/usecases/search_available_slots_usecase.dart';

// MVP Completion Use Cases
export '../domain/usecases/get_available_slots_usecase.dart';
export '../domain/usecases/get_appointments_stats_usecase.dart';

// Cubit
export 'cubit/appointments_cubit_imports.dart';

// Pages
export 'appointments_page.dart';

// Screens
export 'screens/form/schedule_appointment_screen.dart';
export 'screens/details/appointment_details_screen.dart';
export 'screens/receptionist/receptionist_appointments_screen.dart';
export 'screens/patient/patient_appointments_screen.dart';
