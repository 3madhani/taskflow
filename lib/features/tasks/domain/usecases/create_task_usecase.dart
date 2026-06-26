import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

@injectable
class CreateTaskUseCase {
  final TasksRepository _repository;

  const CreateTaskUseCase(this._repository);

  Future<Either<Failure, TaskEntity>> call({
    required String title,
    required String projectId,
    required TaskPriority priority,
    String? description,
  }) {
    return _repository.createTask(
      title: title,
      projectId: projectId,
      priority: priority,
      description: description,
    );
  }
}
