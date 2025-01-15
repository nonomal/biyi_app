import 'dart:async';

import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/i18n/strings.g.dart';

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
    final DesignThemeData theme = DesignTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceMuted,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.border!,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        top: !UniPlatform.isWeb && UniPlatform.isMacOS ? 32 : 6,
      ),
      width: 200,
      height: double.infinity,
      child: SideNavigation(
        children: [
          SideNavigationSection(
            header: Text(
              t.app.settings.kLayout.navgroup.client,
            ),
            children: [
              SideNavigationItem(
                selected: _selectedDestination == PageId.settingsGeneral,
                leading: const Icon(FluentIcons.app_generic_20_regular),
                title: Text(t.app.settings.general.title),
                onTap: () => _handleDestinationSelected(PageId.settingsGeneral),
              ),
              SideNavigationItem(
                selected: _selectedDestination == PageId.settingsAppearance,
                leading: const Icon(FluentIcons.style_guide_20_regular),
                title: Text(t.app.settings.appearance.title),
                onTap: () =>
                    _handleDestinationSelected(PageId.settingsAppearance),
              ),
              SideNavigationItem(
                selected: _selectedDestination == PageId.settingsKeybinds,
                leading: const Icon(FluentIcons.keyboard_20_regular),
                title: Text(t.app.settings.keybinds.title),
                onTap: () =>
                    _handleDestinationSelected(PageId.settingsKeybinds),
              ),
              SideNavigationItem(
                selected: _selectedDestination == PageId.settingsLanguage,
                leading: const Icon(FluentIcons.local_language_20_regular),
                title: Text(t.app.settings.language.title),
                onTap: () =>
                    _handleDestinationSelected(PageId.settingsLanguage),
              ),
              SideNavigationItem(
                selected: _selectedDestination == PageId.settingsAdvanced,
                leading: const Icon(FluentIcons.settings_20_regular),
                title: Text(t.app.settings.advanced.title),
                onTap: () =>
                    _handleDestinationSelected(PageId.settingsAdvanced),
              ),
            ],
          ),
          SideNavigationSection(
            header: Text(
              t.app.settings.kLayout.navgroup.integrations,
            ),
            children: [
              SideNavigationItem(
                selected: _selectedDestination == PageId.settingsOcrEngines,
                leading: const Icon(FluentIcons.scan_20_regular),
                title: Text(t.app.settings.ocr_engines.title),
                onTap: () =>
                    _handleDestinationSelected(PageId.settingsOcrEngines),
              ),
              SideNavigationItem(
                selected:
                    _selectedDestination == PageId.settingsTranslationEngines,
                leading: const Icon(FluentIcons.translate_20_regular),
                title: Text(
                  t.app.settings.translation_engines.title,
                ),
                onTap: () => _handleDestinationSelected(
                  PageId.settingsTranslationEngines,
                ),
              ),
            ],
          ),
          SideNavigationSection(
            header: Text(
              t.app.settings.kLayout.navgroup.resources,
            ),
            children: [
              SideNavigationItem(
                selected: _selectedDestination == PageId.settingsAbout,
                leading: const Icon(FluentIcons.info_20_regular),
                title: Text(t.app.settings.about.title),
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

    return PageScaffold(
      child: AdaptiveLayout(
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
