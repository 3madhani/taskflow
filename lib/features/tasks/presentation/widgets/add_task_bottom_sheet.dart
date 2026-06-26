import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../bloc/tasks_state.dart';
import 'task_priority_selector.dart';
import 'task_status_selector.dart';

class AddTaskBottomSheet extends TaskFormBottomSheet {
  const AddTaskBottomSheet({
    required super.projectId,
    super.key,
  });
}

class TaskFormBottomSheet extends StatefulWidget {
  final String projectId;
  final TaskEntity? task;

  const TaskFormBottomSheet({
    required this.projectId,
    this.task,
    super.key,
  });

  @override
  State<TaskFormBottomSheet> createState() => _TaskFormBottomSheetState();
}

class _FormSectionLabel extends StatelessWidget {
  final String label;

  const _FormSectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.label(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
      ),
    );
  }
}

class _TaskFormBottomSheetState extends State<TaskFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  late TaskStatus _selectedStatus;
  late TaskPriority _selectedPriority;

  bool get _isEditing => widget.task != null;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksBloc, TasksState>(
      listener: (context, state) {
        if (state is TaskAdded || state is TaskUpdated) {
          Navigator.of(context).pop();
        } else if (state is TasksError) {
          AppSnackBar.show(
            context,
            message: state.message,
            type: AppSnackBarType.error,
          );
        }
      },
      child: AppBottomSheet(
        title: _isEditing ? 'Edit Task' : AppStrings.addTask,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: AppStrings.taskTitle,
                hintText: AppStrings.taskTitleHint,
                controller: _titleController,
                textInputAction: TextInputAction.next,
                validator: _validateTitle,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Description (Optional)',
                hintText: 'Enter task description',
                controller: _descController,
                textInputAction: TextInputAction.done,
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.lg),
              const _FormSectionLabel(label: AppStrings.priority),
              const SizedBox(height: AppSpacing.sm),
              TaskPrioritySelector(
                selectedPriority: _selectedPriority,
                onChanged: (priority) {
                  setState(() => _selectedPriority = priority);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              const _FormSectionLabel(label: 'Status'),
              const SizedBox(height: AppSpacing.sm),
              TaskStatusSelector(
                selectedStatus: _selectedStatus,
                onChanged: (status) {
                  setState(() => _selectedStatus = status);
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              BlocBuilder<TasksBloc, TasksState>(
                builder: (context, state) {
                  final isSaving = state is TaskUpdating &&
                      widget.task != null &&
                      state.updatingTaskId == widget.task!.id;
                  return AppButton(
                    label: _isEditing ? 'Save Task' : AppStrings.addTask,
                    isLoading: isSaving,
                    onPressed: isSaving ? null : _onSubmit,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController.text = task?.title ?? '';
    _descController.text = task?.description ?? '';
    _selectedStatus = task?.status ?? TaskStatus.pending;
    _selectedPriority = task?.priority ?? TaskPriority.medium;
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final description = _descController.text.trim().isEmpty
        ? null
        : _descController.text.trim();
    final bloc = context.read<TasksBloc>();
    final task = widget.task;

    if (task != null) {
      bloc.add(
        UpdateTask(
          taskId: task.id,
          title: _titleController.text.trim(),
          description: description,
          status: _selectedStatus,
          priority: _selectedPriority,
        ),
      );
      return;
    }

    bloc.add(
      AddTask(
        title: _titleController.text.trim(),
        description: description,
        projectId: widget.projectId,
        status: _selectedStatus,
        priority: _selectedPriority,
      ),
    );
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }
}
