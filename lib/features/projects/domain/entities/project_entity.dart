import 'package:equatable/equatable.dart';

enum ProjectStatus { active, onHold, completed }

class ProjectEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final ProjectStatus status;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  @override
  List<Object?> get props => [id, title, description, status];
}
