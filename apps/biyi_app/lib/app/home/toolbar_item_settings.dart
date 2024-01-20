import 'package:biyi_app/app/router_config.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rise_ui/rise_ui.dart' hide Switch;
import 'package:uni_platform/uni_platform.dart';
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
    UniPlatform.call<Future<void>>(
      desktop: () async {
        await windowManager.hide();
      },
      otherwise: () => Future(() => null),
    );
    // ignore: use_build_context_synchronously
    context.go(PageId.settingsGeneral);
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
