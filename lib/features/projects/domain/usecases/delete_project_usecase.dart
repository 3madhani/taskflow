import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/projects_repository.dart';

@injectable
class DeleteProjectUseCase {
  final ProjectsRepository _repository;

  const DeleteProjectUseCase(this._repository);

  Future<Either<Failure, void>> call(String projectId) {
    return _repository.deleteProject(projectId);
  }
}
