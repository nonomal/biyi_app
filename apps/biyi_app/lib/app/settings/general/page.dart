import 'package:biyi_advanced_features/models/models.dart';
import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/models/models.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Icons;
import 'package:go_router/go_router.dart';
import 'package:rise_ui/rise_ui.dart';
import 'package:uni_platform/uni_platform.dart';

class GeneralSettingPage extends StatefulWidget {
  const GeneralSettingPage({super.key});

  @override
  State<GeneralSettingPage> createState() => _GeneralSettingPageState();
}

class _GeneralSettingPageState extends State<GeneralSettingPage> {
  Configuration get _configuration => localDb.configuration;

  OcrEngineConfig? get _defaultOcrEngineConfig {
    if (_configuration.defaultOcrEngineId == null) return null;
    return localDb.ocrEngine(_configuration.defaultOcrEngineId).get();
  }

  List<TranslationTarget> get _translationTargets {
    return localDb.translationTargets.list();
  }

  @override
  void initState() {
    localDb.preferences.addListener(_handleChanged);
    localDb.translationTargets.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.preferences.removeListener(_handleChanged);
    localDb.translationTargets.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  void _handleTranslationModeChanged(newValue) {
    _configuration.translationMode = newValue;
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        PreferenceListSection.insetGrouped(
          header: Text(
            LocaleKeys.app_settings_general_default_detect_text_engine_title
                .tr(),
          ),
          children: [
            PreferenceListTile(
              leading: _defaultOcrEngineConfig == null
                  ? null
                  : OcrEngineIcon(_defaultOcrEngineConfig!.type),
              title: Builder(
                builder: (_) {
                  if (_defaultOcrEngineConfig == null) {
                    return Text(LocaleKeys.please_choose.tr());
                  }
                  return OcrEngineName(_defaultOcrEngineConfig!);
                },
              ),
              onTap: () async {
                final OcrEngineConfig? ocrEngineConfig =
                    await context.push<OcrEngineConfig?>(
                  '${PageId.ocrEngines}?selectedEngineId=${_configuration.defaultOcrEngineId}',
                );
                if (ocrEngineConfig != null) {
                  _configuration.defaultOcrEngineId =
                      ocrEngineConfig.identifier;
                }
              },
            ),
          ],
        ),
        PreferenceListSection.insetGrouped(
          children: [
            PreferenceListTile(
              title: Text(
                LocaleKeys
                    .app_settings_general_extract_text_auto_copy_detected_text_title
                    .tr(),
              ),
              additionalInfo: _configuration.autoCopyDetectedText
                  ? Icon(
                      FluentIcons.checkmark_circle_20_filled,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () async {
                _configuration.autoCopyDetectedText =
                    !_configuration.autoCopyDetectedText;
              },
            ),
          ],
        ),
        PreferenceListSection.insetGrouped(
          header: Text(
            LocaleKeys.app_settings_general_default_translate_engine_title.tr(),
          ),
          children: [
            PreferenceListTile(
              leading: _configuration.defaultTranslateEngineConfig == null
                  ? null
                  : TranslationEngineIcon(
                      _configuration.defaultTranslateEngineConfig!.type,
                    ),
              title: Builder(
                builder: (_) {
                  if (_configuration.defaultTranslateEngineConfig == null) {
                    return Text(LocaleKeys.please_choose.tr());
                  }
                  return TranslationEngineName(
                    _configuration.defaultTranslateEngineConfig!,
                  );
                },
              ),
              onTap: () async {
                final TranslationEngineConfig? engineConfig =
                    await context.push<TranslationEngineConfig?>(
                  '${PageId.translationEngines}?selectedEngineId=${_configuration.defaultTranslateEngineId}',
                );
                if (engineConfig != null) {
                  _configuration.defaultTranslateEngineId =
                      engineConfig.identifier;
                }
              },
            ),
          ],
        ),
        PreferenceListSection.insetGrouped(
          header: Text(
            LocaleKeys.app_settings_general_translation_mode_title.tr(),
          ),
          children: [
            PreferenceListTile(
              title: Text(LocaleKeys.translation_mode_manual.tr()),
              additionalInfo:
                  _configuration.translationMode == kTranslationModeManual
                      ? Icon(
                          FluentIcons.checkmark_circle_20_filled,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
              onTap: () =>
                  _handleTranslationModeChanged(kTranslationModeManual),
            ),
            PreferenceListTile(
              title: Text(LocaleKeys.translation_mode_auto.tr()),
              additionalInfo:
                  _configuration.translationMode == kTranslationModeAuto
                      ? Icon(
                          FluentIcons.checkmark_circle_20_filled,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
              onTap: () => _handleTranslationModeChanged(kTranslationModeAuto),
            ),
          ],
        ),
        if (_configuration.translationMode == kTranslationModeAuto)
          PreferenceListSection.insetGrouped(
            header: Text(
              LocaleKeys
                  .app_settings_general_default_detect_language_engine_title
                  .tr(),
            ),
            children: [
              PreferenceListTile(
                leading: _configuration.defaultEngineConfig == null
                    ? null
                    : TranslationEngineIcon(
                        _configuration.defaultEngineConfig!.type,
                      ),
                title: Builder(
                  builder: (_) {
                    if (_configuration.defaultEngineConfig == null) {
                      return Text(LocaleKeys.please_choose.tr());
                    }
                    return TranslationEngineName(
                      _configuration.defaultEngineConfig!,
                    );
                  },
                ),
                onTap: () async {
                  final TranslationEngineConfig? engineConfig =
                      await context.push<TranslationEngineConfig?>(
                    '${PageId.translationEngines}?selectedEngineId=${_configuration.defaultEngineId}',
                  );
                  if (engineConfig != null) {
                    _configuration.defaultEngineId = engineConfig.identifier;
                  }
                },
              ),
            ],
          ),
        if (_configuration.translationMode == kTranslationModeAuto)
          PreferenceListSection.insetGrouped(
            header: Text(
              LocaleKeys.app_settings_general_translation_target_title.tr(),
            ),
            children: [
              for (TranslationTarget translationTarget in _translationTargets)
                PreferenceListTile(
                  title: Builder(
                    builder: (_) {
                      return Row(
                        children: [
                          if (translationTarget.sourceLanguage != null)
                            LanguageLabel(translationTarget.sourceLanguage!),
                          if (translationTarget.targetLanguage != null)
                            Container(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Icon(
                                FluentIcons.arrow_right_20_regular,
                                size: 16,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                          if (translationTarget.targetLanguage != null)
                            LanguageLabel(translationTarget.targetLanguage!),
                        ],
                      );
                    },
                  ),
                  onTap: () async {
                    await context.push<TranslationEngineConfig?>(
                      PageId.translationTargetsNew,
                    );
                  },
                ),
              PreferenceListTile(
                title: Text(
                  LocaleKeys.add.tr(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
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
        PreferenceListSection.insetGrouped(
          children: [
            PreferenceListTile(
              title: Text(
                LocaleKeys
                    .app_settings_general_translate_double_click_copy_result_title
                    .tr(),
              ),
              additionalInfo: _configuration.doubleClickCopyResult
                  ? Icon(
                      FluentIcons.checkmark_circle_20_filled,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () async {
                _configuration.doubleClickCopyResult =
                    !_configuration.doubleClickCopyResult;
              },
            ),
          ],
        ),
        PreferenceListSection.insetGrouped(
          header: Text(
            LocaleKeys.app_settings_general_input_settings_title.tr(),
          ),
          hasLeading: false,
          children: [
            PreferenceListTile(
              title: Text(
                LocaleKeys
                    .app_settings_general_input_settings_submit_with_enter_title
                    .tr(),
              ),
              additionalInfo:
                  _configuration.inputSetting == kInputSettingSubmitWithEnter
                      ? Icon(
                          FluentIcons.checkmark_circle_20_filled,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
              onTap: () {
                _configuration.inputSetting = kInputSettingSubmitWithEnter;
              },
            ),
            PreferenceListTile(
              title: Text(
                UniPlatform.isMacOS
                    ? LocaleKeys
                        .app_settings_general_input_settings_submit_with_meta_enter_mac_title
                        .tr()
                    : LocaleKeys
                        .app_settings_general_input_settings_submit_with_meta_enter_title
                        .tr(),
              ),
              additionalInfo: _configuration.inputSetting ==
                      kInputSettingSubmitWithMetaEnter
                  ? Icon(
                      FluentIcons.checkmark_circle_20_filled,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () {
                _configuration.inputSetting = kInputSettingSubmitWithMetaEnter;
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: LocaleKeys.app_settings_general_title.tr(),
      subtitle: LocaleKeys.app_settings_general_subtitle.tr(),
      child: _buildBody(context),
    );
  }
}
