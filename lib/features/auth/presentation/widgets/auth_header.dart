import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final IconData icon;
  final String subtitle;
  final List<Color> gradientColors;

  const AuthHeader({
    required this.icon,
    required this.subtitle,
    required this.gradientColors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withAlpha(80),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 36),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'TaskFlow',
          style: AppTextStyles.headingL(),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: AppTextStyles.bodyM(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
