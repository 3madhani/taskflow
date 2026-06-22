import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_colors.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/storage/hive_storage.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/presentation/bloc/theme_bloc.dart';
import 'features/profile/presentation/bloc/theme_state.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';
import 'features/tasks/presentation/bloc/tasks_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouterWrapper _routerWrapper;

  @override
  void initState() {
    super.initState();
    _routerWrapper = GoRouterWrapper(getIt<HiveStorage>());
  }

  @override
  void dispose() {
    _routerWrapper.dispose();
    super.dispose();
  }

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
            theme: _lightTheme(),
            darkTheme: _darkTheme(),
            routerConfig: _routerWrapper.router,
          );
        },
      ),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.surfaceLight,
      ).copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.surfaceLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: Color(0x1E3D5AFE),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        surface: AppColors.surfaceDark,
      ).copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.surfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: Color(0x283D5AFE),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}

class GoRouterWrapper {
  late final GoRouter router;

  GoRouterWrapper(HiveStorage hiveStorage) {
    router = createRouter(hiveStorage);
  }

  void dispose() {}
}
