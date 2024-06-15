import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/utilities/language_util.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:influxui/influxui.dart';
import 'package:preference_list/preference_list.dart';
import 'package:provider/provider.dart';

class LanguageSettingPage extends StatefulWidget {
  const LanguageSettingPage({super.key});

  @override
  State<LanguageSettingPage> createState() => _LanguageSettingPageState();
}

class _LanguageSettingPageState extends State<LanguageSettingPage> {
  Widget _buildBody(BuildContext context) {
    final settings = context.watch<SettingsState>();
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        PreferenceListSection(
          children: [
            for (var appLanguage in kAppLanguages)
              PreferenceListTile(
                title: LanguageLabel(appLanguage),
                additionalInfo: languageToLocale(appLanguage) == settings.locale
                    ? Icon(
                        FluentIcons.checkmark_circle_16_filled,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () async {
                  final newLocale = languageToLocale(appLanguage);
                  context.read<SettingsState>().locale = newLocale;
                  await context.setLocale(newLocale);
                  await WidgetsBinding.instance.performReassemble();
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
      appBar: CustomizedAppBar(
        title: Text(LocaleKeys.app_settings_language_title.tr()),
      ),
      body: _buildBody(context),
    );
  }
}
