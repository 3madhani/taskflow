import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/storage/hive_constants.dart';
import 'features/auth/data/models/user_model.dart';
import 'features/profile/presentation/bloc/theme_bloc.dart';
import 'features/profile/presentation/bloc/theme_event.dart';
import 'features/projects/data/models/project_model.dart';
import 'features/tasks/data/models/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ProjectModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());

  await Future.wait([
    Hive.openBox(HiveBoxes.auth),
    Hive.openBox(HiveBoxes.projects),
    Hive.openBox(HiveBoxes.tasks),
    Hive.openBox(HiveBoxes.settings),
  ]);

  configureDependencies();

  getIt<ThemeBloc>().add(const LoadTheme());

  runApp(const App());
}
