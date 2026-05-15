import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppointmentsInlineLoading extends StatelessWidget {
  final String? message;

  const AppointmentsInlineLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(
              message ?? 'loading'.tr(),
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentsInlineError extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const AppointmentsInlineError({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final resolvedMessage = _resolveErrorMessage();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withAlpha(100),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.error.withAlpha(120)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: colorScheme.error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  resolvedMessage,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text('retry'.tr()),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _resolveErrorMessage() {
    final trimmed = message?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return 'error_something_went_wrong'.tr();
    }
    return trimmed;
  }
}

class AppointmentsInlineEmpty extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppointmentsInlineEmpty({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.event_busy_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(120)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 52, color: colorScheme.outline),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
          if (onAction != null &&
              actionLabel != null &&
              actionLabel!.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
