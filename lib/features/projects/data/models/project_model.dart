import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/project_entity.dart';

part 'project_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class ProjectModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String status; // 'active' | 'on_hold' | 'completed'

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final title = json['title'] as String? ?? '';
    final userId = json['userId'] as int? ?? 0;
    final statusStr = id % 3 == 0 ? 'active' : (id % 3 == 1 ? 'on_hold' : 'completed');

    return ProjectModel(
      id: id,
      title: title,
      description: 'Managed by user #$userId',
      status: statusStr,
    );
  }

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);

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
    return ProjectEntity(
      id: id,
      title: title,
      description: description,
      status: entityStatus,
    );
  }
}
