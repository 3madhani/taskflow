import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

export '../../../../core/enums/app_enums.dart' show TaskStatus, TaskPriority;

const _unset = Object();

class TaskEntity extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime createdAt;

  const TaskEntity({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
  });

  TaskEntity copyWith({
    String? id,
    String? projectId,
    String? title,
    Object? description = _unset,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? createdAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        title,
        description,
        status,
        priority,
        createdAt,
      ];
}
