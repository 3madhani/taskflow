import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/project_entity.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import 'project_card.dart';

class DismissibleProjectCard extends StatelessWidget {
  final ProjectEntity project;

  const DismissibleProjectCard({
    required this.project,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(project.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<ProjectsBloc>().add(DeleteProject(project.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project "${project.name}" deleted'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: ProjectCard(project: project),
    );
  }
}
