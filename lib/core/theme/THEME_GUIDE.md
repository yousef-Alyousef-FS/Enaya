# 🎨 نظام إدارة الـ Theme - دليل الاستخدام

## نظرة عامة

تم تطوير نظام إدارة الـ Theme المركزي الذي يدعم الوضع الليلي (Dark Mode) والوضع الفاتح (Light Mode) بشكل ديناميكي.

## المكونات الرئيسية

### 1. **ThemeCubit** (`core/theme/cubit/theme_cubit.dart`)

- يدير حالة الـ theme (Light/Dark/System)
- يحفظ اختيار المستخدم في `SettingsService`
- يوفر طرق للتحكم بالـ theme

```dart
// الحصول على ThemeCubit
final themeCubit = context.read<ThemeCubit>();

// تغيير الـ theme
themeCubit.setThemeMode(ThemeMode.dark);

// تبديل بين الأوضاع
themeCubit.toggleTheme();
```

### 2. **SettingsService** (`core/services/settings_service.dart`)

- تحفظ تفضيلات الـ theme في الـ cache
- توفر الوصول السريع للإعدادات المحفوظة

### 3. **ThemeHelper** (`core/theme/theme_helper.dart`)

- فئة مساعدة توفر طرق موحدة للوصول إلى الألوان
- تضمن التوافق التام مع الـ theme الحالي
- توفر دعم كامل للـ dark mode

## ✅ الطريقة الصحيحة للألوان

### ❌ **الطريقة القديمة (لا تستخدم)**

```dart
// هذه لن تتكيف مع الوضع الليلي
Container(
  color: AppColors.primary,
  child: Text('Hello', style: TextStyle(color: Colors.white)),
)
```

### ✅ **الطريقة الجديدة (استخدم هذه)**

```dart
import 'package:enaya/core/theme/theme_helper.dart';

Container(
  color: ThemeHelper.primary(context),
  child: Text(
    'Hello',
    style: TextStyle(color: ThemeHelper.textPrimary(context)),
  ),
)
```

### ✅ **البديل - استخدم Theme.of مباشرة**

```dart
Container(
  color: Theme.of(context).primaryColor,
  child: Text(
    'Hello',
    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
  ),
)
```

## 🎯 أمثلة الاستخدام

### تغيير الـ Background

```dart
// ❌ خطأ
Scaffold(backgroundColor: Colors.white)

// ✅ صحيح
Scaffold(backgroundColor: ThemeHelper.background(context))
// أو
Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor)
```

### تلوين النصوص

```dart
// ❌ خطأ
Text('Hello', style: TextStyle(color: Colors.black))

// ✅ صحيح
Text(
  'Hello',
  style: TextStyle(color: ThemeHelper.textPrimary(context)),
)
// أو
Text(
  'Hello',
  style: Theme.of(context).textTheme.bodyLarge,
)
```

### الألوان المخصصة بـ Opacity

```dart
// ✅ صحيح
Container(
  color: ThemeHelper.border(context, opacity: 0.1),
  // يحصل على اللون الأساسي من الـ theme مع تخفيف 10%
)
```

### Shimmer Loading

```dart
import 'package:shimmer/shimmer.dart';

Shimmer.fromColors(
  baseColor: ThemeHelper.shimmerBase(context),
  highlightColor: ThemeHelper.shimmerHighlight(context),
  child: Container(...),
)
```

### التحقق من الوضع الليلي

```dart
if (ThemeHelper.isDarkMode(context)) {
  // تطبيق منطق خاص بالوضع الليلي
} else {
  // تطبيق منطق خاص بالوضع الفاتح
}
```

## 📋 جدول مطابقة الألوان

| الاستخدام  | ThemeHelper       | Theme.of                      |
| ---------- | ----------------- | ----------------------------- |
| نص رئيسي   | `textPrimary()`   | `textTheme.bodyLarge?.color`  |
| نص ثانوي   | `textSecondary()` | `textTheme.bodyMedium?.color` |
| خلفية      | `background()`    | `scaffoldBackgroundColor`     |
| سطح (Card) | `surface()`       | `colorScheme.surface`         |
| لون أساسي  | `primary()`       | `primaryColor`                |
| لون ثانوي  | `secondary()`     | `colorScheme.secondary`       |
| خطأ        | `error()`         | `colorScheme.error`           |
| أيقونات    | `iconColor()`     | `iconTheme.color`             |
| حد فاصل    | `divider()`       | `dividerColor`                |

## 🚀 الخطوات التطبيقية

### عند كتابة widget جديد:

1. **استورد ThemeHelper** (أو استخدم Theme.of مباشرة)

```dart
import 'package:enaya/core/theme/theme_helper.dart';
```

2. **استخدم ThemeHelper بدلاً من AppColors**

```dart
color: ThemeHelper.primary(context)
```

3. **اختبر في الوضع الليلي والفاتح**
   - اذهب للإعدادات وغيّر الـ theme
   - تأكد أن جميع الألوان تتكيف بشكل صحيح

## 💡 نصائح مهمة

1. **لا تستخدم AppColors مباشرة** إلا في ملفات الـ theme نفسها
2. **دائماً استخدم BuildContext** للوصول إلى الـ theme الحالي
3. **اختبر في كل من الأوضاع الفاتحة والغامقة** قبل الـ commit
4. **استخدم ScreenUtil أو MediaQuery** للأحجام، لا للألوان
5. **الـ Constants مثل padding و font sizes لا تحتاج تغيير** حسب الـ theme

## 🐛 استكشاف الأخطاء

### المشكلة: الألوان لا تتغير عند تبديل الـ theme

**الحل:** تأكد من استخدام `Theme.of(context)` أو `ThemeHelper` بدلاً من ثوابت مباشرة

### المشكلة: القيمة null عند الوصول إلى textTheme

**الحل:** استخدم safe navigation مع fallback

```dart
color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black
```

### المشكلة: الـ app لا يحدّث الـ theme عند التبديل

**الحل:** تأكد من تسجيل `ThemeCubit` في DI وأنه موجود في `main.dart`

## 📚 مراجع إضافية

- [Flutter Theme Documentation](https://api.flutter.dev/flutter/material/ThemeData-class.html)
- [ColorScheme Documentation](https://api.flutter.dev/flutter/material/ColorScheme-class.html)
- [BLoC Pattern](https://bloclibrary.dev/)
