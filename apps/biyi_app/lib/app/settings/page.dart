import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/utils/utils.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reflect_ui/reflect_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 20,
              ),
              child: Text(
                LocaleKeys.app_settings_text_version.tr(
                  args: [
                    sharedEnv.appVersion,
                    '${sharedEnv.appBuildNumber}',
                  ],
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomizedAppBar(
        title: Text(
          LocaleKeys.app_settings_title.tr(),
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
