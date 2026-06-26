import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/task_entity.dart';

abstract class TasksRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasksByProject(String projectId);

  Future<Either<Failure, TaskEntity>> updateTaskStatus({
    required String taskId,
    required TaskStatus newStatus,
  });

  Future<Either<Failure, TaskEntity>> createTask({
    required String title,
    required String projectId,
    required TaskPriority priority,
    String? description,
  });

  Future<Either<Failure, void>> deleteTask(String taskId);
}
