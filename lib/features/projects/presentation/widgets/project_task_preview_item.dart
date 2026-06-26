import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/helper/task_helper.dart';
import '../../domain/entities/project_entity.dart';

class ProjectTaskPreviewItem extends StatelessWidget {
  final TaskSummary task;

  const ProjectTaskPreviewItem({
    required this.task,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = TaskHelper.statusColorFromValue(task.status);
    final priorityColor = TaskHelper.priorityColorFromValue(task.priority);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppTextStyles.bodyM(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if ((task.description ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    task.description!.trim(),
                    style: AppTextStyles.caption(color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _TinyLabel(
                label: TaskHelper.statusLabelFromValue(task.status),
                color: statusColor,
              ),
              const SizedBox(height: 4),
              _TinyLabel(
                label: TaskHelper.priorityLabelFromValue(task.priority),
                color: priorityColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TinyLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _TinyLabel({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(75)),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption(color: color),
      ),
    );
  }
}
