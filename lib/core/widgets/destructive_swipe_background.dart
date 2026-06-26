import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

class DestructiveSwipeBackground extends StatelessWidget {
  final String label;
  final double borderRadius;

  const DestructiveSwipeBackground({
    required this.label,
    this.borderRadius = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.label(color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.delete_rounded, color: Colors.white),
        ],
      ),
    );
  }
}
