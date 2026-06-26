import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

@injectable
class UpdateProjectMetaUseCase {
  final ProjectsRepository _repository;

  const UpdateProjectMetaUseCase(this._repository);

  Future<Either<Failure, ProjectEntity>> call({
    required String projectId,
    required ProjectStatus status,
    required ProjectPriority priority,
  }) {
    return _repository.updateProjectMeta(
      projectId: projectId,
      status: status,
      priority: priority,
    );
  }
}
