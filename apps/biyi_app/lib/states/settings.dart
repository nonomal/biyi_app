import 'package:biyi_app/models/settings.dart';
import 'package:biyi_app/utilities/language_util.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';

class SettingsState with ChangeNotifier {
  final Settings _settings = Settings();

  Settings get settings => _settings;

  ThemeMode get themeMode => _settings.themeMode;

  set themeMode(ThemeMode themeMode) {
    _settings.themeMode = themeMode;
    notifyListeners();
  }

  Locale get locale => languageToLocale(_settings.displayLanguage ?? 'en');

  set locale(Locale locale) {
    _settings.displayLanguage = locale.toLanguageTag();
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
