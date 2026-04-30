import 'package:enaya/core/widgets/cards/stat_card.dart';
import 'package:flutter/material.dart';

import '../models/dashboard_overview_config.dart';

/// Reusable dashboard overview builder that centralizes common layout patterns
/// across Receptionist, Doctor, and Patient dashboards.
///
/// Accepts configuration objects instead of raw data to allow flexibility
/// while maintaining a consistent visual structure.
///
/// يوفر تحكم كامل على كل جزء من الصفحة مع خيارات للتفعيل/التعطيل
class DashboardOverviewBuilder extends StatelessWidget {
  final DashboardOverviewConfig config;

  /// خيارات التحكم بعرض الأجزاء
  final bool showGreeting;
  final bool showStatCards;
  final bool showAppointments;
  final bool showFeatures;
  final bool useDefaultLayout;

  const DashboardOverviewBuilder({
    super.key,
    required this.config,
    this.showGreeting = true,
    this.showStatCards = true,
    this.showAppointments = true,
    this.showFeatures = true,
    this.useDefaultLayout = true,
  });

  @override
  Widget build(BuildContext context) {
    // إذا كان المستخدم لا يريد استخدام البيلدر، نعيد SafeArea فقط
    if (!useDefaultLayout) {
      return _buildCustomLayout(context);
    }

    // البناء الافتراضي الآمن
    return _buildDefaultLayout(context);
  }

  /// البناء الافتراضي - آمن وموثوق
  Widget _buildDefaultLayout(BuildContext context) {
    try {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildContentWidgets(context),
            ),
          ),
        ),
      );
    } catch (e) {
      return _buildErrorFallback(context, e);
    }
  }

  /// بناء مخصص - للتحكم الكامل
  Widget _buildCustomLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1300),
            child: _buildContentWithErrorHandling(context),
          ),
        ),
      ),
    );
  }

  /// بناء آمن للمحتوى مع معالجة الأخطاء
  Widget _buildContentWithErrorHandling(BuildContext context) {
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildContentWidgets(context),
      );
    } catch (e) {
      debugPrint('Error building dashboard content: $e');
      return _buildErrorFallback(context, e);
    }
  }

  /// بناء المحتوى بناءً على الخيارات
  List<Widget> _buildContentWidgets(BuildContext context) {
    final widgets = <Widget>[];

    // قسم الترحيب
    if (showGreeting && config.greeting != null) {
      widgets.addAll([_buildGreetingSection(config.greeting!), const SizedBox(height: 24)]);
    }

    // بطاقات الإحصائيات
    if (showStatCards && config.statCards != null && config.statCards!.isNotEmpty) {
      widgets.addAll([_buildStatCardsGrid(), const SizedBox(height: 32)]);
    }

    // محتوى المواعيد
    if (showAppointments && config.appointmentsContent != null) {
      widgets.addAll([config.appointmentsContent!, const SizedBox(height: 32)]);
    }

    // الأقسام الإضافية
    if (showFeatures && config.featureContent != null) {
      if (config.featureSectionTitle != null) {
        widgets.addAll([
          Text(
            config.featureSectionTitle!,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
        ]);
      }
      widgets.add(config.featureContent!);
    }

    return widgets.isEmpty ? [_buildEmptyState(context)] : widgets;
  }

  /// حالة الخطأ مع خيار العودة
  Widget _buildErrorFallback(BuildContext context, Object error) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text('خطأ في تحميل المحتوى', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              error.toString().replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                // إعادة بناء
                (context as Element).markNeedsBuild();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('محاولة مرة أخرى'),
            ),
          ],
        ),
      ),
    );
  }

  /// حالة فارغة
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dashboard_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'لا توجد بيانات للعرض',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingSection(GreetingConfig greeting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (greeting.title != null)
          Text(greeting.title!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        if (greeting.subtitle != null) ...[
          const SizedBox(height: 8),
          Text(greeting.subtitle!, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ],
      ],
    );
  }

  Widget _buildStatCardsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final crossAxisCount = isMobile ? 2 : 4;
        final theme = Theme.of(context);

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: config.statCards!
              .map(
                (stat) => StatCard(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  title: stat.title,
                  value: stat.value,
                  subtitle: stat.subtitle,
                  icon: stat.icon,
                  accentColor: stat.accentColor,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
