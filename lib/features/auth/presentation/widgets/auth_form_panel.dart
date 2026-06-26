import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import 'auth_animated_form_section.dart';
import 'auth_form_mode.dart';
import 'auth_mode_selector.dart';
import 'auth_switch_prompt.dart';

class AuthFormPanel extends StatefulWidget {
  final AuthFormMode mode;
  final bool isLoading;
  final ValueChanged<AuthFormMode> onModeChanged;

  const AuthFormPanel({
    required this.mode,
    required this.isLoading,
    required this.onModeChanged,
    super.key,
  });

  @override
  State<AuthFormPanel> createState() => _AuthFormPanelState();
}

class _AuthFormPanelState extends State<AuthFormPanel> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool get _isRegister => widget.mode.isRegister;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.borderDark
        : AppColors.borderLight;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(
              theme.brightness == Brightness.dark ? 55 : 18,
            ),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthModeSelector(
                  mode: widget.mode,
                  isEnabled: !widget.isLoading,
                  onChanged: _changeMode,
                ),
                const SizedBox(height: AppSpacing.xl),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.08),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    key: ValueKey(widget.mode.panelTitle),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.mode.panelTitle,
                        style: AppTextStyles.headingM(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        widget.mode.panelSubtitle,
                        style: AppTextStyles.bodyM(
                          color: theme.colorScheme.onSurface.withAlpha(145),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AuthAnimatedFormSection(
                  visible: _isRegister,
                  child: AppTextField(
                    label: AppStrings.name,
                    hintText: AppStrings.nameHint,
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    validator: _validateName,
                  ),
                ),
                AppTextField(
                  label: AppStrings.email,
                  hintText: AppStrings.emailHint,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: AppStrings.password,
                  hintText: AppStrings.passwordHint,
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction:
                      _isRegister ? TextInputAction.next : TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (!_isRegister) {
                      _onSubmit();
                    }
                  },
                  validator: _validatePassword,
                ),
                const SizedBox(height: AppSpacing.lg),
                AuthAnimatedFormSection(
                  visible: _isRegister,
                  child: AppTextField(
                    label: AppStrings.confirmPassword,
                    hintText: AppStrings.confirmPasswordHint,
                    controller: _confirmPasswordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onSubmit(),
                    validator: _validateConfirmPassword,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: AppButton(
                    key: ValueKey(widget.mode.actionLabel),
                    label: widget.mode.actionLabel,
                    isLoading: widget.isLoading,
                    onPressed: widget.isLoading ? null : _onSubmit,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AuthSwitchPrompt(
                  mode: widget.mode,
                  isEnabled: !widget.isLoading,
                  onPressed: () => _changeMode(widget.mode.opposite),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AuthFormPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) {
      _formKey.currentState?.reset();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changeMode(AuthFormMode mode) {
    if (widget.isLoading) {
      return;
    }
    widget.onModeChanged(mode);
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final authBloc = context.read<AuthBloc>();
    if (_isRegister) {
      authBloc.add(
        RegisterRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
      return;
    }

    authBloc.add(
      LoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  String? _validateConfirmPassword(String? value) {
    if (!_isRegister) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value != _passwordController.text) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(value.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  String? _validateName(String? value) {
    if (!_isRegister) {
      return null;
    }
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.trim().length < 2) {
      return AppStrings.nameTooShort;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }
}
