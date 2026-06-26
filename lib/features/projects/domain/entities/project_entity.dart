import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

export '../../../../core/enums/app_enums.dart'
    show ProjectStatus, ProjectPriority;

/// Domain entity for a project. IDs are UUIDs (String) from Supabase.
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

  /// Number of tasks that are marked as done.
  int get doneTasks => tasks.where((t) => t.isDone).length;

  /// Total number of tasks.
  int get totalTasks => tasks.length;

  /// Completion ratio 0.0–1.0.
  double get progress => totalTasks == 0 ? 0.0 : doneTasks / totalTasks;

  @override
  List<Object?> get props =>
      [id, userId, name, description, status, priority, createdAt, tasks];
}

/// Lightweight task summary embedded in a project — enough data to show
/// the progress bar in ProjectCard without loading full TaskEntity objects.
class TaskSummary extends Equatable {
  final String id;
  final String status; // 'pending' | 'in_progress' | 'done'

  const TaskSummary({required this.id, required this.status});

  bool get isDone => status == 'done';

  @override
  List<Object?> get props => [id, status];
}
