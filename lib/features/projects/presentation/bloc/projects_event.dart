import 'package:equatable/equatable.dart';

import '../../domain/entities/project_entity.dart';

sealed class ProjectsEvent extends Equatable {
  const ProjectsEvent();
}

class LoadProjects extends ProjectsEvent {
  const LoadProjects();

  @override
  List<Object?> get props => [];
}

class RefreshProjects extends ProjectsEvent {
  const RefreshProjects();

  @override
  List<Object?> get props => [];
}

class CreateProject extends ProjectsEvent {
  final String name;
  final String? description;
  final String? imageUrl;
  final String status;
  final String priority;

  const CreateProject({
    required this.name,
    this.description,
    this.imageUrl,
    required this.status,
    required this.priority,
  });

  @override
  List<Object?> get props => [name, description, imageUrl, status, priority];
}

class DeleteProject extends ProjectsEvent {
  final String projectId;

  const DeleteProject(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class UpdateProjectMeta extends ProjectsEvent {
  final String projectId;
  final ProjectStatus status;
  final ProjectPriority priority;

  const UpdateProjectMeta({
    required this.projectId,
    required this.status,
    required this.priority,
  });

  @override
  List<Object?> get props => [projectId, status, priority];
}
