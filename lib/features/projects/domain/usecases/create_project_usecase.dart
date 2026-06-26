import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

@injectable
class CreateProjectUseCase {
  final ProjectsRepository _repository;

  const CreateProjectUseCase(this._repository);

  Future<Either<Failure, ProjectEntity>> call({
    required String name,
    String? description,
    String? imageUrl,
    required String status,
    required String priority,
  }) {
    return _repository.createProject(
      name: name,
      description: description,
      imageUrl: imageUrl,
      status: status,
      priority: priority,
    );
  }
}
