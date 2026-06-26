import 'package:equatable/equatable.dart';

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
  final String status;
  final String priority;

  const CreateProject({
    required this.name,
    this.description,
    required this.status,
    required this.priority,
  });

  @override
  List<Object?> get props => [name, description, status, priority];
}

class DeleteProject extends ProjectsEvent {
  final String projectId;

  const DeleteProject(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

