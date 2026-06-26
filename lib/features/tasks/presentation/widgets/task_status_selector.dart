import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/task_entity.dart';
import 'task_visuals.dart';

class TaskStatusSelector extends StatelessWidget {
  final TaskStatus selectedStatus;
  final ValueChanged<TaskStatus>? onChanged;
  final bool compact;

  const TaskStatusSelector({
    required this.selectedStatus,
    this.onChanged,
    this.compact = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const statuses = TaskStatus.values;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTight = compact || constraints.maxWidth < 360;
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final status in statuses)
              _TaskStatusOption(
                status: status,
                isSelected: selectedStatus == status,
                isTight: isTight,
                onTap: onChanged == null ? null : () => onChanged!(status),
              ),
          ],
        );
      },
    );
  }
}

class _TaskStatusOption extends StatelessWidget {
  final TaskStatus status;
  final bool isSelected;
  final bool isTight;
  final VoidCallback? onTap;

  const _TaskStatusOption({
    required this.status,
    required this.isSelected,
    required this.isTight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = TaskVisuals.statusColor(status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isTight ? AppSpacing.sm : AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? color.withAlpha(32) : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? color.withAlpha(140)
                  : theme.brightness == Brightness.dark
                      ? AppColors.borderDark
                      : AppColors.borderLight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                TaskVisuals.statusIcon(status),
                size: isTight ? 15 : 17,
                color: color,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                TaskVisuals.statusLabel(status),
                style: AppTextStyles.caption(
                  color: isSelected
                      ? color
                      : theme.colorScheme.onSurface.withAlpha(170),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
