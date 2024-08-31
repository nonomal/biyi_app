import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/models/translation_target.dart';
import 'package:biyi_app/services/api_client.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
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
            SwitchListTile(
              value: settings.autoCopyRecognizedText,
              onChanged: (value) {
                _handleUpdateSettings(autoCopyRecognizedText: value);
              },
              title: Text(
                LocaleKeys
                    .app_settings_general_extract_text_auto_copy_detected_text_title
                    .tr(),
              ),
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
          hasLeading: false,
          header: Text(
            LocaleKeys.app_settings_general_translation_mode_title.tr(),
          ),
          children: [
            RadioListTile<TranslationMode>(
              value: TranslationMode.manual,
              groupValue: settings.translationMode,
              onChanged: (value) =>
                  _handleUpdateSettings(translationMode: value),
              useCheckmarkStyle: true,
              title: Text(LocaleKeys.translation_mode_manual.tr()),
            ),
            RadioListTile<TranslationMode>(
              value: TranslationMode.auto,
              groupValue: settings.translationMode,
              onChanged: (value) =>
                  _handleUpdateSettings(translationMode: value),
              useCheckmarkStyle: true,
              title: Text(LocaleKeys.translation_mode_auto.tr()),
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
            SwitchListTile(
              value: settings.doubleClickCopyResult,
              onChanged: (value) {
                _handleUpdateSettings(
                  doubleClickCopyResult: value,
                );
              },
              title: Text(
                LocaleKeys
                    .app_settings_general_translate_double_click_copy_result_title
                    .tr(),
              ),
            ),
          ],
        ),
        ListSection(
          hasLeading: false,
          header: Text(
            LocaleKeys.app_settings_general_input_settings_title.tr(),
          ),
          children: [
            RadioListTile<InputSubmitMode>(
              value: InputSubmitMode.enter,
              groupValue: settings.inputSubmitMode,
              onChanged: (value) =>
                  _handleUpdateSettings(inputSubmitMode: value),
              useCheckmarkStyle: true,
              title: Text(
                LocaleKeys
                    .app_settings_general_input_settings_submit_with_enter_title
                    .tr(),
              ),
            ),
            RadioListTile<InputSubmitMode>(
              value: InputSubmitMode.metaEnter,
              groupValue: settings.inputSubmitMode,
              onChanged: (value) =>
                  _handleUpdateSettings(inputSubmitMode: value),
              useCheckmarkStyle: true,
              title: Text(
                UniPlatform.isMacOS
                    ? LocaleKeys
                        .app_settings_general_input_settings_submit_with_meta_enter_mac_title
                        .tr()
                    : LocaleKeys
                        .app_settings_general_input_settings_submit_with_meta_enter_title
                        .tr(),
              ),
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
