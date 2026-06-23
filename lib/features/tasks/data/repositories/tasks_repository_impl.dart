import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/hive_constants.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_local_datasource.dart';
import '../datasources/tasks_remote_datasource.dart';
import '../models/task_model.dart';

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
    } catch (_) {
      try {
        final cachedTasks = _localDatasource.getCachedTasks(projectId);
        if (cachedTasks.isEmpty) {
          final allMockTasks = [
            TaskModel(id: 1, title: 'Design the UI/UX mockups', projectId: 1, status: 'done', priority: 'high'),
            TaskModel(id: 2, title: 'Setup clean architecture skeleton', projectId: 1, status: 'in_progress', priority: 'high'),
            TaskModel(id: 3, title: 'Implement local database caching', projectId: 1, status: 'pending', priority: 'medium'),
            TaskModel(id: 4, title: 'Gather design requirements from client', projectId: 2, status: 'done', priority: 'medium'),
            TaskModel(id: 5, title: 'Draft wireframes for review', projectId: 2, status: 'pending', priority: 'low'),
            TaskModel(id: 6, title: 'Develop marketing assets package', projectId: 3, status: 'pending', priority: 'medium'),
            TaskModel(id: 7, title: 'Reach out to target influencers', projectId: 3, status: 'pending', priority: 'low'),
          ];
          final filtered = allMockTasks.where((t) => t.projectId == projectId).toList();
          await _localDatasource.cacheTasks(projectId, filtered);
          return Right(filtered.map((m) => m.toEntity()).toList());
        }
        return Right(cachedTasks.map((m) => m.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
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
      await _localDatasource.saveTask(updatedModel);
      return Right(updatedModel.toEntity());
    } catch (_) {
      try {
        final allTasks = _localDatasource.hiveStorage.readAll<TaskModel>(HiveBoxes.tasks);
        final task = allTasks.firstWhere((t) => t.id == taskId);
        final updated = TaskModel(
          id: task.id,
          title: task.title,
          projectId: task.projectId,
          status: _statusToString(newStatus),
          priority: task.priority,
        );
        await _localDatasource.saveTask(updated);
        return Right(updated.toEntity());
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
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
      await _localDatasource.saveTask(newTask);
      return Right(newTask.toEntity());
    } catch (_) {
      try {
        final allTasks = _localDatasource.hiveStorage.readAll<TaskModel>(HiveBoxes.tasks);
        final nextId = allTasks.isEmpty ? 1 : allTasks.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
        final newTask = TaskModel(
          id: nextId,
          title: title,
          projectId: projectId,
          status: 'pending',
          priority: _priorityToString(priority),
        );
        await _localDatasource.saveTask(newTask);
        return Right(newTask.toEntity());
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
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
