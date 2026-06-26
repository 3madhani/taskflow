import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/helper/date_time_helper.dart';
import '../../../../core/helper/project_helper.dart';
import '../../domain/entities/project_entity.dart';
import 'project_card_media.dart';
import 'project_priority_selector.dart';
import 'project_status_selector.dart';
import 'project_task_preview_list.dart';

class ProjectCard extends StatefulWidget {
  final ProjectEntity project;
  final bool isUpdating;
  final ValueChanged<ProjectStatus>? onStatusChanged;
  final ValueChanged<ProjectPriority>? onPriorityChanged;

  const ProjectCard({
    required this.project,
    this.isUpdating = false,
    this.onStatusChanged,
    this.onPriorityChanged,
    super.key,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isExpanded = false;

  ProjectEntity get project => widget.project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = ProjectHelper.statusColor(project.status);
    final priorityColor = ProjectHelper.priorityColor(project.priority);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: theme.brightness == Brightness.dark
              ? AppColors.borderDark
              : AppColors.borderLight,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: _toggleExpanded,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProjectCardMedia(
              imageUrl: project.imageUrl,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              height: 156,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withAlpha(200),
                              AppColors.secondary.withAlpha(200),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.folder_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.name,
                              style: AppTextStyles.headingS(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              project.description?.trim().isNotEmpty == true
                                  ? project.description!.trim()
                                  : 'No description',
                              style: AppTextStyles.bodyM(color: Colors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 13,
                                  color: theme.colorScheme.onSurface
                                      .withAlpha(130),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  'Created ${DateTimeHelper.compactDate(project.createdAt)}',
                                  style: AppTextStyles.caption(
                                    color: theme.colorScheme.onSurface
                                        .withAlpha(130),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Column(
                        children: [
                          if (widget.isUpdating)
                            const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          if (widget.isUpdating)
                            const SizedBox(height: AppSpacing.sm),
                          AnimatedRotation(
                            turns: _isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 220),
                            child: Icon(
                              Icons.expand_more_rounded,
                              color: theme.colorScheme.onSurface.withAlpha(180),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      _ProjectMetaChip(
                        label: ProjectHelper.statusLabel(project.status),
                        color: statusColor,
                      ),
                      _ProjectMetaChip(
                        label: ProjectHelper.priorityLabel(project.priority),
                        color: priorityColor,
                      ),
                      _ProjectMetaChip(
                        label: project.totalTasks > 0
                            ? '${project.doneTasks}/${project.totalTasks} tasks'
                            : 'No tasks yet',
                        color: theme.colorScheme.onSurface.withAlpha(180),
                        filled: false,
                      ),
                    ],
                  ),
                  if (project.totalTasks > 0) ...[
                    const SizedBox(height: AppSpacing.md),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: project.progress,
                        backgroundColor: theme.brightness == Brightness.dark
                            ? Colors.grey[850]
                            : Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          project.progress == 1.0
                              ? AppColors.success
                              : AppColors.primary,
                        ),
                        minHeight: 4,
                      ),
                    ),
                  ],
                  AnimatedSize(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    child: _isExpanded
                        ? Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Status',
                                  style: AppTextStyles.label(
                                    color: theme.colorScheme.onSurface
                                        .withAlpha(170),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                ProjectStatusSelector(
                                  selectedStatus: project.status,
                                  onChanged: widget.isUpdating
                                      ? null
                                      : widget.onStatusChanged,
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                Text(
                                  'Priority',
                                  style: AppTextStyles.label(
                                    color: theme.colorScheme.onSurface
                                        .withAlpha(170),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                ProjectPrioritySelector(
                                  selectedPriority: project.priority,
                                  onChanged: widget.isUpdating
                                      ? null
                                      : widget.onPriorityChanged,
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                ProjectTaskPreviewList(tasks: project.tasks),
                                const SizedBox(height: AppSpacing.md),
                                Align(
                                  alignment: Alignment.center,
                                  child: TextButton.icon(
                                    onPressed: _openDetails,
                                    icon: const Icon(Icons.open_in_new_rounded),
                                    label: const Text('Open project'),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails() {
    context.push(
      '/projects/${project.id}',
      extra: {
        'id': project.id,
        'userId': project.userId,
        'name': project.name,
        'description': project.description,
        'imageUrl': project.imageUrl,
        'statusIndex': project.status.index,
        'priorityIndex': project.priority.index,
        'createdAt': project.createdAt.toIso8601String(),
      },
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}

class _ProjectMetaChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;

  const _ProjectMetaChip({
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
