import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/project_model.dart';

@injectable
class ProjectsRemoteDatasource {
  final _db = Supabase.instance.client;

  Future<List<ProjectModel>> getProjects() async {
    final response = await _db
        .from('projects')
        .select('*, tasks(*)')
        .order('created_at', ascending: false);
    return (response as List)
        .map((json) => ProjectModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProjectModel> createProject({
    required String name,
    String? description,
    required String status,
    required String priority,
  }) async {
    final userId = _db.auth.currentUser!.id;
    final response = await _db
        .from('projects')
        .insert({
          'user_id': userId,
          'name': name,
          'description': description,
          'status': status,
          'priority': priority,
        })
        .select('*, tasks(*)')
        .single();
    return ProjectModel.fromJson(response);
  }

  Future<void> deleteProject(String projectId) async {
    await _db.from('projects').delete().eq('id', projectId);
  }
}
