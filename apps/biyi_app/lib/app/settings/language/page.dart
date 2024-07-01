import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/utils/language_util.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:harmonic/noprefix/harmonic.dart';
import 'package:provider/provider.dart';

class LanguageSettingPage extends StatefulWidget {
  const LanguageSettingPage({super.key});

  @override
  State<LanguageSettingPage> createState() => _LanguageSettingPageState();
}

class _LanguageSettingPageState extends State<LanguageSettingPage> {
  void _handleUpdateSettings({
    String? displayLanguage,
  }) {
    final settings = context.read<Settings>();
    if (displayLanguage != null) {
      settings.locale = languageToLocale(displayLanguage);
    }
  }

  Widget _buildBody(BuildContext context) {
    final settings = context.watch<Settings>();
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ListSection(
          children: [
            for (var appLanguage in kAppLanguages)
              ListTile(
                title: Text(getLanguageName(appLanguage)),
                additionalInfo: languageToLocale(appLanguage) == settings.locale
                    ? const Icon(
                        FluentIcons.checkmark_circle_16_filled,
                      )
                    : null,
                onTap: () async {
                  _handleUpdateSettings(displayLanguage: appLanguage);
                  await context.setLocale(languageToLocale(appLanguage));
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
