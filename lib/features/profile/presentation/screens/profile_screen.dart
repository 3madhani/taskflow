import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/responsive/screen_utils.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/theme_section.dart';

import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                title:
                    Text(AppStrings.profile, style: AppTextStyles.headingM()),
                titlePadding: EdgeInsets.only(
                  left: context.horizontalPadding,
                  bottom: AppSpacing.lg,
                ),
                collapseMode: CollapseMode.pin,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: context.horizontalPadding,
                vertical: AppSpacing.lg,
              ),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    String? name;
                    String? email;
                    if (authState is AuthAuthenticated) {
                      name = authState.user.name;
                      email = authState.user.email;
                    } else {
                      final supabaseUser = Supabase.instance.client.auth.currentUser;
                      name = supabaseUser?.userMetadata?['name'] as String?;
                      email = supabaseUser?.email;
                    }
                    return Column(
                      children: [
                        ProfileHeader(name: name, email: email),
                        const SizedBox(height: AppSpacing.xl),
                        const ThemeSection(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildLogoutButton(context),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout_rounded, color: AppColors.error),
        label: Text(
          AppStrings.logout,
          style: AppTextStyles.bodyL(color: AppColors.error),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          side: const BorderSide(color: AppColors.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppStrings.logoutConfirmTitle,
            style: AppTextStyles.headingM()),
        content: Text(
          AppStrings.logoutConfirmMessage,
          style: AppTextStyles.bodyM(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            child: const Text(
              AppStrings.logout,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
