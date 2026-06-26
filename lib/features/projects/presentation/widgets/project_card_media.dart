import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

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
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
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
                  Image.network(
                    imageUrl!.trim(),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallback(theme),
                  ),
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
