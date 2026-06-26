import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class RegisterForm extends StatefulWidget {
  final bool isLoading;

  const RegisterForm({required this.isLoading, super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            RegisterRequested(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.borderDark
                : AppColors.borderLight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(AppStrings.register, style: AppTextStyles.headingM()),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: AppStrings.name,
                hintText: AppStrings.nameHint,
                controller: _nameController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) return AppStrings.fieldRequired;
                  if (value.trim().length < 2) return AppStrings.nameTooShort;
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: AppStrings.email,
                hintText: AppStrings.emailHint,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) return AppStrings.fieldRequired;
                  final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!regex.hasMatch(value)) return AppStrings.invalidEmail;
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: AppStrings.password,
                hintText: AppStrings.passwordHint,
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) return AppStrings.fieldRequired;
                  if (value.length < 6) return AppStrings.passwordTooShort;
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: AppStrings.confirmPassword,
                hintText: AppStrings.confirmPasswordHint,
                controller: _confirmPasswordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onSubmit(),
                validator: (value) {
                  if (value == null || value.isEmpty) return AppStrings.fieldRequired;
                  if (value != _passwordController.text) return AppStrings.passwordsDoNotMatch;
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: AppStrings.register,
                isLoading: widget.isLoading,
                onPressed: widget.isLoading ? null : _onSubmit,
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: TextButton(
                  onPressed: widget.isLoading ? null : () => context.pop(),
                  child: Text(
                    AppStrings.alreadyHaveAccount,
                    style: AppTextStyles.bodyM(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
