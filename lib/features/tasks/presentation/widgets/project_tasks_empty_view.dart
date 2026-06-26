import 'package:flutter/material.dart';

import '../../../../core/widgets/empty_state_widget.dart';

class ProjectTasksEmptyView extends StatelessWidget {
  const ProjectTasksEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.task_alt_rounded,
      title: 'No Tasks Yet',
      subtitle: 'Add your first task using the + button.',
    );
  }
}
