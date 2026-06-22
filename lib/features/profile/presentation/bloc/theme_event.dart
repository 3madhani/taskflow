import 'package:equatable/equatable.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class LoadTheme extends ThemeEvent {
  const LoadTheme();

  @override
  List<Object?> get props => [];
}

class ToggleTheme extends ThemeEvent {
  const ToggleTheme();

  @override
  List<Object?> get props => [];
}
