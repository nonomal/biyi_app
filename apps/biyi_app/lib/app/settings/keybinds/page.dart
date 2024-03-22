import 'package:biyi_advanced_features/models/models.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:influxui/influxui.dart';
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
        for (KeyModifier keyModifier in hotKey.modifiers ?? []) ...[
          Kbd(
            keyModifier.keyLabel,
            size: ExtendedSize.small,
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
          hotKey.keyCode.keyLabel,
          size: ExtendedSize.small,
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
  Configuration get _configuration => localDb.configuration;

  @override
  void initState() {
    ShortcutService.instance.stop();
    localDb.preferences.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    ShortcutService.instance.start();
    localDb.preferences.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _handleClickRegisterNewHotKey(
    BuildContext context, {
    required String shortcutKey,
    HotKeyScope shortcutScope = HotKeyScope.system,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return RecordHotKeyDialog(
          onHotKeyRecorded: (newHotKey) {
            _configuration.setShortcut(
              shortcutKey,
              newHotKey..scope = shortcutScope,
            );
          },
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        PreferenceListSection.insetGrouped(
          children: [
            PreferenceListTile(
              title: Text(
                LocaleKeys.app_settings_keybinds_window_show_or_hide_title.tr(),
              ),
              additionalInfo: HotKeyDisplayView(
                _configuration.shortcutShowOrHide,
              ),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  shortcutKey: kShortcutShowOrHide,
                );
              },
            ),
            PreferenceListTile(
              title: Text(
                LocaleKeys.app_settings_keybinds_window_hide_title.tr(),
              ),
              additionalInfo: HotKeyDisplayView(
                _configuration.shortcutHide,
              ),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  shortcutKey: kShortcutHide,
                  shortcutScope: HotKeyScope.inapp,
                );
              },
            ),
          ],
        ),
        PreferenceListSection.insetGrouped(
          header: Text(
            LocaleKeys.app_settings_keybinds_extract_text_title.tr(),
          ),
          children: [
            PreferenceListTile(
              title: Text(
                LocaleKeys
                    .app_settings_keybinds_extract_text_from_selection_title
                    .tr(),
              ),
              additionalInfo: HotKeyDisplayView(
                _configuration.shortcutExtractFromScreenSelection,
              ),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  shortcutKey: kShortcutExtractFromScreenSelection,
                );
              },
            ),
            if (!UniPlatform.isLinux)
              PreferenceListTile(
                title: Text(
                  LocaleKeys
                      .app_settings_keybinds_extract_text_from_capture_title
                      .tr(),
                ),
                additionalInfo: HotKeyDisplayView(
                  _configuration.shortcutExtractFromScreenCapture,
                ),
                onTap: () {
                  _handleClickRegisterNewHotKey(
                    context,
                    shortcutKey: kShortcutExtractFromScreenCapture,
                  );
                },
              ),
            PreferenceListTile(
              title: Text(
                LocaleKeys
                    .app_settings_keybinds_extract_text_from_clipboard_title
                    .tr(),
              ),
              additionalInfo: HotKeyDisplayView(
                _configuration.shortcutExtractFromClipboard,
              ),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  shortcutKey: kShortcutExtractFromClipboard,
                );
              },
            ),
          ],
        ),
        if (!UniPlatform.isLinux)
          PreferenceListSection.insetGrouped(
            header: Text(
              LocaleKeys.app_settings_keybinds_input_assist_function_title.tr(),
            ),
            children: [
              PreferenceListTile(
                title: Text(
                  LocaleKeys
                      .app_settings_keybinds_input_assist_function_translate_input_content_title
                      .tr(),
                ),
                additionalInfo: HotKeyDisplayView(
                  _configuration.shortcutTranslateInputContent,
                ),
                onTap: () {
                  _handleClickRegisterNewHotKey(
                    context,
                    shortcutKey: kShortcutTranslateInputContent,
                  );
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget _build(BuildContext context) {
    return PageScaffold(
      title: LocaleKeys.app_settings_keybinds_title.tr(),
      subtitle: LocaleKeys.app_settings_keybinds_subtitle.tr(),
      child: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
