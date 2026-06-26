import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/get_projects_usecase.dart';
import '../../domain/usecases/create_project_usecase.dart';
import '../../domain/usecases/delete_project_usecase.dart';
import '../../domain/usecases/update_project_meta_usecase.dart';
import 'projects_event.dart';
import 'projects_state.dart';

@injectable
class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final GetProjectsUseCase _getProjectsUseCase;
  final CreateProjectUseCase _createProjectUseCase;
  final DeleteProjectUseCase _deleteProjectUseCase;
  final UpdateProjectMetaUseCase _updateProjectMetaUseCase;

  ProjectsBloc(
    this._getProjectsUseCase,
    this._createProjectUseCase,
    this._deleteProjectUseCase,
    this._updateProjectMetaUseCase,
  ) : super(const ProjectsInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<RefreshProjects>(_onRefreshProjects);
    on<CreateProject>(_onCreateProject);
    on<DeleteProject>(_onDeleteProject);
    on<UpdateProjectMeta>(_onUpdateProjectMeta);
  }

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(const ProjectsLoading());
    final result = await _getProjectsUseCase();
    result.fold(
      (failure) => emit(ProjectsError(failure.message)),
      (projects) => emit(ProjectsLoaded(projects)),
    );
  }

  Future<void> _onRefreshProjects(
    RefreshProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    final result = await _getProjectsUseCase();
    result.fold(
      (failure) => emit(ProjectsError(failure.message)),
      (projects) => emit(ProjectsLoaded(projects)),
    );
  }

  Future<void> _onCreateProject(
    CreateProject event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(const ProjectsLoading());
    final result = await _createProjectUseCase(
      name: event.name,
      description: event.description,
      imageUrl: event.imageUrl,
      status: event.status,
      priority: event.priority,
    );
    await result.fold(
      (failure) async => emit(ProjectsError(failure.message)),
      (_) async {
        final loadResult = await _getProjectsUseCase();
        loadResult.fold(
          (failure) => emit(ProjectsError(failure.message)),
          (projects) => emit(ProjectsLoaded(projects)),
        );
      },
    );
  }

  Future<void> _onDeleteProject(
    DeleteProject event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(const ProjectsLoading());
    final result = await _deleteProjectUseCase(event.projectId);
    await result.fold(
      (failure) async => emit(ProjectsError(failure.message)),
      (_) async {
        final loadResult = await _getProjectsUseCase();
        loadResult.fold(
          (failure) => emit(ProjectsError(failure.message)),
          (projects) => emit(ProjectsLoaded(projects)),
        );
      },
    );
  }

  Future<void> _onUpdateProjectMeta(
    UpdateProjectMeta event,
    Emitter<ProjectsState> emit,
  ) async {
    final currentProjects = _currentProjects();
    if (currentProjects == null) return;

    final optimisticProjects = currentProjects.map((project) {
      if (project.id != event.projectId) {
        return project;
      }

      return project.copyWith(
        status: event.status,
        priority: event.priority,
      );
    }).toList();
    emit(ProjectUpdating(
      projects: optimisticProjects,
      updatingProjectId: event.projectId,
    ));

    final result = await _updateProjectMetaUseCase(
      projectId: event.projectId,
      status: event.status,
      priority: event.priority,
    );

    result.fold(
      (failure) => emit(ProjectsError(failure.message)),
      (updatedProject) {
        final projects = optimisticProjects.map((project) {
          if (project.id != updatedProject.id) {
            return project;
          }
          return project.copyWith(
            status: updatedProject.status,
            priority: updatedProject.priority,
          );
        }).toList();
        emit(ProjectsLoaded(projects));
      },
    );
  }

  List<ProjectEntity>? _currentProjects() {
    final currentState = state;
    return switch (currentState) {
      ProjectsLoaded(:final projects) => projects,
      ProjectUpdating(:final projects) => projects,
      _ => null,
    };
  }
}
