import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/project_entity.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();

  Future<Either<Failure, ProjectEntity>> createProject({
    required String name,
    String? description,
    String? imageUrl,
    required String status,
    required String priority,
  });

  Future<Either<Failure, ProjectEntity>> updateProjectMeta({
    required String projectId,
    required ProjectStatus status,
    required ProjectPriority priority,
  });

  Future<Either<Failure, void>> deleteProject(String projectId);
}
