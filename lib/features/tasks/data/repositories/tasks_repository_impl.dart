import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  Future<Either<Failure, List<TaskEntity>>> getTasksByProject(String projectId) async {
    try {
      final remoteTasks = await _remoteDatasource.getTasks(projectId);
      await _localDatasource.cacheTasks(projectId, remoteTasks);
      return Right(remoteTasks.map((m) => m.toEntity()).toList());
    } on AuthException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on PostgrestException catch (e) {
      return _tryCache(projectId, e.message);
    } catch (e) {
      return _tryCache(projectId, e.toString());
    }
  }

  Future<Either<Failure, List<TaskEntity>>> _tryCache(
      String projectId, String errorMessage) async {
    try {
      final cached = _localDatasource.getCachedTasks(projectId);
      if (cached.isEmpty) {
        return Left(CacheFailure(
            'No internet connection and no cached data available.'));
      }
      return Right(cached.map((m) => m.toEntity()).toList());
    } catch (_) {
      return Left(ServerFailure(errorMessage));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTaskStatus({
    required String taskId,
    required TaskStatus newStatus,
  }) async {
    try {
      final statusStr = _statusToString(newStatus);
      final updatedModel = await _remoteDatasource.updateTaskStatus(
        taskId: taskId,
        status: statusStr,
      );
      await _localDatasource.saveTask(updatedModel);
      return Right(updatedModel.toEntity());
    } on AuthException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on PostgrestException catch (e) {
      return _tryLocalUpdate(taskId, newStatus, e.message);
    } catch (e) {
      return _tryLocalUpdate(taskId, newStatus, e.toString());
    }
  }

  Future<Either<Failure, TaskEntity>> _tryLocalUpdate(
      String taskId, TaskStatus newStatus, String errorMessage) async {
    try {
      final allTasks = _localDatasource.hiveStorage.readAll<TaskModel>(HiveBoxes.tasks);
      final task = allTasks.firstWhere((t) => t.id == taskId);
      final updated = TaskModel(
        id: task.id,
        title: task.title,
        projectId: task.projectId,
        description: task.description,
        status: _statusToString(newStatus),
        priority: task.priority,
        createdAt: task.createdAt,
      );
      await _localDatasource.saveTask(updated);
      return Right(updated.toEntity());
    } catch (e) {
      return Left(ServerFailure(errorMessage));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask({
    required String title,
    required String projectId,
    required TaskPriority priority,
    String? description,
  }) async {
    try {
      final priorityStr = priority.name;
      final newTask = await _remoteDatasource.createTask(
        projectId: projectId,
        title: title,
        description: description,
        priority: priorityStr,
      );
      await _localDatasource.saveTask(newTask);
      return Right(newTask.toEntity());
    } on AuthException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on PostgrestException catch (e) {
      return _tryLocalCreate(title, projectId, priority, description, e.message);
    } catch (e) {
      return _tryLocalCreate(title, projectId, priority, description, e.toString());
    }
  }

  Future<Either<Failure, TaskEntity>> _tryLocalCreate(
    String title,
    String projectId,
    TaskPriority priority,
    String? description,
    String errorMessage,
  ) async {
    try {
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final newTask = TaskModel(
        id: tempId,
        projectId: projectId,
        title: title,
        description: description,
        status: 'pending',
        priority: priority.name,
        createdAt: DateTime.now().toIso8601String(),
      );
      await _localDatasource.saveTask(newTask);
      return Right(newTask.toEntity());
    } catch (e) {
      return Left(ServerFailure(errorMessage));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await _remoteDatasource.deleteTask(taskId);
      // Clean from cache if possible
      final allTasks = _localDatasource.hiveStorage.readAll<TaskModel>(HiveBoxes.tasks);
      final task = allTasks.firstWhere((t) => t.id == taskId, orElse: () => throw Exception());
      await _localDatasource.deleteTask(task.projectId, taskId);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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
}
