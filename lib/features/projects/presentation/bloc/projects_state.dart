import 'package:equatable/equatable.dart';
import '../../domain/entities/project_entity.dart';

sealed class ProjectsState extends Equatable {
  const ProjectsState();
}

class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();

  @override
  List<Object?> get props => [];
}

class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();

  @override
  List<Object?> get props => [];
}

class ProjectsLoaded extends ProjectsState {
  final List<ProjectEntity> projects;

  const ProjectsLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError(this.message);

  @override
  List<Object?> get props => [message];
}
