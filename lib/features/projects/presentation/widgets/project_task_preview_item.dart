import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/project_entity.dart';

class ProjectTaskPreviewItem extends StatelessWidget {
  final TaskSummary task;

  const ProjectTaskPreviewItem({
    required this.task,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();
    final priorityColor = _priorityColor();

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
                label: _statusLabel(),
                color: statusColor,
              ),
              const SizedBox(height: 4),
              _TinyLabel(
                label: _priorityLabel(),
                color: priorityColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor() {
    return switch (task.status) {
      'done' => AppColors.statusDone,
      'in_progress' => AppColors.statusInProgress,
      _ => AppColors.statusPending,
    };
  }

  String _statusLabel() {
    return switch (task.status) {
      'done' => 'Done',
      'in_progress' => 'In Progress',
      _ => 'Pending',
    };
  }

  Color _priorityColor() {
    return switch (task.priority) {
      'low' => AppColors.priorityLow,
      'high' => AppColors.priorityHigh,
      _ => AppColors.priorityMedium,
    };
  }

  String _priorityLabel() {
    return switch (task.priority) {
      'low' => 'Low',
      'high' => 'High',
      _ => 'Medium',
    };
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
