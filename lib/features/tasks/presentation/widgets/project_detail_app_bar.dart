import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/helper/text_helper.dart';
import '../../../projects/domain/entities/project_entity.dart';

class ProjectDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String projectId;
  final ProjectEntity? project;

  const ProjectDetailAppBar({
    required this.projectId,
    this.project,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final project = this.project;

    return AppBar(
      leading: project != null
          ? Hero(
              tag: 'project_icon_${project.id}',
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.folder_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            )
          : null,
      title: Text(
        project?.name ?? 'Project #${TextHelper.shortId(projectId)}',
        style: AppTextStyles.headingS(),
      ),
    );
  }
}
