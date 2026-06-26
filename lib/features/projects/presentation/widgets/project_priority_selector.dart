import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/helper/project_helper.dart';
import '../../domain/entities/project_entity.dart';

class ProjectPrioritySelector extends StatelessWidget {
  final ProjectPriority selectedPriority;
  final ValueChanged<ProjectPriority>? onChanged;

  const ProjectPrioritySelector({
    required this.selectedPriority,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final priority in ProjectPriority.values) ...[
          Expanded(
            child: _ProjectPriorityOption(
              priority: priority,
              isSelected: selectedPriority == priority,
              onTap: onChanged == null ? null : () => onChanged!(priority),
            ),
          ),
          if (priority != ProjectPriority.values.last)
            const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _ProjectPriorityOption extends StatelessWidget {
  final ProjectPriority priority;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ProjectPriorityOption({
    required this.priority,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = ProjectHelper.priorityColor(priority);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: isSelected ? color.withAlpha(28) : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? color.withAlpha(130)
                  : theme.brightness == Brightness.dark
                      ? AppColors.borderDark
                      : AppColors.borderLight,
            ),
          ),
          child: Column(
            children: [
              Icon(ProjectHelper.priorityIcon(priority),
                  color: color, size: 18),
              const SizedBox(height: AppSpacing.xs),
              Text(
                ProjectHelper.priorityLabel(priority),
                style: AppTextStyles.caption(
                  color: isSelected
                      ? color
                      : theme.colorScheme.onSurface.withAlpha(170),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
