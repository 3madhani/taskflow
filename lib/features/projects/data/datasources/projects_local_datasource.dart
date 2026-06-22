import 'package:injectable/injectable.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/storage/hive_constants.dart';
import '../../../../core/storage/hive_storage.dart';
import '../models/project_model.dart';

@injectable
class ProjectsLocalDatasource {
  final HiveStorage _hiveStorage;

  const ProjectsLocalDatasource(this._hiveStorage);

  Future<void> cacheProjects(List<ProjectModel> projects) async {
    try {
      final map = {for (var p in projects) p.id.toString(): p};
      await _hiveStorage.writeAll<ProjectModel>(HiveBoxes.projects, map);
    } catch (e) {
      throw CacheException('Failed to cache projects: ${e.toString()}');
    }
  }

  List<ProjectModel> getCachedProjects() {
    try {
      return _hiveStorage.readAll<ProjectModel>(HiveBoxes.projects);
    } catch (e) {
      throw CacheException('Failed to read cached projects: ${e.toString()}');
    }
  }
}
