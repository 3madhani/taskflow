import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/presentation/bloc/theme_bloc.dart';
import 'features/profile/presentation/bloc/theme_state.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';
import 'features/tasks/presentation/bloc/tasks_bloc.dart';

import 'core/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class GoRouterWrapper {
  late final GoRouter router;

  GoRouterWrapper() {
    router = createRouter();
  }

  void dispose() {}
}

class _AppState extends State<App> {
  late final GoRouterWrapper _routerWrapper;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (_) => getIt<ThemeBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>(),
        ),
        BlocProvider<ProjectsBloc>(
          create: (_) => getIt<ProjectsBloc>(),
        ),
        BlocProvider<TasksBloc>(
          create: (_) => getIt<TasksBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'TaskFlow',
            debugShowCheckedModeBanner: false,
            themeMode: themeState.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: _routerWrapper.router,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _routerWrapper.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _routerWrapper = GoRouterWrapper();
  }
}
