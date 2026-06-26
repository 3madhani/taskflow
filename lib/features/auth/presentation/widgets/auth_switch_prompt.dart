import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'auth_form_mode.dart';

class AuthSwitchPrompt extends StatelessWidget {
  final AuthFormMode mode;
  final bool isEnabled;
  final VoidCallback onPressed;

  const AuthSwitchPrompt({
    required this.mode,
    required this.isEnabled,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: isEnabled ? onPressed : null,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Text(
            mode.switchPrompt,
            key: ValueKey(mode.switchPrompt),
            style: AppTextStyles.bodyM(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
