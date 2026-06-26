import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../projects/domain/entities/project_entity.dart';

class ProjectInfoPanel extends StatelessWidget {
  final ProjectEntity project;

  const ProjectInfoPanel({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child:
                const Icon(Icons.folder_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(project.name, style: AppTextStyles.headingM()),
          const SizedBox(height: AppSpacing.sm),
          Text(project.description ?? 'No description',
              style: AppTextStyles.bodyM(color: Colors.grey)),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: _statusColor().withAlpha(25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _statusColor().withAlpha(80)),
            ),
            child: Text(
              _statusLabel(),
              style: AppTextStyles.label(color: _statusColor()),
            ),
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

  String _statusLabel() {
    return switch (project.status) {
      ProjectStatus.active => 'Active',
      ProjectStatus.onHold => 'On Hold',
      ProjectStatus.completed => 'Completed',
    };
  }
}
