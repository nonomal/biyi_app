import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:biyi_app/widgets/kbd/kbd.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:provider/provider.dart';
import 'package:reflect_ui/reflect_ui.dart';
import 'package:uni_platform/uni_platform.dart';

class HotKeyDisplayView extends StatelessWidget {
  const HotKeyDisplayView(
    this.hotKey, {
    super.key,
  });

  final HotKey hotKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final HotKeyModifier modifier in hotKey.modifiers ?? []) ...[
          Kbd(
            modifier.physicalKeys.first.keyLabel,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto Mono',
              ),
            ),
          ),
        ],
        Kbd(
          hotKey.physicalKey.keyLabel,
        ),
      ],
    );
  }
}

class KeybindsSettingPage extends StatefulWidget {
  const KeybindsSettingPage({super.key});

  @override
  State<KeybindsSettingPage> createState() => _KeybindsSettingPageState();
}

class _KeybindsSettingPageState extends State<KeybindsSettingPage> {
  Future<void> _handleClickRegisterNewHotKey(
    BuildContext context, {
    HotKeyScope shortcutScope = HotKeyScope.system,
    ValueChanged<HotKey?>? onHotKeyRecorded,
  }) async {
    final HotKey? recordedShortcut = await context.push<HotKey?>(
      '/record-shortcut',
      extra: {},
    );
    if (recordedShortcut != null) {
      onHotKeyRecorded?.call(
        HotKey(
          key: recordedShortcut.key,
          modifiers: recordedShortcut.modifiers,
          scope: shortcutScope,
        ),
      );
    }
  }

  Widget _buildBody(BuildContext context) {
    final Settings settings = context.watch<Settings>();
    final BoundShortcuts boundShortcuts = settings.boundShortcuts;

    return ListView(
      children: [
        ListSection(
          hasLeading: false,
          children: [
            ListTile(
              title: Text(
                LocaleKeys.app_settings_keybinds_window_show_or_hide_title.tr(),
              ),
              additionalInfo: HotKeyDisplayView(boundShortcuts.showOrHide),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  onHotKeyRecorded: (value) => context
                      .read<Settings>()
                      .updateShortcuts(showOrHide: value),
                );
              },
            ),
            ListTile(
              title: Text(
                LocaleKeys.app_settings_keybinds_window_hide_title.tr(),
              ),
              additionalInfo: HotKeyDisplayView(boundShortcuts.hide),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  shortcutScope: HotKeyScope.inapp,
                  onHotKeyRecorded: (value) =>
                      context.read<Settings>().updateShortcuts(hide: value),
                );
              },
            ),
          ],
        ),
        ListSection(
          hasLeading: false,
          header: Text(
            LocaleKeys.app_settings_keybinds_extract_text_title.tr(),
          ),
          children: [
            ListTile(
              title: Text(
                LocaleKeys
                    .app_settings_keybinds_extract_text_from_selection_title
                    .tr(),
              ),
              additionalInfo: HotKeyDisplayView(
                boundShortcuts.extractFromScreenSelection,
              ),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  onHotKeyRecorded: (value) => context
                      .read<Settings>()
                      .updateShortcuts(extractFromScreenSelection: value),
                );
              },
            ),
            if (!UniPlatform.isLinux)
              ListTile(
                title: Text(
                  LocaleKeys
                      .app_settings_keybinds_extract_text_from_capture_title
                      .tr(),
                ),
                additionalInfo: HotKeyDisplayView(
                  boundShortcuts.extractFromScreenCapture,
                ),
                onTap: () {
                  _handleClickRegisterNewHotKey(
                    context,
                    onHotKeyRecorded: (value) => context
                        .read<Settings>()
                        .updateShortcuts(extractFromScreenCapture: value),
                  );
                },
              ),
            ListTile(
              title: Text(
                LocaleKeys
                    .app_settings_keybinds_extract_text_from_clipboard_title
                    .tr(),
              ),
              additionalInfo: HotKeyDisplayView(
                boundShortcuts.extractFromClipboard,
              ),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  onHotKeyRecorded: (value) => context
                      .read<Settings>()
                      .updateShortcuts(extractFromClipboard: value),
                );
              },
            ),
          ],
        ),
        if (!UniPlatform.isLinux)
          ListSection(
            hasLeading: false,
            header: Text(
              LocaleKeys.app_settings_keybinds_input_assist_function_title.tr(),
            ),
            children: [
              ListTile(
                title: Text(
                  LocaleKeys
                      .app_settings_keybinds_input_assist_function_translate_input_content_title
                      .tr(),
                ),
                additionalInfo: HotKeyDisplayView(
                  boundShortcuts.translateInputContent,
                ),
                onTap: () {
                  _handleClickRegisterNewHotKey(
                    context,
                    onHotKeyRecorded: (value) => context
                        .read<Settings>()
                        .updateShortcuts(translateInputContent: value),
                  );
                },
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
        title: Text(LocaleKeys.app_settings_keybinds_title.tr()),
      ),
      body: _buildBody(context),
    );
  }
}
