import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/helper/project_helper.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_local_datasource.dart';
import '../datasources/projects_remote_datasource.dart';
import '../models/project_model.dart';

@Injectable(as: ProjectsRepository)
class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsRemoteDatasource _remoteDatasource;
  final ProjectsLocalDatasource _localDatasource;

  const ProjectsRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<Either<Failure, ProjectEntity>> createProject({
    required String name,
    String? description,
    String? imageUrl,
    required String status,
    required String priority,
  }) async {
    try {
      final model = await _remoteDatasource.createProject(
        name: name,
        description: description,
        imageUrl: imageUrl,
        status: status,
        priority: priority,
      );
      await _localDatasource.saveProject(model.withoutTasks());
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } on StorageException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProject(String projectId) async {
    try {
      await _remoteDatasource.deleteProject(projectId);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> updateProjectMeta({
    required String projectId,
    required ProjectStatus status,
    required ProjectPriority priority,
  }) async {
    try {
      final model = await _remoteDatasource.updateProjectMeta(
        projectId: projectId,
        status: ProjectHelper.statusValue(status),
        priority: ProjectHelper.priorityValue(priority),
      );
      await _localDatasource.saveProject(model.withoutTasks());
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on PostgrestException catch (e) {
      return _tryLocalMetaUpdate(
        projectId: projectId,
        status: status,
        priority: priority,
        errorMessage: e.message,
      );
    } catch (e) {
      return _tryLocalMetaUpdate(
        projectId: projectId,
        status: status,
        priority: priority,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    try {
      final remoteProjects = await _remoteDatasource.getProjects();
      await _localDatasource.cacheProjects(
        remoteProjects.map((p) => p.withoutTasks()).toList(),
      );
      return Right(remoteProjects.map((m) => m.toEntity()).toList());
    } on AuthException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on PostgrestException catch (e) {
      return _tryCache(e.message);
    } catch (e) {
      return _tryCache(e.toString());
    }
  }

  Future<Either<Failure, List<ProjectEntity>>> _tryCache(
      String errorMessage) async {
    try {
      final cached = _localDatasource.getCachedProjects();
      if (cached.isEmpty) {
        return Left(CacheFailure(
            'Connection failed: $errorMessage. No cached data available.'));
      }
      return Right(cached.map((m) => m.toEntity()).toList());
    } catch (_) {
      return Left(ServerFailure(errorMessage));
    }
  }

  Future<Either<Failure, ProjectEntity>> _tryLocalMetaUpdate({
    required String projectId,
    required ProjectStatus status,
    required ProjectPriority priority,
    required String errorMessage,
  }) async {
    try {
      final cached = _localDatasource.getCachedProjects();
      final project = cached.firstWhere((p) => p.id == projectId);
      final updated = ProjectModel(
        id: project.id,
        userId: project.userId,
        name: project.name,
        description: project.description,
        imageUrl: project.imageUrl,
        status: ProjectHelper.statusValue(status),
        priority: ProjectHelper.priorityValue(priority),
        createdAt: project.createdAt,
      );
      await _localDatasource.saveProject(updated);
      return Right(updated.toEntity());
    } catch (_) {
      return Left(ServerFailure(errorMessage));
    }
  }
}
