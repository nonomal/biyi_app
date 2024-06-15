import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
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
  void _handleThemeModeChanged(newValue) {
    context.read<Settings>().update(themeMode: newValue);
  }

  void _handleTrayIconEnabledChanged(newValue) {
    context.read<Settings>().update(trayIconEnabled: newValue);
  }

  void _handleMaxWindowHeightChanged(newValue) {
    context.read<Settings>().update(maxWindowHeight: newValue);
  }

  Widget _buildBody(BuildContext context) {
    final settings = context.watch<Settings>();
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        PreferenceListSection(
          children: [
            for (var themeMode in [
              ThemeMode.light,
              ThemeMode.dark,
              ThemeMode.system,
            ])
              PreferenceListTile(
                title: Text(
                  themeMode == ThemeMode.light
                      ? LocaleKeys.theme_mode_light.tr()
                      : themeMode == ThemeMode.dark
                          ? LocaleKeys.theme_mode_dark.tr()
                          : LocaleKeys.theme_mode_system.tr(),
                ),
                additionalInfo: settings.themeMode == themeMode
                    ? Icon(
                        FluentIcons.checkmark_circle_16_filled,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => _handleThemeModeChanged(themeMode),
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
                value: settings.trayIconEnabled,
                onChanged: _handleTrayIconEnabledChanged,
              ),
              onTap: () =>
                  _handleTrayIconEnabledChanged(!settings.trayIconEnabled),
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
                additionalInfo: settings.maxWindowHeight == option
                    ? Icon(
                        FluentIcons.checkmark_circle_16_filled,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => _handleMaxWindowHeightChanged(option),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizedAppBar(
        title: Text(LocaleKeys.app_settings_appearance_title.tr()),
      ),
      body: _buildBody(context),
    );
  }
}
