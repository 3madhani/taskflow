import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/task_entity.dart';
import 'task_visuals.dart';

class TaskPrioritySelector extends StatelessWidget {
  final TaskPriority selectedPriority;
  final ValueChanged<TaskPriority> onChanged;

  const TaskPrioritySelector({
    required this.selectedPriority,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final priority in TaskPriority.values) ...[
          Expanded(
            child: _PriorityOption(
              priority: priority,
              isSelected: selectedPriority == priority,
              onTap: () => onChanged(priority),
            ),
          ),
          if (priority != TaskPriority.values.last)
            const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _PriorityOption extends StatelessWidget {
  final TaskPriority priority;
  final bool isSelected;
  final VoidCallback onTap;

  const _PriorityOption({
    required this.priority,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = TaskVisuals.priorityColor(priority);

    return InkWell(
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
            Icon(
              TaskVisuals.priorityIcon(priority),
              color: color,
              size: 18,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              TaskVisuals.priorityLabel(priority),
              style: AppTextStyles.caption(
                color: isSelected
                    ? color
                    : theme.colorScheme.onSurface.withAlpha(170),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
