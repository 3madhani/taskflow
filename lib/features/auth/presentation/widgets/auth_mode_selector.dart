import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'auth_form_mode.dart';

class AuthModeSelector extends StatelessWidget {
  final AuthFormMode mode;
  final bool isEnabled;
  final ValueChanged<AuthFormMode> onChanged;

  const AuthModeSelector({
    required this.mode,
    required this.isEnabled,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.borderDark
        : AppColors.borderLight;

    return SizedBox(
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: mode.isRegister
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(45),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                _ModeButton(
                  label: 'Login',
                  isActive: mode == AuthFormMode.login,
                  isEnabled: isEnabled,
                  onPressed: () => onChanged(AuthFormMode.login),
                ),
                _ModeButton(
                  label: 'Register',
                  isActive: mode == AuthFormMode.register,
                  isEnabled: isEnabled,
                  onPressed: () => onChanged(AuthFormMode.register),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isEnabled;
  final VoidCallback onPressed;

  const _ModeButton({
    required this.label,
    required this.isActive,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: TextButton(
        onPressed: isEnabled ? onPressed : null,
        style: TextButton.styleFrom(
          foregroundColor: isActive
              ? Colors.white
              : theme.colorScheme.onSurface.withAlpha(170),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyM(
            color: isActive
                ? Colors.white
                : theme.colorScheme.onSurface.withAlpha(170),
          ),
        ),
      ),
    );
  }
}
