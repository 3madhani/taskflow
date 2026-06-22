import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/app_exception.dart';
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
      // Network-first strategy
      final remoteProjects = await _remoteDatasource.getProjects();
      await _localDatasource.cacheProjects(remoteProjects);
      return Right(remoteProjects.map((m) => m.toEntity()).toList());
    } on NetworkException {
      // Fallback to cache
      try {
        final cachedProjects = _localDatasource.getCachedProjects();
        if (cachedProjects.isEmpty) {
          return const Left(
            CacheFailure('No cached data. Please connect to the internet.'),
          );
        }
        return Right(cachedProjects.map((m) => m.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
