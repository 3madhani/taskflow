import 'dart:io';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/helper/image_helper.dart';
import '../models/project_model.dart';

@injectable
class ProjectsRemoteDatasource {
  static const _projectImagesBucket = 'project-images';

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
    String? imageUrl,
    required String status,
    required String priority,
  }) async {
    final userId = _db.auth.currentUser!.id;
    final storedImageUrl = await _uploadProjectImage(imageUrl, userId);
    final response = await _db
        .from('projects')
        .insert({
          'user_id': userId,
          'name': name,
          'description': description,
          'image_url': storedImageUrl,
          'status': status,
          'priority': priority,
        })
        .select('*, tasks(*)')
        .single();
    return ProjectModel.fromJson(response);
  }

  Future<ProjectModel> updateProjectMeta({
    required String projectId,
    required String status,
    required String priority,
  }) async {
    final response = await _db
        .from('projects')
        .update({
          'status': status,
          'priority': priority,
        })
        .eq('id', projectId)
        .select('*, tasks(*)')
        .single();
    return ProjectModel.fromJson(response);
  }

  Future<void> deleteProject(String projectId) async {
    await _db.from('projects').delete().eq('id', projectId);
  }

  Future<String?> _uploadProjectImage(String? imageValue, String userId) async {
    final trimmedImageValue = imageValue?.trim();
    if (trimmedImageValue == null || trimmedImageValue.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(trimmedImageValue);
    final isRemoteImage =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    if (isRemoteImage) {
      return trimmedImageValue;
    }

    final extension = _extensionForImageValue(trimmedImageValue);
    final objectPath =
        '$userId/${DateTime.now().microsecondsSinceEpoch}$extension';
    final bucket = _db.storage.from(_projectImagesBucket);

    await bucket.uploadBinary(
      objectPath,
      await _readImageBytes(trimmedImageValue),
      fileOptions: FileOptions(
        cacheControl: '31536000',
        contentType: _contentTypeForExtension(extension),
      ),
    );

    return bucket.getPublicUrl(objectPath);
  }

  Future<Uint8List> _readImageBytes(String imageValue) async {
    if (ImageHelper.isDataImage(imageValue)) {
      final bytes = ImageHelper.decodeDataImage(imageValue);
      if (bytes == null) {
        throw const FormatException('Invalid project image data');
      }
      return bytes;
    }

    final imageFile = File(imageValue);
    if (!await imageFile.exists()) {
      throw FileSystemException('Project image file not found', imageValue);
    }

    return imageFile.readAsBytes();
  }

  String _extensionForImageValue(String imageValue) {
    if (ImageHelper.isDataImage(imageValue)) {
      final mimeType = RegExp(r'^data:(image/[\w.+-]+);base64,')
          .firstMatch(imageValue)
          ?.group(1);
      return switch (mimeType) {
        'image/png' => '.png',
        'image/webp' => '.webp',
        _ => '.jpg',
      };
    }

    final extension = path.extension(imageValue).toLowerCase();
    return switch (extension) {
      '.jpg' || '.jpeg' || '.png' || '.webp' => extension,
      _ => '.jpg',
    };
  }

  String _contentTypeForExtension(String extension) {
    return switch (extension) {
      '.png' => 'image/png',
      '.webp' => 'image/webp',
      _ => 'image/jpeg',
    };
  }
}
