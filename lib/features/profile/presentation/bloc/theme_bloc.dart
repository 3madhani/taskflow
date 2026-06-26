import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/hive_constants.dart';
import '../../../../core/storage/hive_storage.dart';
import 'theme_event.dart';
import 'theme_state.dart';

@singleton
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final HiveStorage _hiveStorage;

  ThemeBloc(this._hiveStorage) : super(const ThemeState()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final savedMode =
        _hiveStorage.read<String>(HiveBoxes.settings, HiveKeys.themeMode);
    final themeMode = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> _onToggleTheme(
      ToggleTheme event, Emitter<ThemeState> emit) async {
    final newMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _hiveStorage.write<String>(
      HiveBoxes.settings,
      HiveKeys.themeMode,
      newMode == ThemeMode.dark ? 'dark' : 'light',
    );
    emit(state.copyWith(themeMode: newMode));
  }
}
