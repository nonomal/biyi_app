import 'dart:io';

import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/router_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    hide NavigationRail, NavigationRailDestination;
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:rise_ui/rise_ui.dart';

class _NavigationRailLeading extends StatelessWidget {
  const _NavigationRailLeading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 8,
      ),
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 2,
        bottom: 2,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: ExtendedColors.gray.shade600,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class SettingsLayout extends StatefulWidget {
  const SettingsLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  String? _selectedDestination = PageId.generalSetting;

  Future<void> _handleDestinationSelected(String value) async {
    setState(() {
      _selectedDestination = value;
    });
    context.go(value);
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: !kIsWeb && Platform.isMacOS ? 26 : 6,
      ),
      width: 200,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            NavigationRail(
              leading: _NavigationRailLeading(
                label: LocaleKeys.app_settings__layout_navgroup_client.tr(),
              ),
              destinations: [
                NavigationRailDestination(
                  value: PageId.generalSetting,
                  icon: FluentIcons.app_generic_20_regular,
                  label: LocaleKeys.app_settings_general_title.tr(),
                ),
                NavigationRailDestination(
                  value: PageId.appearanceSetting,
                  icon: FluentIcons.style_guide_20_regular,
                  label: LocaleKeys.app_settings_appearance_title.tr(),
                ),
                NavigationRailDestination(
                  value: PageId.keybindsSetting,
                  icon: FluentIcons.keyboard_20_regular,
                  label: LocaleKeys.app_settings_keybinds_title.tr(),
                ),
                NavigationRailDestination(
                  value: PageId.languageSetting,
                  icon: FluentIcons.local_language_20_regular,
                  label: LocaleKeys.app_settings_language_title.tr(),
                ),
                NavigationRailDestination(
                  value: PageId.advancedSetting,
                  icon: FluentIcons.settings_20_regular,
                  label: LocaleKeys.app_settings_advanced_title.tr(),
                ),
              ],
              selectedValue: _selectedDestination,
              onDestinationSelected: _handleDestinationSelected,
            ),
            NavigationRail(
              leading: _NavigationRailLeading(
                label:
                    LocaleKeys.app_settings__layout_navgroup_integrations.tr(),
              ),
              destinations: [
                NavigationRailDestination(
                  value: PageId.textTranslationsSetting,
                  icon: FluentIcons.translate_20_regular,
                  label: LocaleKeys.app_settings_text_translations_title.tr(),
                ),
                NavigationRailDestination(
                  value: PageId.textDetectionsSetting,
                  icon: FluentIcons.scan_20_regular,
                  label: LocaleKeys.app_settings_text_detections_title.tr(),
                ),
              ],
              selectedValue: _selectedDestination,
              onDestinationSelected: _handleDestinationSelected,
            ),
            NavigationRail(
              leading: _NavigationRailLeading(
                label: LocaleKeys.app_settings__layout_navgroup_resources.tr(),
              ),
              destinations: [
                NavigationRailDestination(
                  value: PageId.about,
                  icon: FluentIcons.developer_board_20_regular,
                  label: LocaleKeys.app_settings_about_title.tr(),
                ),
                NavigationRailDestination(
                  value: PageId.changelog,
                  icon: FluentIcons.note_20_regular,
                  label: LocaleKeys.app_settings_changelog_title.tr(),
                ),
              ],
              selectedValue: _selectedDestination,
              onDestinationSelected: _handleDestinationSelected,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = List<Widget>.generate(10, (int index) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: const Color.fromARGB(255, 255, 201, 197),
          height: 200,
        ),
      );
    });

    return Scaffold(
      body: AdaptiveLayout(
        primaryNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            Breakpoints.large: SlotLayout.from(
              key: const Key('primary-navigation-large'),
              builder: (_) => _buildSidebar(context),
            ),
          },
        ),
        body: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            Breakpoints.small: SlotLayout.from(
              key: const Key('body-small'),
              builder: (_) => ListView.builder(
                itemCount: children.length,
                itemBuilder: (BuildContext context, int index) =>
                    children[index],
              ),
            ),
            Breakpoints.smallAndUp: SlotLayout.from(
              key: const Key('body-medium-and-up'),
              builder: (_) => ColoredBox(
                color: Colors.white,
                child: widget.child,
              ),
            ),
          },
        ),
        internalAnimations: false,
      ),
    );
  }
}
