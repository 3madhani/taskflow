import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import 'task_card.dart';

class TaskListView extends StatelessWidget {
  final List<TaskEntity> tasks;
  final String? updatingTaskId;
  final double horizontalPadding;

  const TaskListView({
    required this.tasks,
    required this.updatingTaskId,
    required this.horizontalPadding,
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
        return Dismissible(
          key: Key(task.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete_rounded, color: Colors.white),
          ),
          onDismissed: (_) {
            context.read<TasksBloc>().add(
                  DeleteTask(taskId: task.id, projectId: task.projectId),
                );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task "${task.title}" deleted')),
            );
          },
          child: TaskCard(
            task: task,
            isUpdating: updatingTaskId == task.id,
          ),
        );
      },
    );
  }
}
