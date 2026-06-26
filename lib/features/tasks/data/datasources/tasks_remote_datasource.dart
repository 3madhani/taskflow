import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task_model.dart';

@injectable
class TasksRemoteDatasource {
  final _db = Supabase.instance.client;

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

  Future<TaskModel> createTask({
    required String projectId,
    required String title,
    String? description,
    required String status,
    required String priority,
  }) async {
    final response = await _db
        .from('tasks')
        .insert({
          'project_id': projectId,
          'title': title,
          'description': description,
          'status': status,
          'priority': priority,
        })
        .select()
        .single();
    return TaskModel.fromJson(response);
  }

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
    return TaskModel.fromJson(response);
  }

  Future<TaskModel> updateTask({
    required String taskId,
    required String title,
    required String status,
    required String priority,
    String? description,
  }) async {
    final response = await _db
        .from('tasks')
        .update({
          'title': title,
          'description': description,
          'status': status,
          'priority': priority,
        })
        .eq('id', taskId)
        .select()
        .single();
    return TaskModel.fromJson(response);
  }

  Future<void> deleteTask(String taskId) async {
    await _db.from('tasks').delete().eq('id', taskId);
  }
}
