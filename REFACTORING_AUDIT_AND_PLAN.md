# Refactoring Audit and Execution Plan

هذا الملف هو المرجع الوحيد لهذا refactoring العميق. الهدف ليس التنفيذ الآن، بل تثبيت خريطة واضحة لما يحتاج:

- تصحيح اسم
- نقل لمكانه الصحيح
- دمج مع عنصر آخر يؤدي نفس الهدف
- إزالة/اعتبار زائد أو trash

مرجعنا هنا:

- Clean Architecture
- أفضل ممارسات التسمية
- الفصل بين العام `core/global` وبين ما هو خاص بميزة `feature-specific`
- الاسم يجب أن يصف المسؤولية الفعلية، لا اسم المجلد الحالي فقط

## 1) ملفات ومجلدات تحتاج تصحيح اسم

- `lib/features/appointments/data/models/appointments_overview_mode.dart`
  - المشكلة: `mode` تبدو typo واضحة، والاسم الحالي غير سليم.
  - الاقتراح: إعادة التسمية إلى `appointments_overview_model.dart` أو، إذا كان هذا مجرد enum وليس model data class، إلى اسم أدق مثل `appointments_overview_view_mode.dart`.

- `lib/features/dashboard/shared/presentation/pages/abstract_dashboard_page.dart`
  - المشكلة: الاسم يوحي بطبقة مستقلة، لكن وظيفته أقرب إلى wrapper/contract لصفحات dashboard.
  - الاقتراح: تحديد اسم واحد واضح مع `base_dashboard_page.dart` أو دمجهما تحت مفهوم واحد.

- `lib/features/dashboard/shared/presentation/pages/base_dashboard_page.dart`
  - المشكلة: يتداخل وظيفيًا مع `abstract_dashboard_page.dart`.
  - الاقتراح: إذا بقي عنصر واحد، فليكن الاسم هو الذي يعبّر عن الدور الحقيقي: base أو shell أو scaffold.

- `lib/features/dashboard/shared/presentation/constants/constants.dart`
  - المشكلة: الاسم عام جدًا ولا يعبّر عن محتوى الملف.
  - الاقتراح: إما حذفه إن كان فقط barrel export، أو إعادة تسميته إلى `dashboard_constants.dart` barrel واضح، أو الاستغناء عنه نهائيًا.

- `lib/core/widgets/common/section_header.dart`
  - المشكلة: اسم الملف عام أكثر من اللازم مقارنةً باسم الكلاس `AppSectionHeader`.
  - الاقتراح: توحيد الاسم بين الملف والكلاس، أو نقل widget إلى feature إذا كانت استعمالاته كلها feature-oriented.

- `lib/core/widgets/cards/stat_card.dart`
  - المشكلة: الاسم عام، لكن الاستعمالات الحالية مرتبطة أكثر بـ dashboard/statistics.
  - الاقتراح: إذا بقي عامًا فليُوثّق كـ generic stat card، وإلا فالنقل إلى feature/shared presentation widget.

- `lib/core/services/mock_data_service.dart`
  - المشكلة: الاسم يتقاطع مع `core/services/mock/*` ويبدو كطبقة وسيطة زائدة.
  - الاقتراح: توضيح دوره أو دمجه داخل `mock/` وتحويل الاسم إلى شيء محدد مثل `mock_service_registry` إن كان ضروريًا.

## 2) عناصر زائدة أو أقرب إلى trash

- `lib/features/dashboard/shared/presentation/pages/pages.dart`
  - هذا Barrel file فقط.
  - إذا لم يكن هناك اعتماد حقيقي عليه في الاستيراد، فهو مرشح قوي للإزالة لتقليل طبقة إضافية غير لازمة.

- `lib/features/dashboard/shared/presentation/constants/constants.dart`
  - إذا كان فقط يعيد تصدير `dashboard_constants.dart`, فهو غالبًا زائد أو قابل للحذف بعد تحديث الاستيرادات.

- `lib/core/services/mock_data_service.dart`
  - إذا كان مجرد نقطة تجميع لمحتوى موجود أصلًا تحت `mock/`, فهو زائد ويستحق الدمج أو الإزالة.

## 3) عناصر تؤدي نفس الهدف وتحتاج دمج

- `lib/features/dashboard/shared/presentation/pages/abstract_dashboard_page.dart`
  - مع `lib/features/dashboard/shared/presentation/pages/base_dashboard_page.dart`
  - النتيجة المتوقعة: عنصر واحد فقط يملك مسؤولية صفحة dashboard العامة.

- `lib/features/dashboard/shared/presentation/constants/constants.dart`
  - مع `lib/features/dashboard/shared/presentation/constants/dashboard_constants.dart`
  - النتيجة المتوقعة: ملف constants واحد واضح أو barrel واحد فقط إذا كان ضروريًا.

- `lib/core/widgets/common/section_header.dart`
  - مع أي sections title widgets داخل features إذا كانت كلها تقدم نفس UX.
  - الهدف: عدم وجود أكثر من implementation لنفس فكرة title + actions + loading indicator.

- `lib/core/widgets/cards/stat_card.dart`
  - مع widgets الإحصائيات المشابهة داخل dashboard features، مثل:
    - `lib/features/dashboard/shared/presentation/widgets/dashboard_overview_builder.dart`
    - `lib/features/dashboard/receptionist/presentation/widgets/stats_section.dart`
    - `lib/features/appointments/presentation/widgets/receptionist/receptionist_stats_grid.dart`
  - الهدف: التمييز بين Card reusable حقيقي وبين dashboard-specific composition.

- `lib/core/services/mock_data_service.dart`
  - مع `lib/core/services/mock/mock_*`
  - الهدف: طبقة mock واحدة، لا مدخلان متوازيان لنفس البيانات التجريبية.

## 4) عناصر في مكان غير مناسب ويجب نقلها

### من `core` إلى feature-specific

- `lib/core/widgets/cards/auth_card_container.dart`
  - واضح من الاستعمال أنه خاص بميزة auth.
  - يجب أن ينتقل إلى `lib/features/auth/presentation/widgets/` أو ما يعادلها.

- `lib/core/widgets/common/logo.dart`
  - استعماله الحالي داخل auth screens وsplash، لذا هو أقرب إلى auth/onboarding branding widget وليس core عام.
  - مكانه الصحيح غالبًا ضمن auth presentation أو shared branding widgets إذا وُجدت feature مشتركة فعلًا.

- `lib/core/widgets/common/feature_coming_soon_state.dart`
  - إذا كان يستخدم فقط لميزة أو حالتين محددتين، فليس من core الحقيقي.
  - يجب فحص الاستعمال ثم نقله إن كان feature-specific.

- `lib/core/widgets/common/section_header.dart`
  - يستخدم فعليًا داخل dashboard وappointments screens.
  - إذا لم يكن مقصودًا كـ cross-feature primitive، فمكانه يجب أن يكون ضمن shared presentation أو feature shared widgets.

- `lib/core/widgets/tables/appointments_table/*`
  - المجلد باسم feature-specific جدًا (`appointments_table`) لكنه موجود داخل core.
  - هذا مؤشر قوي على أن كامل المجلد يجب نقله إلى `features/appointments/...` أو تحويله إلى generic table primitives مع إعادة تسمية ما هو feature-specific.

### من feature إلى shared أو مكان أنسب

- `lib/features/dashboard/shared/presentation/widgets/dashboard_shell.dart`
- `lib/features/dashboard/shared/presentation/widgets/dashboard_appbar.dart`
- `lib/features/dashboard/shared/presentation/widgets/dashboard_overview_builder.dart`
  - هذه مشتركة بين عدة dashboards، لكن يجب التأكد هل هي بالفعل shared داخل dashboard feature فقط أو تستحق طبقة shared أو core/presentation مشتركة.

- `lib/features/dashboard/shared/presentation/models/dashboard_nav_item.dart`
- `lib/features/dashboard/shared/presentation/models/dashboard_config.dart`
  - إن كانت تعكس dashboard-only concepts، فتبقى feature-shared.
  - إن لم تكن كذلك، فهي مرشحة للترتيب ضمن namespace أو package واضح.

### من feature إلى feature آخر

- `lib/features/dashboard/receptionist/presentation/widgets/appointments_table.dart`
  - يستعمل `GenericTableShell` من core ويبدو أنه خاص بـ receptionist dashboard.
  - إذا كان هذا الجدول مجرد wrapper للـ appointments feature، فربما يجب أن يعيش داخل `features/appointments` ويُستدعى من dashboard، لا العكس.

- `lib/features/dashboard/receptionist/presentation/widgets/stats_section.dart`
  - يعتمد على stats cards ويبدو أقرب إلى composition محلي لواجهة receptionist dashboard.
  - يجب التحقق هل يجب أن يبقى هنا أم يُبنى من shared widgets داخل dashboard shared.

- `lib/features/appointments/presentation/widgets/receptionist/*`
  - هذه widgets ذات طابع receptionist-specific داخل appointments.
  - يجب التأكد إن كانت فعلاً تخص appointments domain أو dashboard/receptionist UI، ثم وضعها في الجهة الأقرب للمسؤولية.

## 5) أمثلة واضحة على الأشياء العالمية مقابل الخاصة

### يجب أن يبقى عامًا أو core فقط إذا كان استخدامه واسعًا فعلًا

- `lib/core/network/*`
- `lib/core/cache/cache_helper.dart`
- `lib/core/di/injection.dart`
- `lib/core/theme/*`
- `lib/core/constants/*`
- `lib/core/usecases/usecase.dart`

### يجب أن يُعامل كـ feature-specific إذا كان مرتبطًا بميزة أو ميزة-ميزتين

- `lib/core/widgets/cards/auth_card_container.dart`
- `lib/core/widgets/common/logo.dart`
- `lib/core/widgets/tables/appointments_table/*`
- `lib/core/services/mock_data_service.dart` إذا كان يخدم mock لميزة بعينها

## 6) طريقة التنظيم المقترحة

1. نثبت أولًا الطبقات العامة الحقيقية: `core` فقط لما هو cross-cutting بوضوح.
2. أي widget أو service أو model يثبت أنه يخدم ميزة محددة فقط ينتقل إلى feature الخاص به.
3. أي folder يحمل اسم feature لكنه موجود داخل `core` يجب إعادة تقييمه فورًا.
4. أي ملفين يقدمان نفس المسؤولية ندمجهما قبل إنشاء أي بدائل جديدة.
5. أي barrel files غير ضرورية تُحذف بعد تحديث الاستيرادات.
6. نلتزم باسم واحد للمفهوم الواحد: base أو abstract أو shell، لكن ليس مزيجًا غير واضح منها.

## 7) خطة التنفيذ

### المرحلة 1: تثبيت الحدود

- جرد شامل لكل عناصر `lib/core` وتحديد ما هو فعلاً عام.
- جرد شامل لكل مجلدات `lib/features/*` وتحديد ما هو feature-specific أو shared.
- تحديد الملفات التي يجب أن تبقى في core فقط.

### المرحلة 2: التصحيحات الواضحة

- إصلاح typo `appointments_overview_mode.dart`.
- توحيد naming في dashboard shared pages.
- إزالة أو إعادة تسمية barrel files غير المعبّرة.

### المرحلة 3: النقل

- نقل auth-specific widgets من core إلى auth feature.
- نقل appointments-specific table/widgets من core إلى appointments feature.
- إعادة تموضع أي shared dashboard widget في المكان الذي يعكس استخدامه الحقيقي.

### المرحلة 4: الدمج

- دمج `abstract_dashboard_page.dart` مع `base_dashboard_page.dart` أو استبدالهما بمفهوم واحد.
- دمج أي constants files أو mock service layers المتداخلة.

### المرحلة 5: التنظيف النهائي

- حذف الملفات الزائدة بعد تحديث الاستيرادات.
- مراجعة naming consistency على مستوى folder/file/class.
- تأكيد أن أي شيء feature-specific لم يعد يعيش في core.

## 8) مبدأ القرار النهائي

- إذا كان الاسم لا يعبّر عن الدور الحقيقي: نعيد تسميته.
- إذا كان العنصر يخدم ميزة واحدة أو ميزتين فقط: لا يبقى في core.
- إذا كان هناك عنصران لنفس الفكرة: ندمجهما.
- إذا كان الملف لا يضيف مسؤولية فعلية: نحذفه بعد التأكد من عدم الحاجة إليه.

## 9) ملاحظات تنفيذية قبل البدء الفعلي

- هذا الملف مبني على قراءة أولية مركزة للبنية الحالية وليس على refactor تنفيذي بعد.
- أي قرار نهائي يجب أن يمر على الاستعمالات الفعلية والاستيرادات قبل النقل أو الحذف.
- ممنوع توسيع core بشكل عشوائي؛ الـ core يجب أن يبقى cross-cutting فقط.
