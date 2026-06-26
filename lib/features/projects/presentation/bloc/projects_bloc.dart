import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_projects_usecase.dart';
import '../../domain/usecases/create_project_usecase.dart';
import '../../domain/usecases/delete_project_usecase.dart';
import 'projects_event.dart';
import 'projects_state.dart';

@injectable
class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final GetProjectsUseCase _getProjectsUseCase;
  final CreateProjectUseCase _createProjectUseCase;
  final DeleteProjectUseCase _deleteProjectUseCase;

  ProjectsBloc(
    this._getProjectsUseCase,
    this._createProjectUseCase,
    this._deleteProjectUseCase,
  ) : super(const ProjectsInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<RefreshProjects>(_onRefreshProjects);
    on<CreateProject>(_onCreateProject);
    on<DeleteProject>(_onDeleteProject);
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
}

