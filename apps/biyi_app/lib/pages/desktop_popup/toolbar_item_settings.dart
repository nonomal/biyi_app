import 'package:biyi_app/includes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' as md;
import 'package:flutter/material.dart';
import 'package:rise_ui/rise_ui.dart';

class ToolbarItemSettings extends StatefulWidget {
  const ToolbarItemSettings({
    super.key,
    required this.onSubPageDismissed,
  });

  final VoidCallback onSubPageDismissed;

  @override
  State<ToolbarItemSettings> createState() => _ToolbarItemSettingsState();
}

class _ToolbarItemSettingsState extends State<ToolbarItemSettings> {
  Future<void> _handleDismiss() async {
    await Future.delayed(const Duration(milliseconds: 200));
    widget.onSubPageDismissed();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = md.Theme.of(context).brightness;
    return ActionIcon(
      FluentIcons.settings_20_regular,
      variant: ActionIconVariant.transparent,
      color: brightness == Brightness.light ? Colors.black : Colors.grey,
      onPressed: () {
        showModalBottomSheetPage(
          context: context,
          builder: (ctx) {
            return SettingsPage(
              onDismiss: () {
                Navigator.of(ctx).pop();
                _handleDismiss();
              },
            );
          },
        ).whenComplete(() => _handleDismiss());
      },
    );
  }
}
