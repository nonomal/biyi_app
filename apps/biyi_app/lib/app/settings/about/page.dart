import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:reflect_ui/reflect_ui.dart';

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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomizedAppBar(
      title: Text(
        LocaleKeys.app_settings_about_title.tr(),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        ListSection(
          hasLeading: false,
          children: [
            ListTile(
              title: Text(
                LocaleKeys.app_settings_about_package_info_version.tr(),
              ),
              additionalInfo: Text(_packageInfo?.version ?? 'Unknown'),
            ),
            ListTile(
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
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }
}
