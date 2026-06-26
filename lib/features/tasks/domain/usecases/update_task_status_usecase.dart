import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

@injectable
class UpdateTaskStatusUseCase {
  final TasksRepository _repository;

  const UpdateTaskStatusUseCase(this._repository);

  Future<Either<Failure, TaskEntity>> call({
    required String taskId,
    required TaskStatus newStatus,
  }) {
    return _repository.updateTaskStatus(taskId: taskId, newStatus: newStatus);
  }
}
