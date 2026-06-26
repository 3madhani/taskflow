import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/helper/image_helper.dart';

class ProjectCardMedia extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final BorderRadius borderRadius;

  const ProjectCardMedia({
    required this.imageUrl,
    this.height = 152,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imageValue = imageUrl?.trim();
    final hasImage = imageValue != null && imageValue.isNotEmpty;
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(imageValue, theme),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(70),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : _fallback(theme),
      ),
    );
  }

  Widget _buildImage(String imageValue, ThemeData theme) {
    if (ImageHelper.isDataImage(imageValue)) {
      final bytes = ImageHelper.decodeDataImage(imageValue);
      if (bytes == null) {
        return _fallback(theme);
      }

      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(theme),
      );
    }

    final uri = Uri.tryParse(imageValue);
    final isRemoteImage =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    if (!isRemoteImage) {
      return _buildFileImage(imageValue, theme);
    }

    return Image.network(
      imageValue,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(theme),
    );
  }

  Widget _buildFileImage(String imageValue, ThemeData theme) {
    final file = File(imageValue);
    if (!file.existsSync()) {
      return _fallback(theme);
    }

    return Image.file(
      file,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(theme),
    );
  }

  Widget _fallback(ThemeData theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary
                .withAlpha(theme.brightness == Brightness.dark ? 210 : 180),
            AppColors.secondary
                .withAlpha(theme.brightness == Brightness.dark ? 210 : 180),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(32),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withAlpha(40)),
          ),
          child: const Icon(
            Icons.folder_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }
}
