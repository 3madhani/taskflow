import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import 'project_card_media.dart';

class ProjectImageUrlField extends StatelessWidget {
  final TextEditingController controller;

  const ProjectImageUrlField({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final imageUrl = value.text.trim();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Project image (optional)',
              hintText: 'Paste an image URL',
              controller: controller,
              keyboardType: TextInputType.url,
            ),
            if (imageUrl.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              ProjectCardMedia(
                imageUrl: imageUrl,
                height: 132,
                borderRadius: BorderRadius.circular(16),
              ),
            ],
          ],
        );
      },
    );
  }
}
