import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/task_entity.dart';
import 'task_status_selector.dart';
import 'task_visuals.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final bool isUpdating;
  final VoidCallback? onEdit;
  final ValueChanged<TaskStatus>? onStatusChanged;

  const TaskCard({
    required this.task,
    this.isUpdating = false,
    this.onEdit,
    this.onStatusChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = TaskVisuals.statusColor(task.status);
    final isDone = task.status == TaskStatus.done;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isUpdating
              ? statusColor.withAlpha(150)
              : theme.brightness == Brightness.dark
                  ? AppColors.borderDark
                  : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(
              theme.brightness == Brightness.dark ? 45 : 14,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TaskStatusAvatar(
                      status: task.status,
                      isUpdating: isUpdating,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _TaskCardText(
                        task: task,
                        isDone: isDone,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton.filledTonal(
                      tooltip: 'Edit task',
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _PriorityPill(priority: task.priority),
                    const Spacer(),
                    Text(
                      TaskVisuals.statusLabel(task.status),
                      style: AppTextStyles.caption(color: statusColor),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TaskStatusSelector(
                  selectedStatus: task.status,
                  compact: true,
                  onChanged: isUpdating ? null : onStatusChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCardText extends StatelessWidget {
  final TaskEntity task;
  final bool isDone;

  const _TaskCardText({
    required this.task,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = task.description?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          style: AppTextStyles.headingS(
            color: isDone
                ? theme.colorScheme.onSurface.withAlpha(120)
                : theme.colorScheme.onSurface,
          ).copyWith(
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (description != null && description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: AppTextStyles.bodyM(
              color: theme.colorScheme.onSurface.withAlpha(150),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _TaskStatusAvatar extends StatelessWidget {
  final TaskStatus status;
  final bool isUpdating;

  const _TaskStatusAvatar({
    required this.status,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    final color = TaskVisuals.statusColor(status);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withAlpha(210),
            AppColors.secondary.withAlpha(180),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isUpdating
          ? const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Icon(
              TaskVisuals.statusIcon(status),
              color: Colors.white,
              size: 22,
            ),
    );
  }
}

class _PriorityPill extends StatelessWidget {
  final TaskPriority priority;

  const _PriorityPill({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = TaskVisuals.priorityColor(priority);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(24),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(TaskVisuals.priorityIcon(priority), size: 13, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${TaskVisuals.priorityLabel(priority)} priority',
            style: AppTextStyles.caption(color: color),
          ),
        ],
      ),
    );
  }
}
