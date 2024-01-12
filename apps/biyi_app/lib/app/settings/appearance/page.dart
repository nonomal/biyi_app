import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
                'theme_mode.${ThemeMode.light.name}'.tr(),
              ),
            ),
            PreferenceListRadioItem(
              value: ThemeMode.dark,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(
                'theme_mode.${ThemeMode.dark.name}'.tr(),
              ),
            ),
            PreferenceListRadioItem(
              value: ThemeMode.system,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(
                'theme_mode.${ThemeMode.system.name}'.tr(),
              ),
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t('pref_section_title_tray_icon')),
          children: [
            PreferenceListSwitchItem(
              title: Text(t('pref_item_title_show_tray_icon')),
              value: _configuration.showTrayIcon,
              onChanged: (newValue) {
                _configuration.showTrayIcon = newValue;
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t('pref_section_title_max_window_height')),
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

  String t(String key, {List<String> args = const []}) {
    return 'page_setting_interface.$key'.tr(args: args);
  }
}
