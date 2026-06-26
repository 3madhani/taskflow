import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../projects/domain/entities/project_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../bloc/tasks_state.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/project_detail_app_bar.dart';
import '../widgets/project_detail_fab.dart';
import '../widgets/project_tasks_content.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;
  final ProjectEntity? project;

  const ProjectDetailScreen({
    required this.projectId,
    this.project,
    super.key,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TasksBloc>().add(LoadTasks(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProjectDetailAppBar(
        projectId: widget.projectId,
        project: widget.project,
      ),
      floatingActionButton: ProjectDetailFab(
        onPressed: () => _showTaskSheet(),
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          return switch (state) {
            TasksInitial() => const SizedBox.shrink(),
            TasksLoading() => const Center(child: CircularProgressIndicator()),
            TasksError(:final message) => AppErrorWidget(
                message: message,
                onRetry: _reloadTasks,
              ),
            TasksLoaded(:final tasks) => _buildContent(tasks, null),
            TaskUpdating(:final tasks, :final updatingTaskId) =>
              _buildContent(tasks, updatingTaskId),
            TaskAdded(:final tasks) => _buildContent(tasks, null),
            TaskUpdated(:final tasks) => _buildContent(tasks, null),
          };
        },
      ),
    );
  }

  Widget _buildContent(
    List<TaskEntity> tasks,
    String? updatingTaskId,
  ) {
    return ProjectTasksContent(
      project: widget.project,
      tasks: tasks,
      updatingTaskId: updatingTaskId,
      onDeleteTask: _deleteTask,
      onEditTask: (task) => _showTaskSheet(task),
      onStatusChanged: _updateTaskStatus,
    );
  }

  void _deleteTask(TaskEntity task) {
    context.read<TasksBloc>().add(
          DeleteTask(taskId: task.id, projectId: task.projectId),
        );
    AppSnackBar.show(
      context,
      message: 'Task "${task.title}" deleted',
      type: AppSnackBarType.info,
    );
  }

  void _reloadTasks() {
    context.read<TasksBloc>().add(LoadTasks(widget.projectId));
  }

  void _showTaskSheet([TaskEntity? task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TasksBloc>(),
        child: TaskFormBottomSheet(
          projectId: widget.projectId,
          task: task,
        ),
      ),
    );
  }

  void _updateTaskStatus(TaskEntity task, TaskStatus status) {
    if (task.status == status) {
      return;
    }

    context.read<TasksBloc>().add(
          UpdateTaskStatus(taskId: task.id, newStatus: status),
        );
  }
}
