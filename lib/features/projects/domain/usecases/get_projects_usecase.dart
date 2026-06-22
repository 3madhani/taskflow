import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

@injectable
class GetProjectsUseCase {
  final ProjectsRepository _repository;

  const GetProjectsUseCase(this._repository);

  Future<Either<Failure, List<ProjectEntity>>> call() {
    return _repository.getProjects();
  }
}
