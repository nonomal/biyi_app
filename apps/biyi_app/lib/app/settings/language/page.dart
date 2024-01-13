import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/providers/providers.dart';
import 'package:biyi_app/utilities/language_util.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSettingPage extends StatefulWidget {
  const LanguageSettingPage({super.key});

  @override
  State<LanguageSettingPage> createState() => _LanguageSettingPageState();
}

class _LanguageSettingPageState extends State<LanguageSettingPage> {
  Widget _buildBody(BuildContext context) {
    final AppSettings appSettings = context.watch<AppSettings>();

    return PreferenceList(
      children: [
        PreferenceListSection(
          children: [
            for (var appLanguage in kAppLanguages)
              PreferenceListRadioItem<Locale>(
                title: LanguageLabel(appLanguage),
                accessoryView: Container(),
                value: languageToLocale(appLanguage),
                groupValue: appSettings.locale,
                onChanged: (newGroupValue) async {
                  context.read<AppSettings>().locale = newGroupValue;
                  await context.setLocale(newGroupValue);
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
      appBar: CustomAppBar(
        title: Text(LocaleKeys.app_settings_language_title.tr()),
      ),
      body: _buildBody(context),
    );
  }
}
