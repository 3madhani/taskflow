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
