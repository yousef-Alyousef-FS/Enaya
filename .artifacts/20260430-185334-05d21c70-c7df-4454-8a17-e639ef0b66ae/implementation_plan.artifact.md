# Dashboard Navigation and Localization Fix Plan

This plan aims to resolve the "Coming Soon" issue in the Doctor and Patient dashboards by linking the appointments navigation items to the actual screens, and to ensure all navigation labels are correctly localized.

## User Review Required

- **Navigation Flow**: Clicking the Appointments tab will now load the professional screens we built in the previous phase.
- **Localization Keys**: I will add `doctor_work_schedule` and other potentially missing keys to the translation files.

## Proposed Changes

### 1. Dashboard Pages

#### [DoctorDashboardPage](file:///D:/Personals/Coding/flutter/%20projects/enaya/lib/features/dashboard/doctor/presentation/pages/doctor_dashboard_page.dart)
- Update `bodyBuilder` to handle index 1 (Appointments) and index 2 (Schedule).
- Index 1 will load `AppointmentsPage(mode: AppointmentsOverviewMode.doctor)`.
- Index 2 will load `DoctorWorkScheduleScreen` (placeholder for now if not ready, but better than general coming soon).

#### [PatientDashboardPage](file:///D:/Personals/Coding/flutter/%20projects/enaya/lib/features/dashboard/patient/presentation/pages/patient_dashboard_page.dart)
- Update `bodyBuilder` to handle index 1 (Appointments).
- Index 1 will load `AppointmentsPage(mode: AppointmentsOverviewMode.patient)`.

### 2. Navigation Configuration

#### [dashboard_nav_collections.dart](file:///D:/Personals/Coding/flutter/%20projects/enaya/lib/features/dashboard/shared/presentation/navigation/dashboard_nav_collections.dart)
- Verify `labelKey` for all items.
- Ensure `isEnabled` is true for appointments.

### 3. Localization

#### [en-US.json](file:///D:/Personals/Coding/flutter/%20projects/enaya/assets/translations/en-US.json)
- Add `"doctor_work_schedule": "Work Schedule"`.
- Ensure consistency.

#### [ar-SA.json](file:///D:/Personals/Coding/flutter/%20projects/enaya/assets/translations/ar-SA.json)
- Add `"doctor_work_schedule": "جدول العمل"`.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no broken imports or type errors.

### Manual Verification
- Open Doctor Dashboard -> Click Appointments -> Verify the professional timeline screen loads.
- Open Patient Dashboard -> Click Appointments -> Verify the mobile-first appointments screen loads.
- Switch language to Arabic and English -> Verify all sidebar/bottom nav labels are translated.
