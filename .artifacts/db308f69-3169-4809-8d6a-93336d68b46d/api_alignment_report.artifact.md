# تقرير مواءمة طبقة البيانات مع API V1.4
(API Alignment & Gap Analysis Report)

تم إجراء فحص شامل لجميع ميزات المشروع ومقارنة طبقات البيانات (DataSources, Models, Repositories) مع توثيق `API_V1.4.md`. إليك النتائج:

## 1. الفجوات والنواقص (Missing Endpoints & Fields)

### أ. ميزة المصادقة (Authentication)
- **Refresh Token**:Endpoint `POST /api/auth/refresh-token` موجود في التوثيق ولكن غير مفعّل في `AuthRemoteDataSource`.
- **Signup Response**: التوثيق يشير إلى وجود حقل `expiresAt` في استجابة التسجيل، يجب التأكد من حفظه بشكل صحيح لتنبيه المستخدم قبل انتهاء الجلسة (30 يوم).

### ب. ميزة الملف الشخصي (Profile)
- **المسارات (Paths)**: تستخدم `UpdateProfileRemoteDataSource` مسارات قديمة مثل `/patient/update-profile`. يجب تحديثها لتطابق V1.4:
  - تحديث الملف الشخصي: `PUT /api/patients/profile`
  - إكمال الملف الشخصي: `POST /api/patients/complete-profile`
- **حقل Emergency Contact**: موجود في التوثيق كـ `emergency_contact` في استجابة وجسم طلب الملف الشخصي، يجب التأكد من وجوده في الـ `Entity` والـ `Model`.

### ج. جلسات الطبيب والوصفات (Sessions & Prescriptions) - **نقطة حرجة**
هذه الميزة تعاني من اختلاف كبير بين الكود والتوثيق الجديد:
- **بدء الجلسة**: الكود يستخدم `POST /appointment-sessions` بينما التوثيق يطلب `POST /api/doctor/appointments/{appointment}/sessions/start`.
- **إنهاء الجلسة**: الكود يستخدم `PUT /appointment-sessions/$id` بينما التوثيق يطلب `POST /api/doctor/appointments/{appointment}/sessions/end`.
- **الوصفات الطبية**: المسارات في الكود عامة (`/prescriptions`) بينما في التوثيق مرتبطة بالجلسة: `POST /api/doctor/sessions/{session}/prescriptions`.

## 2. معالجة التكرار (Redundancy & UX Improvements)

### أ. تكرار طلب رقم الموبايل (Signup vs Complete Profile)
- **المشكلة**: كان النظام يطلب رقم الموبايل في شاشة إنشاء الحساب، ثم يطلبه مرة أخرى في شاشة إكمال البيانات.
- **الحل المقترح (تم تنفيذه برمجياً)**: قمت بتعديل شاشة `CompleteProfileScreen` لتقوم تلقائياً بجلب رقم الهاتف من الجلسة الحالية (`PatientSession`) وتعبئته في الحقل المخصص. هذا يقلل من الجهد المطلوب من المستخدم.

## 3. العمليات التي تم تنفيذها (Actions Taken)

| الميزة | التعديل | الحالة |
| :--- | :--- | :--- |
| **Sessions** | تحديث المسارات لتطابق الهيكل الجديد المرتبط بـ `doctor/appointments/{appointment}/sessions/`. | **تم التنفيذ** |
| **Prescriptions** | تحديث المسارات لتبدأ بـ `doctor/sessions/{session}/prescriptions` وتعديل الـ UseCases لتمرير الـ `sessionId`. | **تم التنفيذ** |
| **Profile** | تحديث مسارات المرضى لتصبح `/api/patients/profile` بدلاً من المسارات القديمة. | **تم التنفيذ** |
| **UX** | تعبئة رقم الهاتف تلقائياً في شاشة إكمال البيانات من الجلسة الحالية. | **تم التنفيذ** |
| **Constants** | إضافة الدوال المساعدة لإنشاء المسارات الديناميكية في `ApiConstants`. | **تم التنفيذ** |

## ملاحظات إضافية
- تم التأكد من أن جميع الـ Models تتعامل مع الـ `snake_case` القادم من الباك اند بشكل صحيح.
- تم تحديث الـ Cubits لتتوافق مع التغييرات في طبقة الـ Domain والـ Data.

---
> [!TIP]
> تم إصلاح مشكلة تكرار رقم الهاتف في واجهة المستخدم، وسيظهر الرقم تلقائياً للمريض عند انتقاله لشاشة إكمال البيانات.
