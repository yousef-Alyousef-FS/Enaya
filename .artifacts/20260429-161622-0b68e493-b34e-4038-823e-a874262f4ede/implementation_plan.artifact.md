# Project Refactoring and Architecture Cleanup

This plan outlines the steps to "clean up the bedroom" - organizing the codebase, removing redundancies, and strictly adhering to Clean Architecture principles.

## User Review Required

> [!IMPORTANT]
> - **UseCase Consolidation**: I plan to merge 4-5 appointment-related UseCases into one. This will change the constructor of several Cubits.
> - **Error Handling**: I will remove local translation logic from Cubits. All UI error messages will come directly from `Failure.message`.
> - **Mock Data**: I suggest moving mock data to a more centralized location if it continues to grow.

## Proposed Changes

### Core Layer (Error Handling & Types)

#### [failures.dart](file:///D:/Personals/Coding/flutter/%20projects/enaya/lib/core/error/failures.dart)
- Ensure all failures have a consistent structure.

#### [api_error_handler.dart](file:///D:/Personals/Coding/flutter/%20projects/enaya/lib/core/network/api_error_handler.dart)
- Audit all status codes and messages to ensure they are exhaustive and properly localized.

---

### Domain Layer (UseCases & Entities)

#### [NEW] [get_appointments_usecase.dart](file:///D:/Personals/Coding/flutter/%20projects/enaya/lib/features/appointments/domain/usecases/get_appointments_usecase.dart)
- A unified UseCase that handles all fetching logic (by date, doctor, patient, etc.) using optional parameters in `GetAppointmentsParams`.

#### [DELETE] `get_today_appointments_usecase.dart`, `get_appointments_by_date_usecase.dart`, `get_appointments_by_doctor_usecase.dart`, `get_patient_appointments_usecase.dart`

#### [appointment_management_repository.dart](file:///D:/Personals/Coding/flutter/%20projects/enaya/lib/features/appointments/domain/repositories/appointment_management_repository.dart)
- Simplify the interface to match the consolidated UseCase.

---

### Data Layer (Mappers & Models)

#### [appointment_model.dart](file:///D:/Personals/Coding/flutter/%20projects/enaya/lib/features/appointments/data/models/appointment_model.dart)
- Integrate `toEntity` and `fromEntity` directly into the class or keep as extension but ensure it's the only source of truth.

#### [appointment_remote_data_source.dart](file:///D:/Personals/Coding/flutter/%20projects/enaya/lib/features/appointments/data/datasources/appointment_remote_data_source.dart)
- Update signatures to support the unified fetch params.

---

### Presentation Layer (Cubits & Widgets)

#### [appointments_overview_cubit.dart](file:///D:/Personals/Coding/flutter/%20projects/enaya/lib/features/appointments/presentation/cubit/appointments_overview_cubit.dart)
- Remove `_resolveFailureMessage`.
- Inject only the unified `GetAppointmentsUseCase`.
- Fix `dynamic` usages and improve type safety.

#### [Widget Reorganization]
- Move `appointment_table_config.dart` and other specific widgets from `core` to `features/appointments/presentation/widgets/shared/`.

---

## Verification Plan

### Automated Tests
- I will verify the code compiles successfully after each major refactoring step.
- Since this is a structural refactor, I will focus on ensuring no broken imports or type mismatches.

### Manual Verification
- Verify that the "Appointments List" still loads correctly with all filters (Date, Doctor, Search).
- Verify that adding a new appointment still works.
- Check that error messages (like connection timeout) still appear correctly in the UI.
