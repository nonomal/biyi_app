import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/providers/providers.dart';
import 'package:biyi_app/services/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:influxui/influxui.dart';
import 'package:preference_list/preference_list.dart';
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
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        PreferenceListSection(
          children: [
            PreferenceListTile(
              title: Text(
                LocaleKeys.theme_mode_light.tr(),
              ),
              additionalInfo: _configuration.themeMode == ThemeMode.light
                  ? Icon(
                      FluentIcons.checkmark_circle_16_filled,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () => _handleThemeModeChanged(ThemeMode.light),
            ),
            PreferenceListTile(
              title: Text(
                LocaleKeys.theme_mode_dark.tr(),
              ),
              additionalInfo: _configuration.themeMode == ThemeMode.dark
                  ? Icon(
                      FluentIcons.checkmark_circle_16_filled,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () => _handleThemeModeChanged(ThemeMode.dark),
            ),
            PreferenceListTile(
              title: Text(
                LocaleKeys.theme_mode_system.tr(),
              ),
              additionalInfo: _configuration.themeMode == ThemeMode.system
                  ? Icon(
                      FluentIcons.checkmark_circle_16_filled,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () => _handleThemeModeChanged(ThemeMode.system),
            ),
          ],
        ),
        PreferenceListSection(
          header: Text(
            LocaleKeys.app_settings_appearance_tray_icon_title.tr(),
          ),
          children: [
            PreferenceListTile(
              title: Text(
                LocaleKeys.app_settings_appearance_tray_icon_show_title.tr(),
              ),
              additionalInfo: Switch(
                value: _configuration.showTrayIcon,
                onChanged: (value) {
                  _configuration.showTrayIcon = value;
                },
              ),
              onTap: () {
                _configuration.showTrayIcon = !_configuration.showTrayIcon;
              },
            ),
          ],
        ),
        PreferenceListSection(
          header: Text(
            LocaleKeys.app_settings_appearance_max_window_height_title.tr(),
          ),
          children: [
            for (var option in _kMaxWindowHeightOptions)
              PreferenceListTile(
                title: Text('${option.toInt()}'),
                additionalInfo: _configuration.maxWindowHeight == option
                    ? Icon(
                        FluentIcons.checkmark_circle_16_filled,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  _configuration.maxWindowHeight = option;
                },
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.app_settings_appearance_title.tr()),
      ),
      body: _buildBody(context),
    );
  }
}
