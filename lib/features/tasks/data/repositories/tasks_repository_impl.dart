import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/helper/task_helper.dart';
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
  Future<Either<Failure, List<TaskEntity>>> getTasksByProject(
      String projectId) async {
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
            'Connection failed: $errorMessage. No cached data available.'));
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
      final updatedModel = await _remoteDatasource.updateTaskStatus(
        taskId: taskId,
        status: TaskHelper.statusValue(newStatus),
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

  @override
  Future<Either<Failure, TaskEntity>> updateTask({
    required String taskId,
    required String title,
    required TaskStatus status,
    required TaskPriority priority,
    String? description,
  }) async {
    try {
      final updatedModel = await _remoteDatasource.updateTask(
        taskId: taskId,
        title: title,
        description: description,
        status: TaskHelper.statusValue(status),
        priority: TaskHelper.priorityValue(priority),
      );
      await _localDatasource.saveTask(updatedModel);
      return Right(updatedModel.toEntity());
    } on AuthException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on PostgrestException catch (e) {
      return _tryLocalTaskUpdate(
        taskId: taskId,
        title: title,
        description: description,
        status: status,
        priority: priority,
        errorMessage: e.message,
      );
    } catch (e) {
      return _tryLocalTaskUpdate(
        taskId: taskId,
        title: title,
        description: description,
        status: status,
        priority: priority,
        errorMessage: e.toString(),
      );
    }
  }

  Future<Either<Failure, TaskEntity>> _tryLocalTaskUpdate({
    required String taskId,
    required String title,
    required TaskStatus status,
    required TaskPriority priority,
    required String errorMessage,
    String? description,
  }) async {
    try {
      final allTasks =
          _localDatasource.hiveStorage.readAll<TaskModel>(HiveBoxes.tasks);
      final task = allTasks.firstWhere((t) => t.id == taskId);
      final updated = TaskModel(
        id: task.id,
        title: title,
        projectId: task.projectId,
        description: description,
        status: TaskHelper.statusValue(status),
        priority: TaskHelper.priorityValue(priority),
        createdAt: task.createdAt,
      );
      await _localDatasource.saveTask(updated);
      return Right(updated.toEntity());
    } catch (e) {
      return Left(ServerFailure(errorMessage));
    }
  }

  Future<Either<Failure, TaskEntity>> _tryLocalUpdate(
      String taskId, TaskStatus newStatus, String errorMessage) async {
    try {
      final allTasks =
          _localDatasource.hiveStorage.readAll<TaskModel>(HiveBoxes.tasks);
      final task = allTasks.firstWhere((t) => t.id == taskId);
      final updated = TaskModel(
        id: task.id,
        title: task.title,
        projectId: task.projectId,
        description: task.description,
        status: TaskHelper.statusValue(newStatus),
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
    required TaskStatus status,
    required TaskPriority priority,
    String? description,
  }) async {
    try {
      final newTask = await _remoteDatasource.createTask(
        projectId: projectId,
        title: title,
        description: description,
        status: TaskHelper.statusValue(status),
        priority: TaskHelper.priorityValue(priority),
      );
      await _localDatasource.saveTask(newTask);
      return Right(newTask.toEntity());
    } on AuthException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on PostgrestException catch (e) {
      return _tryLocalCreate(
          title, projectId, status, priority, description, e.message);
    } catch (e) {
      return _tryLocalCreate(
          title, projectId, status, priority, description, e.toString());
    }
  }

  Future<Either<Failure, TaskEntity>> _tryLocalCreate(
    String title,
    String projectId,
    TaskStatus status,
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
        status: TaskHelper.statusValue(status),
        priority: TaskHelper.priorityValue(priority),
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
      final allTasks =
          _localDatasource.hiveStorage.readAll<TaskModel>(HiveBoxes.tasks);
      final task = allTasks.firstWhere((t) => t.id == taskId,
          orElse: () => throw Exception());
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
}
