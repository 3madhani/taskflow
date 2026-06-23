import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../storage/hive_constants.dart';
import '../storage/hive_storage.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/projects/domain/entities/project_entity.dart';
import '../../features/projects/presentation/screens/projects_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/shell/presentation/screens/shell_screen.dart';
import '../../features/tasks/presentation/screens/project_detail_screen.dart';

GoRouter createRouter(HiveStorage hiveStorage) {
  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final token = hiveStorage.read<String>(HiveBoxes.auth, HiveKeys.token);
      final location = state.uri.toString();

      final isAuthRoute = location == '/login' || location == '/register';

      if (token == null && !isAuthRoute) {
        return '/login';
      }
      if (token != null && isAuthRoute) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _slideFromBottomPage(
          state,
          const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _slideFromBottomPage(
          state,
          const RegisterScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => ShellScreen(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) =>
                    _fadeTransitionPage(state, const ProjectsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) =>
                    _fadeTransitionPage(state, const ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/projects/:projectId',
        pageBuilder: (context, state) {
          final projectId = int.tryParse(
                state.pathParameters['projectId'] ?? '',
              ) ??
              0;
          final extraMap = state.extra as Map<String, dynamic>?;
          final project = extraMap != null
              ? ProjectEntity(
                  id: extraMap['id'] as int,
                  title: extraMap['title'] as String,
                  description: extraMap['description'] as String,
                  status: ProjectStatus.values[extraMap['statusIndex'] as int],
                )
              : null;
          return _slideFromRightPage(
            state,
            ProjectDetailScreen(projectId: projectId, project: project),
          );
        },
      ),
    ],
  );
}

CustomTransitionPage _slideFromRightPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (_, animation, __, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}

CustomTransitionPage _slideFromBottomPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (_, animation, __, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}

CustomTransitionPage _fadeTransitionPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
