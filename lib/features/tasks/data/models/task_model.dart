import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class TaskModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int projectId;

  @HiveField(3)
  final String status; // 'pending' | 'in_progress' | 'done'

  @HiveField(4)
  final String priority; // 'low' | 'medium' | 'high'

  TaskModel({
    required this.id,
    required this.title,
    required this.projectId,
    required this.status,
    required this.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final albumId = json['albumId'] as int? ?? 0;
    final title = json['title'] as String? ?? '';

    final statusStr = id % 3 == 0 ? 'pending' : (id % 3 == 1 ? 'in_progress' : 'done');
    final priorityStr = id % 3 == 0 ? 'low' : (id % 3 == 1 ? 'medium' : 'high');

    return TaskModel(
      id: id,
      title: title,
      projectId: albumId,
      status: statusStr,
      priority: priorityStr,
    );
  }

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

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

    TaskPriority entityPriority;
    switch (priority) {
      case 'medium':
        entityPriority = TaskPriority.medium;
        break;
      case 'high':
        entityPriority = TaskPriority.high;
        break;
      default:
        entityPriority = TaskPriority.low;
    }

    return TaskEntity(
      id: id,
      title: title,
      projectId: projectId,
      status: entityStatus,
      priority: entityPriority,
    );
  }

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

    String priorityStr;
    switch (entity.priority) {
      case TaskPriority.medium:
        priorityStr = 'medium';
        break;
      case TaskPriority.high:
        priorityStr = 'high';
        break;
      default:
        priorityStr = 'low';
    }

    return TaskModel(
      id: entity.id,
      title: entity.title,
      projectId: entity.projectId,
      status: statusStr,
      priority: priorityStr,
    );
  }
}
