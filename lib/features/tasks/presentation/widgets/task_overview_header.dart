import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/task_entity.dart';
import 'task_visuals.dart';

class TaskOverviewHeader extends StatelessWidget {
  final List<TaskEntity> tasks;
  final double horizontalPadding;

  const TaskOverviewHeader({
    required this.tasks,
    required this.horizontalPadding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final done = _count(TaskStatus.done);
    final total = tasks.length;
    final progress = total == 0 ? 0.0 : done / total;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        AppSpacing.lg,
        horizontalPadding,
        AppSpacing.sm,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.brightness == Brightness.dark
                ? AppColors.borderDark
                : AppColors.borderLight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tasks',
                      style: AppTextStyles.headingS(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    '$done/$total done',
                    style: AppTextStyles.label(
                      color: theme.colorScheme.onSurface.withAlpha(165),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: theme.brightness == Brightness.dark
                      ? AppColors.borderDark
                      : AppColors.borderLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress == 1 && total > 0
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _StatusCountChip(
                    label: 'Pending',
                    value: _count(TaskStatus.pending),
                    status: TaskStatus.pending,
                  ),
                  _StatusCountChip(
                    label: 'In progress',
                    value: _count(TaskStatus.inProgress),
                    status: TaskStatus.inProgress,
                  ),
                  _StatusCountChip(
                    label: 'Done',
                    value: done,
                    status: TaskStatus.done,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _count(TaskStatus status) {
    return tasks.where((task) => task.status == status).length;
  }
}

class _StatusCountChip extends StatelessWidget {
  final String label;
  final int value;
  final TaskStatus status;

  const _StatusCountChip({
    required this.label,
    required this.value,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = TaskVisuals.statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(TaskVisuals.statusIcon(status), size: 13, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$label $value',
            style: AppTextStyles.caption(color: color),
          ),
        ],
      ),
    );
  }
}
