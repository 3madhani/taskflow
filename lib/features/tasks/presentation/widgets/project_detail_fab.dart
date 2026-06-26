import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ProjectDetailFab extends StatelessWidget {
  final VoidCallback onPressed;

  const ProjectDetailFab({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_rounded),
      label: const Text('Task'),
    );
  }
}
