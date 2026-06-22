import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

sealed class TasksEvent extends Equatable {
  const TasksEvent();
}

class LoadTasks extends TasksEvent {
  final int projectId;

  const LoadTasks(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class UpdateTaskStatus extends TasksEvent {
  final int taskId;
  final TaskStatus newStatus;

  const UpdateTaskStatus({required this.taskId, required this.newStatus});

  @override
  List<Object?> get props => [taskId, newStatus];
}

class AddTask extends TasksEvent {
  final String title;
  final int projectId;
  final TaskPriority priority;

  const AddTask({
    required this.title,
    required this.projectId,
    required this.priority,
  });

  @override
  List<Object?> get props => [title, projectId, priority];
}
