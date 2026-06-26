import 'package:flutter/material.dart';

import '../../../../core/widgets/destructive_swipe_background.dart';
import '../../domain/entities/task_entity.dart';
import 'task_card.dart';

class TaskListItem extends StatelessWidget {
  final TaskEntity task;
  final bool isUpdating;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<TaskStatus> onStatusChanged;

  const TaskListItem({
    required this.task,
    required this.isUpdating,
    required this.onDelete,
    required this.onEdit,
    required this.onStatusChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: const DestructiveSwipeBackground(
        label: 'Delete task',
        borderRadius: 18,
      ),
      onDismissed: (_) => onDelete(),
      child: TaskCard(
        task: task,
        isUpdating: isUpdating,
        onEdit: onEdit,
        onStatusChanged: onStatusChanged,
      ),
    );
  }
}
