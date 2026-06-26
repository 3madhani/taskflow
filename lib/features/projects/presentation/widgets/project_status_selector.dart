import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/helper/project_helper.dart';
import '../../domain/entities/project_entity.dart';

class ProjectStatusSelector extends StatelessWidget {
  final ProjectStatus selectedStatus;
  final ValueChanged<ProjectStatus>? onChanged;

  const ProjectStatusSelector({
    required this.selectedStatus,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final status in ProjectStatus.values)
          _ProjectStatusOption(
            status: status,
            isSelected: selectedStatus == status,
            onTap: onChanged == null ? null : () => onChanged!(status),
          ),
      ],
    );
  }
}

class _ProjectStatusOption extends StatelessWidget {
  final ProjectStatus status;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ProjectStatusOption({
    required this.status,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = ProjectHelper.statusColor(status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? color.withAlpha(32) : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? color.withAlpha(140)
                  : theme.brightness == Brightness.dark
                      ? AppColors.borderDark
                      : AppColors.borderLight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(ProjectHelper.statusIcon(status), size: 17, color: color),
              const SizedBox(width: AppSpacing.xs),
              Text(
                ProjectHelper.statusLabel(status),
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
