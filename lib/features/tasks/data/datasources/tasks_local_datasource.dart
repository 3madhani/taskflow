import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/storage/hive_constants.dart';
import '../../../../core/storage/hive_storage.dart';
import '../models/task_model.dart';

@injectable
class TasksLocalDatasource {
  final HiveStorage _hiveStorage;

  const TasksLocalDatasource(this._hiveStorage);

  HiveStorage get hiveStorage => _hiveStorage;

  Future<void> cacheTasks(int projectId, List<TaskModel> tasks) async {
    try {
      final map = {
        for (var t in tasks) '${projectId}_${t.id}': t,
      };
      await _hiveStorage.writeAll<TaskModel>(HiveBoxes.tasks, map);
    } catch (e) {
      throw CacheException('Failed to cache tasks: ${e.toString()}');
    }
  }

  List<TaskModel> getCachedTasks(int projectId) {
    try {
      final all = _hiveStorage.readAll<TaskModel>(HiveBoxes.tasks);
      return all.where((t) => t.projectId == projectId).toList();
    } catch (e) {
      throw CacheException('Failed to read cached tasks: ${e.toString()}');
    }
  }

  Future<void> saveTask(TaskModel task) async {
    try {
      await _hiveStorage.write<TaskModel>(
        HiveBoxes.tasks,
        '${task.projectId}_${task.id}',
        task,
      );
    } catch (e) {
      throw CacheException('Failed to save task: ${e.toString()}');
    }
  }
}
