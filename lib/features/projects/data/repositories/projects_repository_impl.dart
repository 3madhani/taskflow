import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_local_datasource.dart';
import '../datasources/projects_remote_datasource.dart';

@Injectable(as: ProjectsRepository)
class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsRemoteDatasource _remoteDatasource;
  final ProjectsLocalDatasource _localDatasource;

  const ProjectsRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    try {
      final remoteProjects = await _remoteDatasource.getProjects();
      // Cache for offline use (without embedded tasks list which changes often).
      await _localDatasource.cacheProjects(
        remoteProjects.map((p) => p.withoutTasks()).toList(),
      );
      return Right(remoteProjects.map((m) => m.toEntity()).toList());
    } on AuthException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on PostgrestException catch (e) {
      // Network failure — try Hive cache fallback.
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
            'No internet connection and no cached data available.'));
      }
      return Right(cached.map((m) => m.toEntity()).toList());
    } catch (_) {
      return Left(ServerFailure(errorMessage));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> createProject({
    required String name,
    String? description,
    required String status,
    required String priority,
  }) async {
    try {
      final model = await _remoteDatasource.createProject(
        name: name,
        description: description,
        status: status,
        priority: priority,
      );
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on PostgrestException catch (e) {
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
}
