import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Events
abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class SetThemeEvent extends ThemeEvent {
  final bool isDarkMode;
  SetThemeEvent({required this.isDarkMode});
}

class LoadThemeEvent extends ThemeEvent {}

// State
abstract class ThemeState {
  final bool isDarkMode;
  ThemeState({required this.isDarkMode});
}

class ThemeInitialState extends ThemeState {
  ThemeInitialState({required bool isDarkMode}) : super(isDarkMode: isDarkMode);
}

class ThemeChangedState extends ThemeState {
  ThemeChangedState({required bool isDarkMode}) : super(isDarkMode: isDarkMode);
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'isDarkMode';
  late Box _themeBox;

  ThemeBloc() : super(ThemeInitialState(isDarkMode: false)) {
    _themeBox = Hive.box('themeBox');
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final isDarkMode = _themeBox.get(_themeKey, defaultValue: false) as bool;
      emit(ThemeChangedState(isDarkMode: isDarkMode));
    } catch (e) {
      print('Error loading theme: $e');
      emit(ThemeChangedState(isDarkMode: false));
    }
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final isDarkMode = !state.isDarkMode;
    await _saveTheme(isDarkMode);
    emit(ThemeChangedState(isDarkMode: isDarkMode));
  }

  Future<void> _onSetTheme(
    SetThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await _saveTheme(event.isDarkMode);
    emit(ThemeChangedState(isDarkMode: event.isDarkMode));
  }

  Future<void> _saveTheme(bool isDarkMode) async {
    try {
      await _themeBox.put(_themeKey, isDarkMode);
    } catch (e) {
      log('Error saving theme: $e');
    }
  }
}
