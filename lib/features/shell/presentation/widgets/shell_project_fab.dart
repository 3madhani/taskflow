import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

const _fabSize = 58.0;
const _fabRadius = 19.0;

class ShellProjectFab extends StatelessWidget {
  final bool visible;
  final VoidCallback onPressed;

  const ShellProjectFab({
    required this.visible,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0.24),
          end: Offset.zero,
        ).animate(animation);

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: SlideTransition(position: offsetAnimation, child: child),
          ),
        );
      },
      child: visible
          ? _ProjectFabButton(
              key: const ValueKey('project-fab'),
              onPressed: onPressed,
            )
          : const SizedBox.shrink(key: ValueKey('project-fab-hidden')),
    );
  }
}

class _ProjectFabButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ProjectFabButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final shadowColor = isDark
        ? primary.withValues(alpha: 0.36)
        : primary.withValues(alpha: 0.22);

    return Tooltip(
      message: 'Create project',
      child: Semantics(
        button: true,
        label: 'Create project',
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(_fabRadius),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(_fabRadius),
            child: Ink(
              width: _fabSize,
              height: _fabSize,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(_fabRadius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: isDark ? 0.16 : 0.42),
                ),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 31,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
