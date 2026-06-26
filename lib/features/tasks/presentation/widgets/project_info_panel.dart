import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/helper/date_time_helper.dart';
import '../../../../core/helper/project_helper.dart';
import '../../../projects/domain/entities/project_entity.dart';
import '../../../projects/presentation/widgets/project_card_media.dart';

class ProjectInfoPanel extends StatelessWidget {
  final ProjectEntity project;

  const ProjectInfoPanel({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    final statusColor = ProjectHelper.statusColor(project.status);
    final priorityColor = ProjectHelper.priorityColor(project.priority);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: SingleChildScrollView(
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
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 13,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(130),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Created ${DateTimeHelper.compactDate(project.createdAt)}',
                  style: AppTextStyles.caption(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(130),
                  ),
                ),
              ],
            ),
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
                  label: ProjectHelper.statusLabel(project.status),
                  color: statusColor,
                ),
                _InfoChip(
                  label: ProjectHelper.priorityLabel(project.priority),
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
            if (project.totalTasks > 0) ...[
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Project progress',
                      style: AppTextStyles.label(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(180),
                      ),
                    ),
                  ),
                  Text(
                    '${(project.progress * 100).round()}%',
                    style: AppTextStyles.label(color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: project.progress,
                  minHeight: 6,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    project.progress == 1.0
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
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
