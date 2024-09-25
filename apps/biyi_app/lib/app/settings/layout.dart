import 'dart:async';

import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:reflect_ui/reflect_ui.dart';
import 'package:uni_platform/uni_platform.dart';
import 'package:window_manager/window_manager.dart';

class SettingsLayout extends StatefulWidget {
  const SettingsLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> with WindowListener {
  String? _selectedDestination = PageId.settingsGeneral;

  @override
  void initState() {
    super.initState();
    UniPlatform.call<Future<void>>(
      desktop: () => _initWindow(),
      otherwise: () => Future(() => null),
    );
  }

  @override
  void dispose() {
    UniPlatform.call<Future<void>>(
      desktop: () => _uninitWindow(),
      otherwise: () => Future(() => null),
    );
    super.dispose();
  }

  @override
  Future<void> onWindowClose() async {
    await windowManager.hide();
    // ignore: use_build_context_synchronously
    context.go(PageId.home);
  }

  Future<void> _initWindow() async {
    windowManager.addListener(this);
    const size = Size(840, 600);
    const minimunSize = Size(840, 600);
    const maximumSize = Size(840, 600);
    await Future.any([
      windowManager.setSize(size),
      windowManager.setMinimumSize(minimunSize),
      windowManager.setMaximumSize(maximumSize),
      windowManager.center(),
      windowManager.setSkipTaskbar(false),
      windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: true,
      ),
      windowManager.setPreventClose(true),
    ]);

    await Future<void>.delayed(const Duration(milliseconds: 200));
    await windowManager.setOpacity(1);
    await windowManager.show();
  }

  Future<void> _uninitWindow() {
    windowManager.removeListener(this);
    return Future<void>.value();
  }

  Future<void> _handleDestinationSelected(String value) async {
    setState(() {
      _selectedDestination = value;
    });
    context.go(value);
  }

  Widget _buildSidebar(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: themeData.colorScheme.surfaceContainerLow,
        border: Border(
          right: BorderSide(
            color: themeData.colorScheme.outlineVariant,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        top: !UniPlatform.isWeb && UniPlatform.isMacOS ? 32 : 6,
      ),
      width: 200,
      height: double.infinity,
      child: NavList(
        children: [
          NavListSection(
            header: Text(
              LocaleKeys.app_settings__layout_navgroup_client.tr(),
            ),
            children: [
              NavListItem(
                selected: _selectedDestination == PageId.settingsGeneral,
                leading: const Icon(FluentIcons.app_generic_20_regular),
                title: Text(LocaleKeys.app_settings_general_title.tr()),
                onTap: () => _handleDestinationSelected(PageId.settingsGeneral),
              ),
              NavListItem(
                selected: _selectedDestination == PageId.settingsAppearance,
                leading: const Icon(FluentIcons.style_guide_20_regular),
                title: Text(LocaleKeys.app_settings_appearance_title.tr()),
                onTap: () =>
                    _handleDestinationSelected(PageId.settingsAppearance),
              ),
              NavListItem(
                selected: _selectedDestination == PageId.settingsKeybinds,
                leading: const Icon(FluentIcons.keyboard_20_regular),
                title: Text(LocaleKeys.app_settings_keybinds_title.tr()),
                onTap: () =>
                    _handleDestinationSelected(PageId.settingsKeybinds),
              ),
              NavListItem(
                selected: _selectedDestination == PageId.settingsLanguage,
                leading: const Icon(FluentIcons.local_language_20_regular),
                title: Text(LocaleKeys.app_settings_language_title.tr()),
                onTap: () =>
                    _handleDestinationSelected(PageId.settingsLanguage),
              ),
              NavListItem(
                selected: _selectedDestination == PageId.settingsAdvanced,
                leading: const Icon(FluentIcons.settings_20_regular),
                title: Text(LocaleKeys.app_settings_advanced_title.tr()),
                onTap: () =>
                    _handleDestinationSelected(PageId.settingsAdvanced),
              ),
            ],
          ),
          NavListSection(
            header: Text(
              LocaleKeys.app_settings__layout_navgroup_integrations.tr(),
            ),
            children: [
              NavListItem(
                selected: _selectedDestination == PageId.settingsOcrEngines,
                leading: const Icon(FluentIcons.scan_20_regular),
                title: Text(LocaleKeys.app_settings_ocr_engines_title.tr()),
                onTap: () =>
                    _handleDestinationSelected(PageId.settingsOcrEngines),
              ),
              NavListItem(
                selected:
                    _selectedDestination == PageId.settingsTranslationEngines,
                leading: const Icon(FluentIcons.translate_20_regular),
                title: Text(
                  LocaleKeys.app_settings_translation_engines_title.tr(),
                ),
                onTap: () => _handleDestinationSelected(
                  PageId.settingsTranslationEngines,
                ),
              ),
            ],
          ),
          NavListSection(
            header: Text(
              LocaleKeys.app_settings__layout_navgroup_resources.tr(),
            ),
            children: [
              NavListItem(
                selected: _selectedDestination == PageId.settingsAbout,
                leading: const Icon(FluentIcons.info_20_regular),
                title: Text(LocaleKeys.app_settings_about_title.tr()),
                onTap: () => _handleDestinationSelected(PageId.settingsAbout),
              ),
            ],
          ),
        ],
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
                color: Theme.of(context).colorScheme.surfaceContainerLow,
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
