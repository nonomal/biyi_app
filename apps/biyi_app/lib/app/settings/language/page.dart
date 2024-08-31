import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/utils/language_util.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:reflect_ui/reflect_ui.dart';

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
      children: [
        ListSection(
          hasLeading: false,
          children: [
            for (var appLanguage in kAppLanguages)
              RadioListTile<String>(
                value: appLanguage,
                groupValue: settings.locale.languageCode,
                onChanged: (_) async {
                  _handleUpdateSettings(displayLanguage: appLanguage);
                  await context.setLocale(languageToLocale(appLanguage));
                  await WidgetsBinding.instance.performReassemble();
                },
                useCheckmarkStyle: true,
                title: Text(getLanguageName(appLanguage)),
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
