import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/models/translation_target.dart';
import 'package:biyi_app/services/api_client.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:biyi_app/widgets/list_section.dart';
import 'package:biyi_app/widgets/list_tile.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reflect_ui/reflect_ui.dart';
import 'package:uni_platform/uni_platform.dart';

class GeneralSettingPage extends StatefulWidget {
  const GeneralSettingPage({super.key});

  @override
  State<GeneralSettingPage> createState() => _GeneralSettingPageState();
}

class _GeneralSettingPageState extends State<GeneralSettingPage> {
  void _handleUpdateSettings({
    String? defaultOcrEngineId,
    bool? autoCopyRecognizedText,
    String? defaultTranslationEngineId,
    TranslationMode? translationMode,
    String? defaultDetectLanguageEngineId,
    bool? doubleClickCopyResult,
    InputSubmitMode? inputSubmitMode,
  }) {
    final settings = context.read<Settings>();
    settings.update(
      defaultOcrEngineId: defaultOcrEngineId,
      autoCopyRecognizedText: autoCopyRecognizedText,
      defaultTranslationEngineId: defaultTranslationEngineId,
      translationMode: translationMode,
      defaultDetectLanguageEngineId: defaultDetectLanguageEngineId,
      doubleClickCopyResult: doubleClickCopyResult,
      inputSubmitMode: inputSubmitMode,
    );
  }

  Widget _buildBody(BuildContext context) {
    final settings = context.watch<Settings>();

    return ListView(
      children: [
        ListSection(
          header: Text(
            LocaleKeys.app_settings_general_default_detect_text_engine_title
                .tr(),
          ),
          children: [
            ListTile(
              leading: settings.defaultOcrEngineConfig == null
                  ? null
                  : OcrEngineIcon(settings.defaultOcrEngineConfig!.type),
              title: Builder(
                builder: (_) {
                  if (settings.defaultOcrEngineConfig == null) {
                    return Text(LocaleKeys.please_choose.tr());
                  }
                  return OcrEngineName(
                    settings.defaultOcrEngineConfig!,
                  );
                },
              ),
              trailing: const ListTileChevron(),
              onTap: () async {
                final OcrEngineConfig? ocrEngineConfig =
                    await context.push<OcrEngineConfig?>(
                  '${PageId.availableOcrEngines}?selectedEngineId=${settings.defaultOcrEngineId}',
                );
                if (ocrEngineConfig != null) {
                  _handleUpdateSettings(defaultOcrEngineId: ocrEngineConfig.id);
                }
              },
            ),
          ],
        ),
        ListSection(
          children: [
            ListTile(
              title: Text(
                LocaleKeys
                    .app_settings_general_extract_text_auto_copy_detected_text_title
                    .tr(),
              ),
              additionalInfo: Switch(
                value: settings.autoCopyRecognizedText,
                onChanged: (value) {
                  _handleUpdateSettings(autoCopyRecognizedText: value);
                },
              ),
              onTap: () async {
                _handleUpdateSettings(
                  autoCopyRecognizedText: !settings.autoCopyRecognizedText,
                );
              },
            ),
          ],
        ),
        ListSection(
          header: Text(
            LocaleKeys.app_settings_general_default_translate_engine_title.tr(),
          ),
          children: [
            ListTile(
              leading: settings.defaultTranslationEngineConfig == null
                  ? null
                  : TranslationEngineIcon(
                      settings.defaultTranslationEngineConfig!.type,
                    ),
              title: Builder(
                builder: (_) {
                  if (settings.defaultTranslationEngineConfig == null) {
                    return Text(LocaleKeys.please_choose.tr());
                  }
                  return TranslationEngineName(
                    settings.defaultTranslationEngineConfig!,
                  );
                },
              ),
              trailing: const ListTileChevron(),
              onTap: () async {
                final TranslationEngineConfig? engineConfig =
                    await context.push<TranslationEngineConfig?>(
                  '${PageId.availableTranslationEngines}?selectedEngineId=${settings.defaultTranslationEngineId}',
                );
                if (engineConfig != null) {
                  _handleUpdateSettings(
                    defaultTranslationEngineId: engineConfig.id,
                  );
                }
              },
            ),
          ],
        ),
        ListSection(
          header: Text(
            LocaleKeys.app_settings_general_translation_mode_title.tr(),
          ),
          children: [
            ListTile(
              title: Text(LocaleKeys.translation_mode_manual.tr()),
              additionalInfo: settings.translationMode == TranslationMode.manual
                  ? const Icon(
                      FluentIcons.checkmark_circle_16_filled,
                    )
                  : null,
              onTap: () => _handleUpdateSettings(
                translationMode: TranslationMode.manual,
              ),
            ),
            ListTile(
              title: Text(LocaleKeys.translation_mode_auto.tr()),
              additionalInfo: settings.translationMode == TranslationMode.auto
                  ? const Icon(
                      FluentIcons.checkmark_circle_16_filled,
                    )
                  : null,
              onTap: () =>
                  _handleUpdateSettings(translationMode: TranslationMode.auto),
            ),
          ],
        ),
        if (settings.translationMode == TranslationMode.auto)
          ListSection(
            header: Text(
              LocaleKeys
                  .app_settings_general_default_detect_language_engine_title
                  .tr(),
            ),
            children: [
              ListTile(
                leading: settings.defaultDetectLanguageEngineConfig == null
                    ? null
                    : TranslationEngineIcon(
                        settings.defaultDetectLanguageEngineConfig!.type,
                      ),
                title: Builder(
                  builder: (_) {
                    if (settings.defaultDetectLanguageEngineConfig == null) {
                      return Text(LocaleKeys.please_choose.tr());
                    }
                    return TranslationEngineName(
                      settings.defaultDetectLanguageEngineConfig!,
                    );
                  },
                ),
                onTap: () async {
                  final TranslationEngineConfig? engineConfig =
                      await context.push<TranslationEngineConfig?>(
                    '${PageId.availableTranslationEngines}?selectedEngineId=${settings.defaultDetectLanguageEngineId}',
                  );
                  if (engineConfig != null) {
                    _handleUpdateSettings(
                      defaultDetectLanguageEngineId: engineConfig.id,
                    );
                  }
                },
              ),
            ],
          ),
        if (settings.translationMode == TranslationMode.auto)
          ListSection(
            header: Text(
              LocaleKeys.app_settings_general_translation_target_title.tr(),
            ),
            children: [
              for (TranslationTarget translationTarget
                  in settings.translationTargets)
                ListTile(
                  title: Builder(
                    builder: (_) {
                      return Row(
                        children: [
                          if (translationTarget.sourceLanguage != null)
                            LanguageLabel(translationTarget.sourceLanguage!),
                          if (translationTarget.targetLanguage != null)
                            Container(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: const Icon(
                                FluentIcons.arrow_right_20_regular,
                                size: 16,
                              ),
                            ),
                          if (translationTarget.targetLanguage != null)
                            LanguageLabel(translationTarget.targetLanguage!),
                        ],
                      );
                    },
                  ),
                  onTap: () async {
                    await context.push<String?>(
                      PageId.settingsTranslationTarget(translationTarget.id!),
                      extra: {
                        'id': translationTarget.id,
                        'sourceLanguage': translationTarget.sourceLanguage,
                        'targetLanguage': translationTarget.targetLanguage,
                      },
                    );
                  },
                ),
              ListTile(
                title: Text(
                  LocaleKeys.add.tr(),
                  style: const TextStyle(
                      // color: Theme.of(context).primaryColor,
                      ),
                ),
                onTap: () async {
                  await context.push<TranslationEngineConfig?>(
                    PageId.translationTargetsNew,
                  );
                },
              ),
            ],
          ),
        ListSection(
          children: [
            ListTile(
              title: Text(
                LocaleKeys
                    .app_settings_general_translate_double_click_copy_result_title
                    .tr(),
              ),
              additionalInfo: Switch(
                value: settings.doubleClickCopyResult,
                onChanged: (value) {
                  _handleUpdateSettings(
                    doubleClickCopyResult: value,
                  );
                },
              ),
              onTap: () async {
                _handleUpdateSettings(
                  doubleClickCopyResult: !settings.doubleClickCopyResult,
                );
              },
            ),
          ],
        ),
        ListSection(
          header: Text(
            LocaleKeys.app_settings_general_input_settings_title.tr(),
          ),
          children: [
            ListTile(
              title: Text(
                LocaleKeys
                    .app_settings_general_input_settings_submit_with_enter_title
                    .tr(),
              ),
              additionalInfo: settings.inputSubmitMode == InputSubmitMode.enter
                  ? const Icon(
                      FluentIcons.checkmark_circle_16_filled,
                    )
                  : null,
              onTap: () {
                _handleUpdateSettings(
                  inputSubmitMode: InputSubmitMode.enter,
                );
              },
            ),
            ListTile(
              title: Text(
                UniPlatform.isMacOS
                    ? LocaleKeys
                        .app_settings_general_input_settings_submit_with_meta_enter_mac_title
                        .tr()
                    : LocaleKeys
                        .app_settings_general_input_settings_submit_with_meta_enter_title
                        .tr(),
              ),
              additionalInfo:
                  settings.inputSubmitMode == InputSubmitMode.metaEnter
                      ? const Icon(
                          FluentIcons.checkmark_circle_16_filled,
                        )
                      : null,
              onTap: () {
                _handleUpdateSettings(
                  inputSubmitMode: InputSubmitMode.metaEnter,
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
        title: Text(LocaleKeys.app_settings_general_title.tr()),
      ),
      body: _buildBody(context),
    );
  }
}
