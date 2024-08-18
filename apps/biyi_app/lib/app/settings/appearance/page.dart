import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:biyi_app/widgets/list_section.dart';
import 'package:biyi_app/widgets/list_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:provider/provider.dart';
import 'package:reflect_ui/reflect_ui.dart';

const List<double> _kMaxWindowHeightOptions = [700, 800, 900, 1000];

class AppearanceSettingPage extends StatefulWidget {
  const AppearanceSettingPage({super.key});

  @override
  State<AppearanceSettingPage> createState() => _AppearanceSettingPageState();
}

class _AppearanceSettingPageState extends State<AppearanceSettingPage> {
  void _handleUpdateSettings({
    ThemeMode? themeMode,
    bool? trayIconEnabled,
    double? maxWindowHeight,
  }) {
    final settings = context.read<Settings>();
    settings.update(
      themeMode: themeMode,
      trayIconEnabled: trayIconEnabled,
      maxWindowHeight: maxWindowHeight,
    );
  }

  Widget _buildBody(BuildContext context) {
    final settings = context.watch<Settings>();
    return ListView(
      children: [
        ListSection(
          children: [
            for (var themeMode in [
              ThemeMode.light,
              ThemeMode.dark,
              ThemeMode.system,
            ])
              ListTile(
                title: Text(
                  themeMode == ThemeMode.light
                      ? LocaleKeys.theme_mode_light.tr()
                      : themeMode == ThemeMode.dark
                          ? LocaleKeys.theme_mode_dark.tr()
                          : LocaleKeys.theme_mode_system.tr(),
                ),
                additionalInfo: settings.themeMode == themeMode
                    ? const Icon(
                        FluentIcons.checkmark_circle_16_filled,
                      )
                    : null,
                onTap: () => _handleUpdateSettings(themeMode: themeMode),
              ),
          ],
        ),
        ListSection(
          header: Text(
            LocaleKeys.app_settings_appearance_tray_icon_title.tr(),
          ),
          children: [
            ListTile(
              title: Text(
                LocaleKeys.app_settings_appearance_tray_icon_show_title.tr(),
              ),
              additionalInfo: Switch(
                value: settings.trayIconEnabled,
                onChanged: (newValue) =>
                    _handleUpdateSettings(trayIconEnabled: newValue),
              ),
              onTap: () => _handleUpdateSettings(
                trayIconEnabled: !settings.trayIconEnabled,
              ),
            ),
          ],
        ),
        ListSection(
          header: Text(
            LocaleKeys.app_settings_appearance_max_window_height_title.tr(),
          ),
          children: [
            for (var option in _kMaxWindowHeightOptions)
              ListTile(
                title: Text('${option.toInt()}'),
                additionalInfo: settings.maxWindowHeight == option
                    ? const Icon(
                        FluentIcons.checkmark_circle_16_filled,
                      )
                    : null,
                onTap: () => _handleUpdateSettings(maxWindowHeight: option),
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
