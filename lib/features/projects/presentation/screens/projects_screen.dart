import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/responsive/screen_utils.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';
import '../widgets/dismissible_project_card.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProjectsBloc>().add(const RefreshProjects());
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  AppStrings.projects,
                  style: AppTextStyles.headingM(),
                ),
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
              sliver: BlocBuilder<ProjectsBloc, ProjectsState>(
                builder: (context, state) {
                  return switch (state) {
                    ProjectsInitial() =>
                      const SliverToBoxAdapter(child: SizedBox.shrink()),
                    ProjectsLoading() => const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ProjectsError(:final message) => SliverFillRemaining(
                        child: AppErrorWidget(
                          message: message,
                          onRetry: () => context
                              .read<ProjectsBloc>()
                              .add(const LoadProjects()),
                        ),
                      ),
                    ProjectsLoaded(:final projects) when projects.isEmpty =>
                      SliverFillRemaining(
                        child: EmptyStateWidget(
                          icon: Icons.folder_open_rounded,
                          title: AppStrings.noProjectsTitle,
                          subtitle: AppStrings.noProjectsSubtitle,
                          onRetry: () => context
                              .read<ProjectsBloc>()
                              .add(const RefreshProjects()),
                          retryLabel: 'Refresh',
                        ),
                      ),
                    ProjectsLoaded(:final projects) =>
                      _buildProjectList(context, projects),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ProjectsBloc>().add(const LoadProjects());
  }

  Widget _buildProjectList(BuildContext context, projectsList) {
    final isTablet = context.isTablet;
    if (isTablet) {
      return SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.lg,
          crossAxisSpacing: AppSpacing.lg,
          childAspectRatio: 2.5,
        ),
        itemCount: projectsList.length,
        itemBuilder: (_, i) {
          final project = projectsList[i];
          return DismissibleProjectCard(project: project);
        },
      );
    }
    return SliverList.separated(
      itemCount: projectsList.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, i) {
        final project = projectsList[i];
        return DismissibleProjectCard(project: project);
      },
    );
  }
}
