import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/task_entity.dart';

abstract class TasksRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasksByProject(int projectId);

  Future<Either<Failure, TaskEntity>> updateTaskStatus({
    required int taskId,
    required TaskStatus newStatus,
  });

  Future<Either<Failure, TaskEntity>> createTask({
    required String title,
    required int projectId,
    required TaskPriority priority,
  });
}
