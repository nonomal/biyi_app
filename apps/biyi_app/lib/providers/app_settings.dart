import 'package:influxui/influxui.dart';

class AppSettings with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  Locale _locale = const Locale('en');

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
}
