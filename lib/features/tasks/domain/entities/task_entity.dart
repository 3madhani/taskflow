import 'package:equatable/equatable.dart';

enum TaskStatus { pending, inProgress, done }

enum TaskPriority { low, medium, high }

class TaskEntity extends Equatable {
  final int id;
  final String title;
  final int projectId;
  final TaskStatus status;
  final TaskPriority priority;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.projectId,
    required this.status,
    required this.priority,
  });

  TaskEntity copyWith({
    int? id,
    String? title,
    int? projectId,
    TaskStatus? status,
    TaskPriority? priority,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      projectId: projectId ?? this.projectId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [id, title, projectId, status, priority];
}
