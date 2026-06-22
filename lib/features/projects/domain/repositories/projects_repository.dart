import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/project_entity.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();
}
