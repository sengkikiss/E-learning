import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/local_storage.dart';

abstract class SettingsLocalDataSource {
  Future<void> saveThemeMode(String mode);
  String? getThemeMode();
  Future<void> saveLocale(String languageCode);
  String? getLocale();
  Future<void> setOnboardingCompleted();
  bool isOnboardingCompleted();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final LocalStorage _localStorage;

  SettingsLocalDataSourceImpl(this._localStorage);

  @override
  Future<void> saveThemeMode(String mode) => _localStorage.setString(StorageKeys.themeMode, mode);

  @override
  String? getThemeMode() => _localStorage.getString(StorageKeys.themeMode);

  @override
  Future<void> saveLocale(String languageCode) => _localStorage.setString(StorageKeys.locale, languageCode);

  @override
  String? getLocale() => _localStorage.getString(StorageKeys.locale);

  @override
  Future<void> setOnboardingCompleted() => _localStorage.setBool(StorageKeys.isOnboardingCompleted, true);

  @override
  bool isOnboardingCompleted() => _localStorage.getBool(StorageKeys.isOnboardingCompleted) ?? false;
}
