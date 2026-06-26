import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

const _taskFlowIconPath = 'assets/icons/taskflow_icon.png';
const _taskFlowIconSize = 112.0;
const _taskFlowIconRadius = 28.0;

class AuthHeader extends StatelessWidget {
  final String subtitle;

  const AuthHeader({
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: _taskFlowIconSize,
          height: _taskFlowIconSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_taskFlowIconRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(45),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            _taskFlowIconPath,
            fit: BoxFit.cover,
            semanticLabel: 'TaskFlow',
          ),
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
