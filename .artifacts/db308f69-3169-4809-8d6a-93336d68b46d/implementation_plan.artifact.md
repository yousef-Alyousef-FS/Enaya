# Consolidate Profile Feature & Audit Medical Session

This plan aims to unify the `profile` and `update_profile` features into a single mature module and audit the `session` and `prescriptions` features for architectural consistency and error handling standards.

## User Review Required

> [!IMPORTANT]
> The `update_profile` directory will be deleted, and its contents will be moved into `profile`. This will change the import paths in several files.

## Proposed Changes

### [Feature: Profile Consolidation]

#### [MOVE] [update_profile files](file:///D:/Personals/Coding/flutter/projects/enaya/lib/features/update_profile/)
- Move `data/`, `domain/`, and `presentation/` from `update_profile` to `profile`.
- Rename `lib/features/profile/presentaion/` to `lib/features/profile/presentation/`.

#### [MODIFY] [Profile DI Container](file:///D:/Personals/Coding/flutter/projects/enaya/lib/core/di/injection_container_profile.dart)
- Unify registration for both profile viewing and updating.

---

### [Feature: Medical Session Audit]

#### [MODIFY] [Session Repository](file:///D:/Personals/Coding/flutter/projects/enaya/lib/features/session/domain/repositories/session_repository.dart)
- Ensure all methods return `Future<Either<Failure, T>>`.

#### [MODIFY] [Prescription Repository](file:///D:/Personals/Coding/flutter/projects/enaya/lib/features/prescriptions/domain/repositories/prescription_repository.dart)
- Ensure all methods return `Future<Either<Failure, T>>`.

#### [DELETE] [Redundant Files]
- Remove any remaining `mock` or `test` files outside the dedicated `test/` directory.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no broken imports or type mismatches.
- Run `flutter test` (if applicable) to verify core logic.

### Manual Verification
- Verify navigation to Profile and Update Profile screens in the app.
- Verify starting and ending a session (simulated with current logic).
