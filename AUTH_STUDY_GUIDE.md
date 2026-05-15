# Auth Study Guide

هذا الملف مخصص لتعلّم ميزة `auth` من داخل المشروع نفسه، من الواجهة إلى الداتا، مع سبب وجود كل طبقة وكل جزء في `core`.

## 1) الصورة الكبيرة

الـ auth في هذا المشروع يتبع أسلوب Clean Architecture بشكل عملي:

- `presentation` تعرض الشاشات وتجمع المدخلات وتستمع للحالة.
- `cubit` ينسّق الطلبات ويحوّل نتائج الـ use cases إلى state مناسب للواجهة.
- `domain` يحتوي العقود: entity, repository interface, use cases.
- `data` ينفّذ الاتصال الحقيقي أو mock ويحوّل البيانات القادمة من الخارج إلى `UserEntity`.
- `core` يحتوي الأشياء المشتركة بين كل الميزات، وليس خاصة بالـ auth فقط.

## 2) مسار التنفيذ الحقيقي

### من الشاشة إلى الداتا

1. المستخدم يضغط زر مثل `Login` في شاشة مثل [login_screen.dart](lib/features/auth/presentation/screens/login_screen.dart).
2. الشاشة تستدعي `AuthCubit.login(...)`.
3. الـ cubit يستدعي `LoginUseCase`.
4. الـ use case يستدعي `IAuthRepository.login(...)`.
5. `AuthRepositoryImpl` يفحص الاتصال عبر `NetworkInfo`.
6. إذا كان الاتصال متاحًا، يرسل الطلب إلى `AuthRemoteDataSourceImpl`.
7. الـ data source ينفذ الطلب عبر `Dio` أو يستخدم `AuthMockDataSourceImpl` في نمط الموك.
8. النتيجة ترجع كـ `UserModel` ثم تتحول إلى `UserEntity` وتصل إلى الـ cubit.
9. الـ cubit يحدّث `AuthState`، والشاشة تعيد البناء بناءً على هذه الحالة.

## 3) الملفات الأساسية ولماذا هي موجودة

### Presentation

- [login_screen.dart](lib/features/auth/presentation/screens/login_screen.dart): شاشة تسجيل الدخول.
- [signup_screen.dart](lib/features/auth/presentation/screens/signup_screen.dart): شاشة إنشاء الحساب.
- [forgot_password_screen.dart](lib/features/auth/presentation/screens/forgot_password_screen.dart): طلب استرجاع كلمة المرور.
- [reset_password_screen.dart](lib/features/auth/presentation/screens/reset_password_screen.dart): إعادة تعيين كلمة المرور.
- [change_password_screen.dart](lib/features/auth/presentation/screens/change_password_screen.dart): تغيير كلمة المرور للمستخدم المسجل.
- [verify_email_screen.dart](lib/features/auth/presentation/screens/verify_email_screen.dart): التحقق من البريد الإلكتروني.
- [splash_screen.dart](lib/features/auth/presentation/screens/splash_screen.dart): قرار البداية قبل الدخول للتطبيق.

### Cubit

- [auth_cubit.dart](lib/features/auth/presentation/cubit/auth_cubit.dart): يدير كل عمليات auth ويحوّل نتائج الـ use cases إلى state.
- [auth_state.dart](lib/features/auth/presentation/cubit/auth_state.dart): يحمل `isLoading`, `errorMessage`, `isSuccess`, `currentUser`.

### Domain

- [user_entity.dart](lib/features/auth/domain/entities/user_entity.dart): شكل المستخدم النظري داخل المشروع.
- [auth_repository.dart](lib/features/auth/domain/repositories/auth_repository.dart): العقد الذي يجب أن تنفذه data layer.
- `usecases/*`: كل حالة استخدام لها مسؤولية واحدة مثل login, signup, logout, verify email.

### Data

- [auth_repository_impl.dart](lib/features/auth/data/repositories/auth_repository_impl.dart): يربط domain مع datasource ويعالج الأخطاء.
- [auth_remote_data_source.dart](lib/features/auth/data/datasources/auth_remote_data_source.dart): الاتصال الحقيقي عبر API.
- [auth_mock_data_source.dart](lib/features/auth/data/datasources/auth_mock_data_source.dart): بديل محلي للاختبار والتطوير باستخدام mock data.
- [user_model.dart](lib/features/auth/data/models/user_model.dart): model مسؤول عن JSON parsing و serialization.

## 4) لماذا يوجد `core`

`core` ليس مكان auth، بل مكان الأدوات العامة التي تستخدمها عدة features.

### ملفات core التي يعتمد عليها auth

- [usecase.dart](lib/core/usecases/usecase.dart): يوفّر interface موحدًا لكل use case حتى تكون كل الحالات بنفس الشكل.
- [failures.dart](lib/core/error/failures.dart): يمثل أنواع الأخطاء القابلة للفهم من domain والواجهة.
- [network_info.dart](lib/core/network/network_info.dart): يتحقق من وجود إنترنت قبل تنفيذ الطلب.
- [api_error_handler.dart](lib/core/network/api_error_handler.dart): يحول الاستثناءات إلى `Failure` مفهومة.
- [token_manager.dart](lib/core/services/token_manager.dart): يحفظ token, refresh token, expiry, وبيانات المستخدم.
- [dio_factory.dart](lib/core/network/dio_factory.dart): يصنع `Dio` ويضبط الـ base config للطلبات.
- [api_constants.dart](lib/core/constants/api_constants.dart): يجمع endpoints في مكان واحد بدل تكرارها.
- [cache_helper.dart](lib/core/cache/cache_helper.dart): يساعد `TokenManager` في التخزين المحلي.

### لماذا هذا مهم

- لأن auth ليس فقط login.
- لأنه يحتاج network, token storage, error mapping, routing, and shared use case pattern.
- لأن أي feature أخرى قد تستخدم نفس الأدوات لاحقًا.

## 5) شرح مبسّط لكل طبقة

### Presentation

هي الطبقة التي تراها أنت. هنا يوجد layout, text fields, buttons, validation, and navigation.

### Cubit

هو المنسق. لا يفترض أن يعرف تفاصيل API أو التخزين. فقط ينادي use case ويضبط state.

### Domain

هو قانون المشروع. يحدد ما الذي يجب أن يحدث منطقيًا بغض النظر عن API أو UI.

### Data

هي الطبقة التي تعرف كيف تتكلم مع الشبكة أو mock أو التخزين.

### Core

هي الخدمات المشتركة التي لا تخص ميزة واحدة فقط.

## 6) ما الذي ستدرسه أولًا

إذا أردت فهم المشروع بدون ضياع، ابدأ بهذا الترتيب:

1. [user_entity.dart](lib/features/auth/domain/entities/user_entity.dart)
2. [auth_state.dart](lib/features/auth/presentation/cubit/auth_state.dart)
3. [auth_cubit.dart](lib/features/auth/presentation/cubit/auth_cubit.dart)
4. [auth_repository.dart](lib/features/auth/domain/repositories/auth_repository.dart)
5. [login_usecase.dart](lib/features/auth/domain/usecases/login_usecase.dart)
6. [auth_repository_impl.dart](lib/features/auth/data/repositories/auth_repository_impl.dart)
7. [auth_remote_data_source.dart](lib/features/auth/data/datasources/auth_remote_data_source.dart)
8. [token_manager.dart](lib/core/services/token_manager.dart)
9. [network_info.dart](lib/core/network/network_info.dart)
10. [api_error_handler.dart](lib/core/network/api_error_handler.dart)
11. شاشة واحدة مثل [login_screen.dart](lib/features/auth/presentation/screens/login_screen.dart)

## 7) ما الذي يبدو زائدًا أو قابلًا للتفكيك لاحقًا

- `auth_imports.dart` موجود فقط كممر استيراد، وليس منطقًا حقيقيًا.
- شاشة auth غالبًا تحمل shared widgets كثيرة، وهذا طبيعي لكن يمكن فصلها أكثر إذا صار الملف كبير.
- في `auth` يوجد أكثر من use case، وهذا صحيح إذا كانت العمليات حقيقية ومنفصلة، لكنه يصبح زائدًا فقط إذا كانت نفس الفكرة مكررة بلا فرق.

## 8) كيف سنكمل الشرح إذا أردت

يمكننا متابعة المشروع بهذا الأسلوب:

1. نبدأ بـ auth فقط.
2. نأخذ كل ملف على حدة.
3. أشرح لك: ماذا يفعل، لماذا هو موجود، ما الذي يعتمد عليه، وما الذي يمكن حذفه أو دمجه.
4. بعد auth ننتقل إلى appointments بنفس المنهج.

## 9) قاعدة العمل التي أنصح بها

إذا لم تستطع ربط ملف بآخر، اسأل هذه الأسئلة بالترتيب:

- هل هذا UI أم logic أم data؟
- من يستدعيه؟
- ما الذي يرجع منه؟
- هل هو خاص بميزة واحدة أم عام في المشروع كله؟
- هل يمكن استبداله بملف موجود بدل تكراره؟

## 10) كيف تكتب الكود بيدك بدون ضياع

إذا كنت تفهم الكود لكن تتعب عند الكتابة، استخدم هذا التسلسل دائمًا:

1. ابدأ من التوقيع فقط: اسم الكلاس أو الدالة، وما الذي تستقبله، وما الذي ترجعه.
2. اكتب الهيكل الفارغ أولًا: `class`, `constructor`, `state fields`, `methods` بدون منطق.
3. املأ أعلى طبقة أولًا: في auth ابدأ بـ `screen` أو `cubit`، وليس بالداتا.
4. اربط كل خطوة بأدنى اعتماد ممكن: UI -> cubit -> usecase -> repository -> datasource.
5. لا تكتب منطقًا غير مطلوب الآن. إذا لم يحتجه المسار الحالي، اتركه.
6. بعد كل جزء صغير، اسأل: هل هذا المسؤول عن العرض؟ أم التحكم؟ أم البيانات؟
7. إذا ضعت، ارجع لملف موجود مشابه ونسخ شكله العام فقط، ثم غيّر الأسماء والاعتماديات.

### قالب عملي سريع

عندما تبدأ ملفًا جديدًا، امشِ بهذا الترتيب:

- imports
- class name
- fields
- constructor
- public methods
- private helpers
- state/effects

### قاعدة مهمة

لا تحاول كتابة المشروع كله مرة واحدة. اكتب أصغر جزء يشتغل، ثم وسّعه.

## 11) اقتراحاتي الحالية للـ auth نفسه

حسب الكود الموجود الآن، هذا هو الترتيب العملي الذي أنصحك به:

### ما أبقيه الآن

- `login`, `signup`, `logout` لأنها مسارات أساسية ومستخدمة فعلاً.
- `AuthTextField` لأنه مستخدم في أغلب شاشات auth.
- `AuthCardContainer` لأنه يوحّد شكل الشاشات بدل تكرار layout.
- `AuthCubit` و `AuthState` لأنهما مركز التحكم بالحالة.
- `AuthRepositoryImpl` لأنهما نقطة الربط بين domain و data.

### ما أراجعه وأبسّطه

- `AuthFormMixin`: موجود في أكثر من شاشة، لكن جزءًا من وظائفه لا يظهر أنه يغيّر سلوكًا مهمًا الآن. إذا لم تحتج `successAnimation` فعليًا في UI، اجعله أبسط أو أزله لاحقًا.
- `login_screen.dart`: فيها خيار biometric مع snackbar فقط. هذا placeholder وليس feature مكتملة، لذلك إما تحذفه الآن أو تتركه كتعليق واضح حتى لا يشتتك.
- `buildErrorMessage` داخل المixin: إذا كانت الشاشات لا تستخدمه، فوجوده لا يضيف قيمة حقيقية.

### ما يمكن تأجيله أو حذفه إذا لم يكن مستخدمًا فعلاً

- أي animation أو controller لا يغيّر تجربة المستخدم بشكل واضح.
- أي helper مجرد موجود لأننا توقعنا الحاجة إليه لاحقًا.
- أي direct navigation أو state flag مكرر أكثر من مرة بدون فائدة إضافية.

## 12) سيناريوهات عملية للتعديل

### السيناريو 1: أريد أقل كود ممكن

اعمل التالي:

1. اترك `AuthTextField` كما هو.
2. أبقِ `AuthCardContainer` كما هو.
3. في كل شاشة، اكتب فقط form + validation + button + listener.
4. احذف أي animation غير لازم.
5. لا تضف biometric أو fancy UI قبل أن يكتمل السلوك الأساسي.

### السيناريو 2: أريد هيكلة أوضح

اعمل التالي:

1. اجعل كل شاشة مسؤولة عن العرض فقط.
2. اجعل `AuthCubit` مسؤولًا عن التشغيل والحالة فقط.
3. اجعل validation داخل الشاشة، لا داخل cubit.
4. اجعل التنقل بعد النجاح في `listener` فقط.
5. اجعل الـ repository و datasource بلا UI logic نهائيًا.

### السيناريو 3: أريد حذف الزائد

احذف أو أوقف مؤقتًا:

- biometric login placeholder.
- أي success animation لا تراه فعليًا في الواجهة.
- أي helper أو mixin لا تستعمله الشاشة بشكل مباشر.

### السيناريو 4: أريد إعادة الهيكلة لكن بدون كسر المشروع

اتبع هذا القانون:

1. لا تنقل أكثر من شيء واحد في كل مرة.
2. انقل reusable widget فقط إذا استُخدم في أكثر من شاشة.
3. إذا كان الملف يعمل والاختصار واضح، لا تعيد هيكلته فقط لأن شكله طويل.
4. إذا وجدت سطرًا لا تعرف لماذا وُضع، علّق عليه مؤقتًا بدل حذفه فورًا.

## 13) كيف تكتب يدويًا بأقل كمية كود

عندما تريد كتابة شاشة auth من الصفر، اكتب بهذا الترتيب فقط:

1. `StatefulWidget` أو `StatelessWidget`.
2. `Form` + controllers.
3. `validator` بسيط لكل حقل.
4. `BlocProvider` أو `BlocConsumer`.
5. `onPressed` يستدعي cubit.
6. `listener` يعالج النجاح والخطأ.
7. `Navigator` أو `go_router` بعد النجاح فقط.

### قاعدة التبسيط

إذا شعرت أن الشاشة أصبحت طويلة، فاسأل:

- هل هذا UI فعلي أم مجرد تجميل؟
- هل هذا helper يُستخدم في أكثر من مكان؟
- هل هذا state أو animation ضروري فعلاً؟
