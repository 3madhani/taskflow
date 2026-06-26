import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/project_model.dart';

/// Projects remote datasource using Supabase PostgREST.
/// Every request automatically includes the JWT Bearer token injected by the SDK.
/// Row Level Security on the DB ensures users only see their own projects.
@injectable
class ProjectsRemoteDatasource {
  final _db = Supabase.instance.client;

  /// GET all projects for the logged-in user (RLS scopes automatically).
  /// Uses .select('*, tasks(*)') to join tasks in one call.
  Future<List<ProjectModel>> getProjects() async {
    final response = await _db
        .from('projects')
        .select('*, tasks(*)')
        .order('created_at', ascending: false);
    return (response as List)
        .map((json) => ProjectModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// POST — create a new project.
  Future<ProjectModel> createProject({
    required String name,
    String? description,
    required String status,
    required String priority,
  }) async {
    final userId = _db.auth.currentUser!.id;
    final response = await _db.from('projects').insert({
      'user_id': userId,
      'name': name,
      'description': description,
      'status': status,
      'priority': priority,
    }).select('*, tasks(*)').single();
    return ProjectModel.fromJson(response);
  }

  /// DELETE — cascade deletes tasks via FK.
  Future<void> deleteProject(String projectId) async {
    await _db.from('projects').delete().eq('id', projectId);
  }
}
