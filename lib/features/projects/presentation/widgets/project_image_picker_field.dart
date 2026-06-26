import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/helper/image_helper.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import 'project_card_media.dart';

class ProjectImagePickerField extends StatefulWidget {
  final TextEditingController controller;

  const ProjectImagePickerField({
    required this.controller,
    super.key,
  });

  @override
  State<ProjectImagePickerField> createState() =>
      _ProjectImagePickerFieldState();
}

class _ProjectImagePickerFieldState extends State<ProjectImagePickerField> {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder: (context, value, _) {
        final imageValue = value.text.trim();
        final hasImage = imageValue.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project image (optional)',
              style: AppTextStyles.label(
                color: theme.colorScheme.onSurface.withAlpha(180),
              ),
            ),
            const SizedBox(height: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: hasImage
                  ? ProjectCardMedia(
                      key: ValueKey(imageValue),
                      imageUrl: imageValue,
                      height: 132,
                      borderRadius: BorderRadius.circular(16),
                    )
                  : _ImagePlaceholder(theme: theme),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isPicking ? null : _pickImage,
                    icon: _isPicking
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.photo_library_rounded),
                    label: Text(hasImage ? 'Change photo' : 'Choose photo'),
                  ),
                ),
                if (hasImage) ...[
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filledTonal(
                    tooltip: 'Remove photo',
                    onPressed: _clearImage,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  void _clearImage() {
    widget.controller.clear();
  }

  Future<void> _pickImage() async {
    setState(() => _isPicking = true);

    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );

      if (image == null) {
        return;
      }

      final storedImagePath = await ImageHelper.storeProjectImage(image);
      if (!mounted) {
        return;
      }

      widget.controller.text = storedImagePath;
    } catch (error, stackTrace) {
      debugPrint('Project image picker failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      AppSnackBar.show(
        context,
        message: ImageHelper.imagePickerErrorMessage(error),
        type: AppSnackBarType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final ThemeData theme;

  const _ImagePlaceholder({required this.theme});

  @override
  Widget build(BuildContext context) {
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.borderDark
        : AppColors.borderLight;

    return Container(
      key: const ValueKey('project-image-placeholder'),
      width: double.infinity,
      height: 132,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Icon(
        Icons.add_photo_alternate_rounded,
        color: theme.colorScheme.onSurface.withAlpha(120),
        size: 36,
      ),
    );
  }
}
