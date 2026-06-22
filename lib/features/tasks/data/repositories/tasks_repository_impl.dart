import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_local_datasource.dart';
import '../datasources/tasks_remote_datasource.dart';

@Injectable(as: TasksRepository)
class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDatasource _remoteDatasource;
  final TasksLocalDatasource _localDatasource;

  const TasksRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksByProject(int projectId) async {
    try {
      final remoteTasks = await _remoteDatasource.getTasksByProject(projectId);
      await _localDatasource.cacheTasks(projectId, remoteTasks);
      return Right(remoteTasks.map((m) => m.toEntity()).toList());
    } on NetworkException {
      try {
        final cachedTasks = _localDatasource.getCachedTasks(projectId);
        if (cachedTasks.isEmpty) {
          return const Left(
            CacheFailure('No cached data. Please connect to the internet.'),
          );
        }
        return Right(cachedTasks.map((m) => m.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTaskStatus({
    required int taskId,
    required TaskStatus newStatus,
  }) async {
    try {
      final statusStr = _statusToString(newStatus);
      final updatedModel = await _remoteDatasource.updateTaskStatus(
        taskId: taskId,
        newStatus: statusStr,
      );
      return Right(updatedModel.toEntity());
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask({
    required String title,
    required int projectId,
    required TaskPriority priority,
  }) async {
    try {
      final priorityStr = _priorityToString(priority);
      final newTask = await _remoteDatasource.createTask(
        title: title,
        projectId: projectId,
        priority: priorityStr,
      );
      return Right(newTask.toEntity());
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  String _statusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return 'in_progress';
      case TaskStatus.done:
        return 'done';
      default:
        return 'pending';
    }
  }

  String _priorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.medium:
        return 'medium';
      case TaskPriority.high:
        return 'high';
      default:
        return 'low';
    }
  }
}
