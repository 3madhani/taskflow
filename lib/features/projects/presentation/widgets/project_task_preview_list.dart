import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/project_entity.dart';
import 'project_task_preview_item.dart';

class ProjectTaskPreviewList extends StatelessWidget {
  final List<TaskSummary> tasks;

  const ProjectTaskPreviewList({
    required this.tasks,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (tasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : AppColors.backgroundLight.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.borderLight,
          ),
        ),
        child: Text(
          'No tasks yet',
          style: AppTextStyles.bodyM(color: Colors.grey),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : AppColors.backgroundLight.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tasks',
                style: AppTextStyles.label(),
              ),
              Text(
                '${tasks.length}',
                style: AppTextStyles.caption(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          const Divider(height: 1),
          ...tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;
            return Column(
              children: [
                ProjectTaskPreviewItem(task: task),
                if (index != tasks.length - 1) const Divider(height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }
}
