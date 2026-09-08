# تقرير تضاربات الدمج (Merge Conflicts Report)

تمت محاولة دمج فرع `origin/doctor-session-prescription-module` في فرع `integration` بتاريخ 2026-08-10، ونتج عن ذلك التضاربات التالية في الملفات المدرجة أدناه. تم التراجع عن عملية الدمج (Abort) بناءً على طلب المستخدم لإبقاء فرع `integration` متوافقاً مع فرع `notifications` فقط حالياً.

## الملفات التي حدثت فيها تضاربات:

- [ ] `.metadata`
- [ ] `assets/translations/ar-SA.json`
- [ ] `assets/translations/en-US.json`
- [ ] `lib/core/di/injection.dart`
- [ ] `lib/core/routing/app_router.dart`
- [ ] `lib/features/auth/presentation/screens/splash_screen.dart`
- [ ] `lib/features/dashboard/doctor/presentation/pages/doctor_dashboard_page.dart`
- [ ] `lib/features/dashboard/patient/presentation/pages/patient_dashboard_page.dart`
- [ ] `lib/features/dashboard/receptionist/presentation/pages/receptionist_dashboard_page.dart`
- [ ] `lib/features/dashboard/shared/presentation/navigation/dashboard_nav_collections.dart`
- [ ] `lib/features/dashboard/shared/presentation/widgets/dashboard_appbar.dart`
- [ ] `lib/main.dart`
- [ ] `pubspec.yaml`

> [!IMPORTANT]
> تم إلغاء عملية الدمج بنجاح، وفرع `integration` الآن يحتوي فقط على التغييرات القادمة من فرع `notifications`.
