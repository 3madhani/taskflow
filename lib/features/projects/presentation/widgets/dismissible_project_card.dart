import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/destructive_swipe_background.dart';
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
      background: const DestructiveSwipeBackground(
        label: 'Delete project',
        borderRadius: 18,
      ),
      onDismissed: (_) {
        context.read<ProjectsBloc>().add(DeleteProject(project.id));
        AppSnackBar.show(
          context,
          message: 'Project "${project.name}" deleted',
          type: AppSnackBarType.info,
        );
      },
      child: ProjectCard(project: project),
    );
  }
}
