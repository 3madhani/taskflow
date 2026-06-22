import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/task_model.dart';

@injectable
class TasksRemoteDatasource {
  final DioClient _dioClient;

  const TasksRemoteDatasource(this._dioClient);

  Future<List<TaskModel>> getTasksByProject(int projectId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.photosByAlbum(projectId),
      );
      final data = response.data as List<dynamic>;
      return data
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.appException;
    }
  }

  Future<TaskModel> updateTaskStatus({
    required int taskId,
    required String newStatus,
  }) async {
    try {
      final response = await _dioClient.dio.patch(
        ApiEndpoints.photoById(taskId),
        data: {'status': newStatus},
      );
      // JSONPlaceholder returns the patched object; rebuild with our status
      final data = response.data as Map<String, dynamic>;
      // Since JSONPlaceholder doesn't persist, we update the status in our mapping
      data['status'] = newStatus;
      return TaskModel.fromJson(data);
    } on DioException catch (e) {
      throw e.appException;
    }
  }

  Future<TaskModel> createTask({
    required String title,
    required int projectId,
    required String priority,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.photos,
        data: {
          'title': title,
          'albumId': projectId,
          'url': 'https://via.placeholder.com/600/92c952',
          'thumbnailUrl': 'https://via.placeholder.com/150/92c952',
          'priority': priority,
        },
      );
      final data = response.data as Map<String, dynamic>;
      // JSONPlaceholder returns id=101 for all new posts
      return TaskModel(
        id: data['id'] as int? ?? DateTime.now().millisecondsSinceEpoch,
        title: title,
        projectId: projectId,
        status: 'pending',
        priority: priority,
      );
    } on DioException catch (e) {
      throw e.appException;
    }
  }
}
