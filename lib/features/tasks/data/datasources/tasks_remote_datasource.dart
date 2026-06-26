import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task_model.dart';

@injectable
class TasksRemoteDatasource {
  final _db = Supabase.instance.client;

  /// GET tasks for a specific project
  Future<List<TaskModel>> getTasks(String projectId) async {
    final response = await _db
        .from('tasks')
        .select()
        .eq('project_id', projectId)
        .order('created_at', ascending: true);
    return (response as List)
        .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// POST — create task
  Future<TaskModel> createTask({
    required String projectId,
    required String title,
    String? description,
    required String priority,
  }) async {
    final response = await _db.from('tasks').insert({
      'project_id': projectId,
      'title': title,
      'description': description,
      'status': 'pending',
      'priority': priority,
    }).select().single();
    return TaskModel.fromJson(response as Map<String, dynamic>);
  }

  /// PATCH — update task status (cycle: pending → in_progress → done)
  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required String status,
  }) async {
    final response = await _db
        .from('tasks')
        .update({'status': status})
        .eq('id', taskId)
        .select()
        .single();
    return TaskModel.fromJson(response as Map<String, dynamic>);
  }

  /// DELETE — remove a task
  Future<void> deleteTask(String taskId) async {
    await _db.from('tasks').delete().eq('id', taskId);
  }
}
