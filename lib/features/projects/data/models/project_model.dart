import 'package:hive/hive.dart';

import '../../domain/entities/project_entity.dart';

part 'project_model.g.dart';

@HiveType(typeId: 1)
class ProjectModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final String priority;

  @HiveField(6)
  final String createdAt;

  final List<Map<String, dynamic>> tasks;

  ProjectModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.tasks = const [],
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final rawTasks = json['tasks'] as List<dynamic>? ?? [];
    return ProjectModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'active',
      priority: json['priority'] as String? ?? 'medium',
      createdAt: json['created_at'] as String,
      tasks: rawTasks.cast<Map<String, dynamic>>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'description': description,
        'status': status,
        'priority': priority,
        'created_at': createdAt,
      };

  ProjectEntity toEntity() {
    ProjectStatus entityStatus;
    switch (status) {
      case 'on_hold':
        entityStatus = ProjectStatus.onHold;
        break;
      case 'completed':
        entityStatus = ProjectStatus.completed;
        break;
      default:
        entityStatus = ProjectStatus.active;
    }

    ProjectPriority entityPriority;
    switch (priority) {
      case 'low':
        entityPriority = ProjectPriority.low;
        break;
      case 'high':
        entityPriority = ProjectPriority.high;
        break;
      default:
        entityPriority = ProjectPriority.medium;
    }

    final taskSummaries = tasks.map((t) {
      return TaskSummary(
        id: t['id'] as String? ?? '',
        status: t['status'] as String? ?? 'pending',
      );
    }).toList();

    return ProjectEntity(
      id: id,
      userId: userId,
      name: name,
      description: description,
      status: entityStatus,
      priority: entityPriority,
      createdAt: DateTime.parse(createdAt),
      tasks: taskSummaries,
    );
  }

  ProjectModel withoutTasks() => ProjectModel(
        id: id,
        userId: userId,
        name: name,
        description: description,
        status: status,
        priority: priority,
        createdAt: createdAt,
      );
}
