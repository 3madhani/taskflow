import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import 'animated_shell_nav_bar.dart';
import 'shell_project_fab.dart';

class ShellBottomControls extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onCreateProject;

  const ShellBottomControls({
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.onCreateProject,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isOnProjects = currentIndex == 0;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isOnProjects ? AppSpacing.md : 0,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: ShellProjectFab(
                  visible: isOnProjects,
                  onPressed: onCreateProject,
                ),
              ),
            ),
          ),
          AnimatedShellNavBar(
            currentIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
          ),
        ],
      ),
    );
  }
}
