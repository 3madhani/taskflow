import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

export '../../../../core/enums/app_enums.dart'
    show ProjectStatus, ProjectPriority;

class ProjectEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final ProjectStatus status;
  final ProjectPriority priority;
  final DateTime createdAt;
  final List<TaskSummary> tasks;

  const ProjectEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.tasks = const [],
  });

  int get doneTasks => tasks.where((t) => t.isDone).length;

  int get totalTasks => tasks.length;

  double get progress => totalTasks == 0 ? 0.0 : doneTasks / totalTasks;

  @override
  List<Object?> get props =>
      [id, userId, name, description, status, priority, createdAt, tasks];
}

class TaskSummary extends Equatable {
  final String id;
  final String status;

  const TaskSummary({required this.id, required this.status});

  bool get isDone => status == 'done';

  @override
  List<Object?> get props => [id, status];
}
