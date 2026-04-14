# Enaya (عناية) - Medical Center Management System

**Enaya** هو نظام متكامل لإدارة المراكز الطبية، مصمم لتقديم تجربة سلسة للأطباء، المرضى، وموظفي الاستقبال. يعتمد التطبيق على بنية برمجية قوية تضمن القابلية للتوسع والأداء العالي.

## 🚀 الرؤية البرمجية
تم بناء المشروع باستخدام **Clean Architecture** مع اتباع نمط **Feature-first Layering** لضمان فصل الاهتمامات (Separation of Concerns) وسهولة الاختبار.

## 🛠 التقنيات المستخدمة (Tech Stack)
- **Framework:** Flutter (Latest Stable)
- **State Management:** Provider
- **Navigation:** GoRouter
- **Dependency Injection:** GetIt & Injectable
- **Networking:** Dio
- **Local Storage:** Shared Preferences & Secure Storage
- **Functional Programming:** Dartz (Either)
- **UI & UX:** Flutter ScreenUtil, Shimmer, Awesome Dialog
- **Localization:** Easy Localization (العربية والانجليزية)

## 📁 هيكلية المشروع (Project Structure)
```text
lib/
├── core/            # المكونات المشتركة، الثيمات، والخدمات المركزية
├── features/        # الميزات الوظيفية (كل ميزة تحتوي على Data, Domain, Presentation)
│   ├── auth/        # نظام الهوية والتحقق
│   ├── dashboard/   # لوحات التحكم (طبيب، مريض، استقبال)
│   ├── appointments/# إدارة المواعيد (قيد التطوير)
│   ├── patients/    # سجلات المرضى (قيد التطوير)
│   └── ...          # ميزات أخرى
└── main.dart        # نقطة انطلاق التطبيق
```

## 🏁 الميزات الحالية
- [x] نظام تسجيل الدخول وإنشاء الحساب (Auth System).
- [x] دعم تعدد اللغات (العربية/الإنجليزية).
- [x] واجهات مستخدم متجاوبة (Responsive UI) للجوال والتابلت.
- [x] لوحات تحكم مخصصة لكل دور (Doctor, Patient, Receptionist).
- [ ] إدارة المواعيد والجدولة (قادم قريباً).
- [ ] الوصفات الطبية الإلكترونية (قادم قريباً).

## 📥 التنصيب والتشغيل
1. قم بتحميل المستودع: `git clone https://github.com/your-repo/enaya.git`
2. تحميل المكتبات: `flutter pub get`
3. توليد الملفات البرمجية (Freezed/JSON): 
   `flutter pub run build_runner build --delete-conflicting-outputs`
4. تشغيل التطبيق: `flutter run`
