import 'package:hive/hive.dart';

import '../../domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 2)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String projectId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String status; // 'pending' | 'in_progress' | 'done'

  @HiveField(5)
  final String priority; // 'low' | 'medium' | 'high'

  @HiveField(6)
  final String createdAt;

  TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
  });

  factory TaskModel.fromEntity(TaskEntity entity) {
    String statusStr;
    switch (entity.status) {
      case TaskStatus.inProgress:
        statusStr = 'in_progress';
        break;
      case TaskStatus.done:
        statusStr = 'done';
        break;
      default:
        statusStr = 'pending';
    }

    return TaskModel(
      id: entity.id,
      projectId: entity.projectId,
      title: entity.title,
      description: entity.description,
      status: statusStr,
      priority: entity.priority.name,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'pending',
      priority: json['priority'] as String? ?? 'medium',
      createdAt: json['created_at'] as String,
    );
  }

  TaskEntity toEntity() {
    TaskStatus entityStatus;
    switch (status) {
      case 'in_progress':
        entityStatus = TaskStatus.inProgress;
        break;
      case 'done':
        entityStatus = TaskStatus.done;
        break;
      default:
        entityStatus = TaskStatus.pending;
    }

    return TaskEntity(
      id: id,
      projectId: projectId,
      title: title,
      description: description,
      status: entityStatus,
      priority: TaskPriority.values.byName(priority),
      createdAt: DateTime.parse(createdAt),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'project_id': projectId,
        'title': title,
        'description': description,
        'status': status,
        'priority': priority,
        'created_at': createdAt,
      };
}
