import 'package:biyi_app/app/router_config.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rise_ui/rise_ui.dart';
import 'package:window_manager/window_manager.dart';

class ToolbarItemSettings extends StatefulWidget {
  const ToolbarItemSettings({
    super.key,
  });

  @override
  State<ToolbarItemSettings> createState() => _ToolbarItemSettingsState();
}

class _ToolbarItemSettingsState extends State<ToolbarItemSettings> {
  Future<void> _handleClick() async {
    const size = Size(840, 600);
    const minimunSize = Size(840, 600);
    const maximumSize = Size(840, 600);

    await windowManager.hide();
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
    // ignore: use_build_context_synchronously
    context.go(PageId.generalSetting);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await windowManager.show();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    return ActionIcon(
      FluentIcons.settings_20_regular,
      variant: ActionIconVariant.transparent,
      color: brightness == Brightness.light ? Colors.black : Colors.grey,
      onPressed: _handleClick,
    );
  }
}
