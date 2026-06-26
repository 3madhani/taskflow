import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/task_entity.dart';
import 'task_list_item.dart';

class TaskListView extends StatelessWidget {
  final List<TaskEntity> tasks;
  final String? updatingTaskId;
  final double horizontalPadding;
  final ValueChanged<TaskEntity> onDeleteTask;
  final ValueChanged<TaskEntity> onEditTask;
  final void Function(TaskEntity task, TaskStatus status) onStatusChanged;

  const TaskListView({
    required this.tasks,
    required this.updatingTaskId,
    required this.horizontalPadding,
    required this.onDeleteTask,
    required this.onEditTask,
    required this.onStatusChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: AppSpacing.lg,
      ),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, i) {
        final task = tasks[i];
        return TaskListItem(
          task: task,
          isUpdating: updatingTaskId == task.id,
          onDelete: () => onDeleteTask(task),
          onEdit: () => onEditTask(task),
          onStatusChanged: (status) => onStatusChanged(task, status),
        );
      },
    );
  }
}
