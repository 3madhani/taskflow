import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

@injectable
class UpdateTaskUseCase {
  final TasksRepository _repository;

  const UpdateTaskUseCase(this._repository);

  Future<Either<Failure, TaskEntity>> call({
    required String taskId,
    required String title,
    required TaskStatus status,
    required TaskPriority priority,
    String? description,
  }) {
    return _repository.updateTask(
      taskId: taskId,
      title: title,
      description: description,
      status: status,
      priority: priority,
    );
  }
}
