import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/responsive/screen_utils.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../projects/domain/entities/project_entity.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../bloc/tasks_state.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/task_card.dart';
import '../../domain/entities/task_entity.dart';

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
    final project = widget.project;
    return Scaffold(
      appBar: AppBar(
        leading: project != null
            ? Hero(
                tag: 'project_icon_${project.id}',
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.folder_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              )
            : null,
        title: Text(
          project?.name ?? 'Project #${widget.projectId.substring(0, 8)}',
          style: AppTextStyles.headingS(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          return switch (state) {
            TasksInitial() => const SizedBox.shrink(),
            TasksLoading() => const Center(child: CircularProgressIndicator()),
            TasksError(:final message) => AppErrorWidget(
                message: message,
                onRetry: () => context.read<TasksBloc>().add(
                      LoadTasks(widget.projectId),
                    ),
              ),
            TasksLoaded(:final tasks) => _buildContent(context, tasks, null),
            TaskUpdating(:final tasks, :final updatingTaskId) =>
              _buildContent(context, tasks, updatingTaskId),
            TaskAdded(:final tasks) => _buildContent(context, tasks, null),
          };
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<TaskEntity> tasks,
    String? updatingTaskId,
  ) {
    if (tasks.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.task_alt_rounded,
        title: 'No Tasks Yet',
        subtitle: 'Add your first task using the + button.',
      );
    }

    return ResponsiveLayout(
      mobile: (ctx, _) => TaskListView(
        tasks: tasks,
        updatingTaskId: updatingTaskId,
        horizontalPadding: context.horizontalPadding,
      ),
      tablet: (ctx, _) => Row(
        children: [
          if (widget.project != null)
            Expanded(
              flex: 2,
              child: ProjectInfoPanel(project: widget.project!),
            ),
          if (widget.project != null) const VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child: TaskListView(
              tasks: tasks,
              updatingTaskId: updatingTaskId,
              horizontalPadding: context.horizontalPadding,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TasksBloc>(),
        child: AddTaskBottomSheet(projectId: widget.projectId),
      ),
    );
  }
}
