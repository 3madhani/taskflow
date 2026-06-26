import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final bool isUpdating;

  const TaskCard({
    required this.task,
    this.isUpdating = false,
    super.key,
  });

  Color _statusColor() {
    return switch (task.status) {
      TaskStatus.pending => AppColors.statusPending,
      TaskStatus.inProgress => AppColors.statusInProgress,
      TaskStatus.done => AppColors.statusDone,
    };
  }

  String _statusLabel() {
    return switch (task.status) {
      TaskStatus.pending => 'Pending',
      TaskStatus.inProgress => 'In Progress',
      TaskStatus.done => 'Done',
    };
  }

  Color _priorityColor() {
    return switch (task.priority) {
      TaskPriority.low => AppColors.priorityLow,
      TaskPriority.medium => AppColors.priorityMedium,
      TaskPriority.high => AppColors.priorityHigh,
    };
  }

  String _priorityLabel() {
    return switch (task.priority) {
      TaskPriority.low => 'Low',
      TaskPriority.medium => 'Medium',
      TaskPriority.high => 'High',
    };
  }

  IconData _priorityIcon() {
    return switch (task.priority) {
      TaskPriority.low => Icons.arrow_downward_rounded,
      TaskPriority.medium => Icons.remove_rounded,
      TaskPriority.high => Icons.arrow_upward_rounded,
    };
  }

  void _onCheckboxTap(BuildContext context) {
    final nextStatus = TasksBloc.cycleStatus(task.status);
    context.read<TasksBloc>().add(
          UpdateTaskStatus(taskId: task.id, newStatus: nextStatus),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor();
    final priorityColor = _priorityColor();
    final isDone = task.status == TaskStatus.done;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.brightness == Brightness.dark
              ? AppColors.borderDark
              : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: isUpdating
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Checkbox(
                      value: isDone,
                      onChanged: (_) => _onCheckboxTap(context),
                      activeColor: AppColors.statusDone,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: AppTextStyles.bodyM(
                      color: isDone ? Colors.grey : null,
                    ).copyWith(
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task.description != null &&
                      task.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      task.description!,
                      style: AppTextStyles.caption(color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusBadge(label: _statusLabel(), color: statusColor),
                const SizedBox(height: 4),
                _PriorityBadge(
                  label: _priorityLabel(),
                  color: priorityColor,
                  icon: _priorityIcon(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.caption(color: color)),
        ],
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _PriorityBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(label, style: AppTextStyles.caption(color: color)),
      ],
    );
  }
}
