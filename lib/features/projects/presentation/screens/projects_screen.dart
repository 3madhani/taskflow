import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/responsive/screen_utils.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';
import '../widgets/project_card.dart';
import '../widgets/create_project_bottom_sheet.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectsBloc>().add(const LoadProjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const CreateProjectBottomSheet(),
          );
          if (result != null && mounted) {
            context.read<ProjectsBloc>().add(
                  CreateProject(
                    name: result['name'] as String,
                    description: result['description'] as String,
                    status: result['status'] as String,
                    priority: result['priority'] as String,
                  ),
                );
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
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
                    ProjectsInitial() => const SliverToBoxAdapter(child: SizedBox.shrink()),
                    ProjectsLoading() => const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ProjectsError(:final message) => SliverFillRemaining(
                        child: AppErrorWidget(
                          message: message,
                          onRetry: () =>
                              context.read<ProjectsBloc>().add(const LoadProjects()),
                        ),
                      ),
                    ProjectsLoaded(:final projects) when projects.isEmpty =>
                      SliverFillRemaining(
                        child: EmptyStateWidget(
                          icon: Icons.folder_open_rounded,
                          title: AppStrings.noProjectsTitle,
                          subtitle: AppStrings.noProjectsSubtitle,
                          onRetry: () =>
                              context.read<ProjectsBloc>().add(const RefreshProjects()),
                          retryLabel: 'Refresh',
                        ),
                      ),
                    ProjectsLoaded(:final projects) => _buildProjectList(context, projects),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
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
          return Dismissible(
            key: Key(project.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.delete_rounded, color: Colors.white),
            ),
            onDismissed: (_) {
              context.read<ProjectsBloc>().add(DeleteProject(project.id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Project "${project.name}" deleted')),
              );
            },
            child: ProjectCard(project: project),
          );
        },
      );
    }
    return SliverList.separated(
      itemCount: projectsList.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, i) {
        final project = projectsList[i];
        return Dismissible(
          key: Key(project.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete_rounded, color: Colors.white),
          ),
          onDismissed: (_) {
            context.read<ProjectsBloc>().add(DeleteProject(project.id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Project "${project.name}" deleted')),
            );
          },
          child: ProjectCard(project: project),
        );
      },
    );
  }
}
