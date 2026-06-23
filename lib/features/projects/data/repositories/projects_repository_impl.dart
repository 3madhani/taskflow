import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
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
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    try {
      final remoteProjects = await _remoteDatasource.getProjects();
      await _localDatasource.cacheProjects(remoteProjects);
      return Right(remoteProjects.map((m) => m.toEntity()).toList());
    } catch (_) {
      try {
        final cachedProjects = _localDatasource.getCachedProjects();
        if (cachedProjects.isEmpty) {
          final defaultProjects = [
            ProjectModel(
              id: 1,
              title: 'Mobile App Development',
              description: 'Build a premium flutter task management app.',
              status: 'active',
            ),
            ProjectModel(
              id: 2,
              title: 'Website Redesign',
              description: 'Revamp company website styling and landing page.',
              status: 'on_hold',
            ),
            ProjectModel(
              id: 3,
              title: 'Marketing Campaign',
              description: 'Prepare launch assets and reach out to influencers.',
              status: 'completed',
            ),
          ];
          await _localDatasource.cacheProjects(defaultProjects);
          return Right(defaultProjects.map((m) => m.toEntity()).toList());
        }
        return Right(cachedProjects.map((m) => m.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}
