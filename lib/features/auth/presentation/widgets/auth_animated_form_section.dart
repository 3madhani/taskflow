import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';

class AuthAnimatedFormSection extends StatelessWidget {
  final bool visible;
  final Widget child;

  const AuthAnimatedFormSection({
    required this.visible,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        reverseDuration: const Duration(milliseconds: 180),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curvedAnimation,
            child: SizeTransition(
              sizeFactor: curvedAnimation,
              alignment: Alignment.topCenter,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.08),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            ),
          );
        },
        child: visible
            ? Padding(
                key: const ValueKey('visible-auth-section'),
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: child,
              )
            : const SizedBox(
                key: ValueKey('hidden-auth-section'),
                width: double.infinity,
              ),
      ),
    );
  }
}
