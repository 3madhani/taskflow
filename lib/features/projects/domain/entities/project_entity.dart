import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

export '../../../../core/enums/app_enums.dart' show ProjectStatus;


class ProjectEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final ProjectStatus status;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  @override
  List<Object?> get props => [id, title, description, status];
}
