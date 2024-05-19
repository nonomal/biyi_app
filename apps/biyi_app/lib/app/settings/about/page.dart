import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:influxui/influxui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:preference_list/preference_list.dart';

class AboutSettingPage extends StatefulWidget {
  const AboutSettingPage({super.key});

  @override
  State<AboutSettingPage> createState() => _AboutSettingPageState();
}

class _AboutSettingPageState extends State<AboutSettingPage> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        PreferenceListSection(
          children: [
            PreferenceListTile(
              title: Text(
                LocaleKeys.app_settings_about_package_info_version.tr(),
              ),
              additionalInfo: Text(_packageInfo?.version ?? 'Unknown'),
            ),
            PreferenceListTile(
              title: Text(
                LocaleKeys.app_settings_about_package_info_build_number.tr(),
              ),
              additionalInfo: Text(_packageInfo?.buildNumber ?? 'Unknown'),
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
        title: Text(
          LocaleKeys.app_settings_about_title.tr(),
        ),
      ),
      body: _buildBody(context),
    );
  }
}
