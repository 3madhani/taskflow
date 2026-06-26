import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../bloc/tasks_state.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final String projectId;

  const AddTaskBottomSheet({required this.projectId, super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<TasksBloc>().add(
            AddTask(
              title: _titleController.text.trim(),
              description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
              projectId: widget.projectId,
              priority: _selectedPriority,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksBloc, TasksState>(
      listener: (context, state) {
        if (state is TaskAdded) {
          Navigator.of(context).pop();
        } else if (state is TasksError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          top: AppSpacing.xl,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(80),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(AppStrings.addTask, style: AppTextStyles.headingM()),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: AppStrings.taskTitle,
                hintText: AppStrings.taskTitleHint,
                controller: _titleController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.fieldRequired;
                  }
                  return null;
                },
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.priority,
                    style: AppTextStyles.label(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<TaskPriority>(
                    initialValue: _selectedPriority,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: TaskPriority.low,
                        child: Text('Low'),
                      ),
                      DropdownMenuItem(
                        value: TaskPriority.medium,
                        child: Text('Medium'),
                      ),
                      DropdownMenuItem(
                        value: TaskPriority.high,
                        child: Text('High'),
                      ),
                    ],
                    onChanged: (priority) {
                      if (priority != null) {
                        setState(() => _selectedPriority = priority);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              BlocBuilder<TasksBloc, TasksState>(
                builder: (context, state) {
                  final isLoading = state is TasksLoading;
                  return AppButton(
                    label: AppStrings.addTask,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : () => _onSubmit(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
