import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:reflect_ui/reflect_ui.dart';

class AdvancedSettingPage extends StatefulWidget {
  const AdvancedSettingPage({super.key});

  @override
  State<AdvancedSettingPage> createState() => _AdvancedSettingPageState();
}

class _AdvancedSettingPageState extends State<AdvancedSettingPage> {
  bool _launchAtLoginEnabled = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _launchAtLoginEnabled = await launchAtStartup.isEnabled();
    setState(() {});
  }

  Future<void> _handleLaunchAtLoginChanged(bool value) async {
    if (value) {
      await launchAtStartup.enable();
    } else {
      await launchAtStartup.disable();
    }
    _launchAtLoginEnabled = value;
    setState(() {});
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        ListSection(
          hasLeading: false,
          children: [
            SwitchListTile(
              value: _launchAtLoginEnabled,
              onChanged: _handleLaunchAtLoginChanged,
              title: Text(
                LocaleKeys.app_settings_advanced_launch_at_login_title.tr(),
              ),
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
        title: Text(LocaleKeys.app_settings_advanced_title.tr()),
      ),
      body: _buildBody(context),
    );
  }
}
