import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? background;
  final EdgeInsetsGeometry? padding;

  const AppCard({super.key, required this.child, this.onTap, this.background, this.padding});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final content = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background ?? c.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
      ),
      child: child,
    );
    if (onTap == null) return content;
    return InkWell(borderRadius: BorderRadius.circular(AppRadius.md), onTap: onTap, child: content);
  }
}

enum AppButtonVariant { primary, secondary, danger, ghost }

class AppButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool loading;
  final VoidCallback? onPressed;
  final MainAxisAlignment alignment;

  const AppButton({
    super.key,
    required this.title,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    required this.onPressed,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final bg = switch (variant) {
      AppButtonVariant.primary => c.primary,
      AppButtonVariant.secondary => c.primarySoft,
      AppButtonVariant.danger => c.dangerSoft,
      AppButtonVariant.ghost => Colors.transparent,
    };
    final fg = switch (variant) {
      AppButtonVariant.primary => c.onPrimary,
      AppButtonVariant.secondary => c.primary,
      AppButtonVariant.danger => c.danger,
      AppButtonVariant.ghost => c.primary,
    };
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
      child: loading
          ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: fg))
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: alignment,
              children: [
                if (icon != null) ...[Icon(icon, size: 18, color: fg), const SizedBox(width: 6)],
                Flexible(child: Text(title, style: TextStyle(color: fg, fontWeight: FontWeight.w600))),
              ],
            ),
    );
  }
}

class AppChip extends StatelessWidget {
  final String text;
  final String tone; // neutral | success | warning | danger | primary
  const AppChip({super.key, required this.text, this.tone = 'neutral'});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final bg = switch (tone) {
      'success' => c.successSoft,
      'warning' => c.warningSoft,
      'danger' => c.dangerSoft,
      'primary' => c.primarySoft,
      _ => c.border,
    };
    final fg = switch (tone) {
      'success' => c.success,
      'warning' => c.warning,
      'danger' => c.danger,
      'primary' => c.primary,
      _ => c.textSecondary,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? hint;
  const EmptyState({super.key, required this.icon, required this.title, this.hint});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 44, color: c.textSecondary),
          const SizedBox(height: AppSpacing.sm),
          Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
          if (hint != null) ...[
            const SizedBox(height: 4),
            Text(hint!, textAlign: TextAlign.center, style: TextStyle(color: c.textSecondary, fontSize: 13)),
          ],
        ],
      ),
    );
  }
}

class CheckRow extends StatelessWidget {
  final bool checked;
  final String label;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;

  const CheckRow({super.key, required this.checked, required this.label, required this.onToggle, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.border))),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onToggle,
              child: Row(
                children: [
                  Icon(
                    checked ? Icons.check_box : Icons.check_box_outline_blank,
                    color: checked ? c.success : c.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: checked ? c.textSecondary : c.text,
                        decoration: checked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (onDelete != null)
            IconButton(icon: Icon(Icons.delete_outline, size: 18, color: c.danger), onPressed: onDelete),
        ],
      ),
    );
  }
}

/// Basit ilerleme çubuğu (0.0 - 1.0).
class AppProgressBar extends StatelessWidget {
  final double value;
  const AppProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      height: 6,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(3)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0, 1),
        child: Container(decoration: BoxDecoration(color: c.success, borderRadius: BorderRadius.circular(3))),
      ),
    );
  }
}
