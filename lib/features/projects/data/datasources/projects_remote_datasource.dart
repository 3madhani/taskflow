import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/project_model.dart';

@injectable
class ProjectsRemoteDatasource {
  final DioClient _dioClient;

  const ProjectsRemoteDatasource(this._dioClient);

  Future<List<ProjectModel>> getProjects() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.albums);
      final data = response.data as List<dynamic>;
      return data
          .map((json) => ProjectModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.appException;
    }
  }
}
