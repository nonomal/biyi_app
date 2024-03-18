import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:influxui/influxui.dart';

class AboutSettingPage extends StatelessWidget {
  const AboutSettingPage({super.key});

  Widget _buildBody(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: LocaleKeys.app_settings_about_title.tr(),
      child: _buildBody(context),
    );
  }
}
