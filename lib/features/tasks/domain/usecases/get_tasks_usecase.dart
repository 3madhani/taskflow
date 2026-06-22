import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

@injectable
class GetTasksUseCase {
  final TasksRepository _repository;

  const GetTasksUseCase(this._repository);

  Future<Either<Failure, List<TaskEntity>>> call(int projectId) {
    return _repository.getTasksByProject(projectId);
  }
}
