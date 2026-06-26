// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:taskflow/core/storage/hive_storage.dart' as _i734;
import 'package:taskflow/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i768;
import 'package:taskflow/features/auth/data/repositories/auth_repository_impl.dart'
    as _i860;
import 'package:taskflow/features/auth/domain/repositories/auth_repository.dart'
    as _i697;
import 'package:taskflow/features/auth/domain/usecases/login_usecase.dart'
    as _i787;
import 'package:taskflow/features/auth/domain/usecases/logout_usecase.dart'
    as _i469;
import 'package:taskflow/features/auth/domain/usecases/register_usecase.dart'
    as _i437;
import 'package:taskflow/features/auth/presentation/bloc/auth_bloc.dart'
    as _i662;
import 'package:taskflow/features/profile/presentation/bloc/theme_bloc.dart'
    as _i633;
import 'package:taskflow/features/projects/data/datasources/projects_local_datasource.dart'
    as _i849;
import 'package:taskflow/features/projects/data/datasources/projects_remote_datasource.dart'
    as _i981;
import 'package:taskflow/features/projects/data/repositories/projects_repository_impl.dart'
    as _i750;
import 'package:taskflow/features/projects/domain/repositories/projects_repository.dart'
    as _i198;
import 'package:taskflow/features/projects/domain/usecases/create_project_usecase.dart'
    as _i172;
import 'package:taskflow/features/projects/domain/usecases/delete_project_usecase.dart'
    as _i94;
import 'package:taskflow/features/projects/domain/usecases/get_projects_usecase.dart'
    as _i255;
import 'package:taskflow/features/projects/domain/usecases/update_project_meta_usecase.dart'
    as _i365;
import 'package:taskflow/features/projects/presentation/bloc/projects_bloc.dart'
    as _i794;
import 'package:taskflow/features/tasks/data/datasources/tasks_local_datasource.dart'
    as _i275;
import 'package:taskflow/features/tasks/data/datasources/tasks_remote_datasource.dart'
    as _i925;
import 'package:taskflow/features/tasks/data/repositories/tasks_repository_impl.dart'
    as _i536;
import 'package:taskflow/features/tasks/domain/repositories/tasks_repository.dart'
    as _i541;
import 'package:taskflow/features/tasks/domain/usecases/create_task_usecase.dart'
    as _i91;
import 'package:taskflow/features/tasks/domain/usecases/delete_task_usecase.dart'
    as _i120;
import 'package:taskflow/features/tasks/domain/usecases/get_tasks_usecase.dart'
    as _i437;
import 'package:taskflow/features/tasks/domain/usecases/update_task_status_usecase.dart'
    as _i435;
import 'package:taskflow/features/tasks/domain/usecases/update_task_usecase.dart'
    as _i519;
import 'package:taskflow/features/tasks/presentation/bloc/tasks_bloc.dart'
    as _i61;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i768.AuthRemoteDatasource>(() => _i768.AuthRemoteDatasource());
    gh.factory<_i981.ProjectsRemoteDatasource>(
        () => _i981.ProjectsRemoteDatasource());
    gh.factory<_i925.TasksRemoteDatasource>(
        () => _i925.TasksRemoteDatasource());
    gh.singleton<_i734.HiveStorage>(() => const _i734.HiveStorage());
    gh.factory<_i849.ProjectsLocalDatasource>(
        () => _i849.ProjectsLocalDatasource(gh<_i734.HiveStorage>()));
    gh.factory<_i275.TasksLocalDatasource>(
        () => _i275.TasksLocalDatasource(gh<_i734.HiveStorage>()));
    gh.singleton<_i633.ThemeBloc>(
        () => _i633.ThemeBloc(gh<_i734.HiveStorage>()));
    gh.factory<_i697.AuthRepository>(
        () => _i860.AuthRepositoryImpl(gh<_i768.AuthRemoteDatasource>()));
    gh.factory<_i541.TasksRepository>(() => _i536.TasksRepositoryImpl(
          gh<_i925.TasksRemoteDatasource>(),
          gh<_i275.TasksLocalDatasource>(),
        ));
    gh.factory<_i91.CreateTaskUseCase>(
        () => _i91.CreateTaskUseCase(gh<_i541.TasksRepository>()));
    gh.factory<_i120.DeleteTaskUseCase>(
        () => _i120.DeleteTaskUseCase(gh<_i541.TasksRepository>()));
    gh.factory<_i437.GetTasksUseCase>(
        () => _i437.GetTasksUseCase(gh<_i541.TasksRepository>()));
    gh.factory<_i435.UpdateTaskStatusUseCase>(
        () => _i435.UpdateTaskStatusUseCase(gh<_i541.TasksRepository>()));
    gh.factory<_i519.UpdateTaskUseCase>(
        () => _i519.UpdateTaskUseCase(gh<_i541.TasksRepository>()));
    gh.factory<_i198.ProjectsRepository>(() => _i750.ProjectsRepositoryImpl(
          gh<_i981.ProjectsRemoteDatasource>(),
          gh<_i849.ProjectsLocalDatasource>(),
        ));
    gh.factory<_i787.LoginUseCase>(
        () => _i787.LoginUseCase(gh<_i697.AuthRepository>()));
    gh.factory<_i469.LogoutUseCase>(
        () => _i469.LogoutUseCase(gh<_i697.AuthRepository>()));
    gh.factory<_i437.RegisterUseCase>(
        () => _i437.RegisterUseCase(gh<_i697.AuthRepository>()));
    gh.factory<_i172.CreateProjectUseCase>(
        () => _i172.CreateProjectUseCase(gh<_i198.ProjectsRepository>()));
    gh.factory<_i94.DeleteProjectUseCase>(
        () => _i94.DeleteProjectUseCase(gh<_i198.ProjectsRepository>()));
    gh.factory<_i255.GetProjectsUseCase>(
        () => _i255.GetProjectsUseCase(gh<_i198.ProjectsRepository>()));
    gh.factory<_i365.UpdateProjectMetaUseCase>(
        () => _i365.UpdateProjectMetaUseCase(gh<_i198.ProjectsRepository>()));
    gh.factory<_i794.ProjectsBloc>(() => _i794.ProjectsBloc(
          gh<_i255.GetProjectsUseCase>(),
          gh<_i172.CreateProjectUseCase>(),
          gh<_i94.DeleteProjectUseCase>(),
          gh<_i365.UpdateProjectMetaUseCase>(),
        ));
    gh.factory<_i61.TasksBloc>(() => _i61.TasksBloc(
          gh<_i437.GetTasksUseCase>(),
          gh<_i435.UpdateTaskStatusUseCase>(),
          gh<_i519.UpdateTaskUseCase>(),
          gh<_i91.CreateTaskUseCase>(),
          gh<_i120.DeleteTaskUseCase>(),
        ));
    gh.factory<_i662.AuthBloc>(() => _i662.AuthBloc(
          gh<_i787.LoginUseCase>(),
          gh<_i437.RegisterUseCase>(),
          gh<_i469.LogoutUseCase>(),
          gh<_i697.AuthRepository>(),
        ));
    return this;
  }
}
