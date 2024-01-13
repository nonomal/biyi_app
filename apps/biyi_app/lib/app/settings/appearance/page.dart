import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/providers/providers.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const List<double> _kMaxWindowHeightOptions = [700, 800, 900, 1000];

class AppearanceSettingPage extends StatefulWidget {
  const AppearanceSettingPage({super.key});

  @override
  State<AppearanceSettingPage> createState() => _AppearanceSettingPageState();
}

class _AppearanceSettingPageState extends State<AppearanceSettingPage> {
  Configuration get _configuration => localDb.configuration;

  @override
  void initState() {
    localDb.preferences.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.preferences.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  void _handleThemeModeChanged(newValue) {
    _configuration.themeMode = newValue;
    context.read<AppSettings>().themeMode = newValue;
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        PreferenceListSection(
          children: [
            PreferenceListRadioItem(
              value: ThemeMode.light,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(
                LocaleKeys.theme_mode_light.tr(),
              ),
            ),
            PreferenceListRadioItem(
              value: ThemeMode.dark,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(
                LocaleKeys.theme_mode_dark.tr(),
              ),
            ),
            PreferenceListRadioItem(
              value: ThemeMode.system,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(
                LocaleKeys.theme_mode_system.tr(),
              ),
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(
            LocaleKeys.app_settings_appearance_tray_icon_title.tr(),
          ),
          children: [
            PreferenceListSwitchItem(
              title: Text(
                LocaleKeys.app_settings_appearance_tray_icon_show_title.tr(),
              ),
              value: _configuration.showTrayIcon,
              onChanged: (newValue) {
                _configuration.showTrayIcon = newValue;
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(
            LocaleKeys.app_settings_appearance_max_window_height_title.tr(),
          ),
          children: [
            for (var option in _kMaxWindowHeightOptions)
              PreferenceListRadioItem<double>(
                title: Text('${option.toInt()}'),
                value: option,
                groupValue: _configuration.maxWindowHeight,
                onChanged: (newValue) {
                  _configuration.maxWindowHeight = newValue;
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          LocaleKeys.app_settings_appearance_title.tr(),
        ),
      ),
      body: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
