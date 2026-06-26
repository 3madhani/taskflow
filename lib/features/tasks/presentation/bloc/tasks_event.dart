import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

sealed class TasksEvent extends Equatable {
  const TasksEvent();
}

class LoadTasks extends TasksEvent {
  final String projectId;

  const LoadTasks(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class UpdateTaskStatus extends TasksEvent {
  final String taskId;
  final TaskStatus newStatus;

  const UpdateTaskStatus({required this.taskId, required this.newStatus});

  @override
  List<Object?> get props => [taskId, newStatus];
}

class AddTask extends TasksEvent {
  final String title;
  final String projectId;
  final TaskPriority priority;
  final String? description;

  const AddTask({
    required this.title,
    required this.projectId,
    required this.priority,
    this.description,
  });

  @override
  List<Object?> get props => [title, projectId, priority, description];
}

class DeleteTask extends TasksEvent {
  final String taskId;
  final String projectId;

  const DeleteTask({required this.taskId, required this.projectId});

  @override
  List<Object?> get props => [taskId, projectId];
}
