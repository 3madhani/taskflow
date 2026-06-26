import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/responsive/screen_utils.dart';
import '../../../projects/domain/entities/project_entity.dart';
import '../../domain/entities/task_entity.dart';
import 'project_info_panel.dart';
import 'project_tasks_empty_view.dart';
import 'task_list_view.dart';
import 'task_overview_header.dart';

class ProjectTasksContent extends StatelessWidget {
  final ProjectEntity? project;
  final List<TaskEntity> tasks;
  final String? updatingTaskId;
  final ValueChanged<TaskEntity> onDeleteTask;
  final ValueChanged<TaskEntity> onEditTask;
  final void Function(TaskEntity task, TaskStatus status) onStatusChanged;

  const ProjectTasksContent({
    required this.project,
    required this.tasks,
    required this.updatingTaskId,
    required this.onDeleteTask,
    required this.onEditTask,
    required this.onStatusChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (ctx, _) => _TaskPane(
        tasks: tasks,
        updatingTaskId: updatingTaskId,
        horizontalPadding: context.horizontalPadding,
        onDeleteTask: onDeleteTask,
        onEditTask: onEditTask,
        onStatusChanged: onStatusChanged,
      ),
      tablet: (ctx, _) => Row(
        children: [
          if (project != null)
            Expanded(
              flex: 2,
              child: ProjectInfoPanel(project: project!),
            ),
          if (project != null) const VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child: _TaskPane(
              tasks: tasks,
              updatingTaskId: updatingTaskId,
              horizontalPadding: context.horizontalPadding,
              onDeleteTask: onDeleteTask,
              onEditTask: onEditTask,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskPane extends StatelessWidget {
  final List<TaskEntity> tasks;
  final String? updatingTaskId;
  final double horizontalPadding;
  final ValueChanged<TaskEntity> onDeleteTask;
  final ValueChanged<TaskEntity> onEditTask;
  final void Function(TaskEntity task, TaskStatus status) onStatusChanged;

  const _TaskPane({
    required this.tasks,
    required this.updatingTaskId,
    required this.horizontalPadding,
    required this.onDeleteTask,
    required this.onEditTask,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TaskOverviewHeader(
          tasks: tasks,
          horizontalPadding: horizontalPadding,
        ),
        Expanded(
          child: tasks.isEmpty
              ? const ProjectTasksEmptyView()
              : TaskListView(
                  tasks: tasks,
                  updatingTaskId: updatingTaskId,
                  horizontalPadding: horizontalPadding,
                  onDeleteTask: onDeleteTask,
                  onEditTask: onEditTask,
                  onStatusChanged: onStatusChanged,
                ),
        ),
      ],
    );
  }
}
