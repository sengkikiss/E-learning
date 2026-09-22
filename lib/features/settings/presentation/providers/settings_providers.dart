import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Ref _ref;

  ThemeModeNotifier(this._ref) : super(ThemeMode.light) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    final saved = _ref.read(settingsLocalDataSourceProvider).getThemeMode();
    if (saved == 'dark') {
      state = ThemeMode.dark;
    } else if (saved == 'light') {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.system;
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    _ref.read(settingsLocalDataSourceProvider).saveThemeMode(mode.name);
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final Ref _ref;

  LocaleNotifier(this._ref) : super(const Locale('en')) {
    _loadLocale();
  }

  void _loadLocale() {
    final saved = _ref.read(settingsLocalDataSourceProvider).getLocale();
    if (saved != null && saved.isNotEmpty) {
      state = Locale(saved);
    }
  }

  void setLocale(String languageCode) {
    state = Locale(languageCode);
    _ref.read(settingsLocalDataSourceProvider).saveLocale(languageCode);
  }

  void toggleLocale() {
    if (state.languageCode == 'en') {
      setLocale('km');
    } else {
      setLocale('en');
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref);
});
