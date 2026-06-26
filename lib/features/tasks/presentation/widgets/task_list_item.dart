import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/destructive_swipe_background.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import 'task_card.dart';

class TaskListItem extends StatelessWidget {
  final TaskEntity task;
  final bool isUpdating;

  const TaskListItem({
    required this.task,
    required this.isUpdating,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: const DestructiveSwipeBackground(
        label: 'Delete task',
        borderRadius: 14,
      ),
      onDismissed: (_) {
        context.read<TasksBloc>().add(
              DeleteTask(taskId: task.id, projectId: task.projectId),
            );
        AppSnackBar.show(
          context,
          message: 'Task "${task.title}" deleted',
          type: AppSnackBarType.info,
        );
      },
      child: TaskCard(
        task: task,
        isUpdating: isUpdating,
      ),
    );
  }
}
