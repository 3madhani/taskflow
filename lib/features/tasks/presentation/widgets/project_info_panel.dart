import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../projects/domain/entities/project_entity.dart';
import '../../../projects/presentation/widgets/project_card_media.dart';

class ProjectInfoPanel extends StatelessWidget {
  final ProjectEntity project;

  const ProjectInfoPanel({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();
    final priorityColor = _priorityColor();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectCardMedia(
            imageUrl: project.imageUrl,
            height: 190,
            borderRadius: BorderRadius.circular(20),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(project.name, style: AppTextStyles.headingM()),
          const SizedBox(height: AppSpacing.sm),
          Text(
            project.description?.trim().isNotEmpty == true
                ? project.description!.trim()
                : 'No description',
            style: AppTextStyles.bodyM(color: Colors.grey),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _InfoChip(
                label: _statusLabel(),
                color: statusColor,
              ),
              _InfoChip(
                label: _priorityLabel(),
                color: priorityColor,
              ),
              _InfoChip(
                label: project.totalTasks > 0
                    ? '${project.totalTasks} tasks'
                    : 'No tasks',
                color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                filled: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor() {
    return switch (project.status) {
      ProjectStatus.active => AppColors.statusActive,
      ProjectStatus.onHold => AppColors.statusOnHold,
      ProjectStatus.completed => AppColors.statusCompleted,
    };
  }

  Color _priorityColor() {
    return switch (project.priority) {
      ProjectPriority.low => AppColors.priorityLow,
      ProjectPriority.medium => AppColors.priorityMedium,
      ProjectPriority.high => AppColors.priorityHigh,
    };
  }

  String _statusLabel() {
    return switch (project.status) {
      ProjectStatus.active => 'Active',
      ProjectStatus.onHold => 'On Hold',
      ProjectStatus.completed => 'Completed',
    };
  }

  String _priorityLabel() {
    return switch (project.priority) {
      ProjectPriority.low => 'Low',
      ProjectPriority.medium => 'Medium',
      ProjectPriority.high => 'High',
    };
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;

  const _InfoChip({
    required this.label,
    required this.color,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: filled ? color.withAlpha(25) : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: filled ? color.withAlpha(80) : color.withAlpha(40),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption(color: color),
      ),
    );
  }
}
