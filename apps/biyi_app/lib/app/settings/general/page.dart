import 'package:biyi_advanced_features/models/models.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/models/models.dart';
import 'package:biyi_app/pages/pages.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/utilities/utilities.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class GeneralSettingPage extends StatefulWidget {
  const GeneralSettingPage({super.key});

  @override
  State<GeneralSettingPage> createState() => _GeneralSettingPageState();
}

class _GeneralSettingPageState extends State<GeneralSettingPage> {
  Configuration get _configuration => localDb.configuration;

  OcrEngineConfig? get _defaultOcrEngineConfig =>
      localDb.ocrEngine(_configuration.defaultOcrEngineId).get();

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
    return PreferenceList(
      children: [
        PreferenceListSection(
          title: Text(t('pref_section_title_default_detect_text_engine')),
          children: [
            PreferenceListItem(
              icon: _defaultOcrEngineConfig == null
                  ? null
                  : OcrEngineIcon(_defaultOcrEngineConfig!.type),
              title: Builder(
                builder: (_) {
                  if (_defaultOcrEngineConfig == null) {
                    return Text('please_choose'.tr());
                  }
                  return OcrEngineName(_defaultOcrEngineConfig!);
                },
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OcrEngineChooserPage(
                      initialOcrEngineConfig: _defaultOcrEngineConfig,
                      onChoosed: (ocrEngineConfig) {
                        _configuration.defaultOcrEngineId =
                            ocrEngineConfig.identifier;
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        PreferenceListSection(
          children: [
            PreferenceListSwitchItem(
              value: _configuration.autoCopyDetectedText,
              title: Text(t('pref_item_auto_copy_detected_text')),
              onChanged: (newValue) async {
                _configuration.autoCopyDetectedText = newValue;
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t2('pref_section_title_default_translate_engine')),
          children: [
            PreferenceListItem(
              icon: _configuration.defaultTranslateEngineConfig == null
                  ? null
                  : TranslationEngineIcon(
                      _configuration.defaultTranslateEngineConfig!.type,
                    ),
              title: Builder(
                builder: (_) {
                  if (_configuration.defaultTranslateEngineConfig == null) {
                    return Text('please_choose'.tr());
                  }
                  return TranslationEngineName(
                    _configuration.defaultTranslateEngineConfig!,
                  );
                },
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TranslationEngineChooserPage(
                      initialEngineConfig:
                          _configuration.defaultTranslateEngineConfig,
                      onChoosed: (engineConfig) {
                        _configuration.defaultTranslateEngineId =
                            engineConfig.identifier;
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t2('pref_section_title_translation_mode')),
          children: [
            PreferenceListRadioItem(
              value: kTranslationModeManual,
              groupValue: _configuration.translationMode,
              onChanged: _handleTranslationModeChanged,
              title: Text('translation_mode.manual'.tr()),
            ),
            PreferenceListRadioItem(
              value: kTranslationModeAuto,
              groupValue: _configuration.translationMode,
              onChanged: _handleTranslationModeChanged,
              title: Text('translation_mode.auto'.tr()),
            ),
          ],
        ),
        if (_configuration.translationMode == kTranslationModeAuto)
          PreferenceListSection(
            title:
                Text(t2('pref_section_title_default_detect_language_engine')),
            children: [
              PreferenceListItem(
                icon: _configuration.defaultEngineConfig == null
                    ? null
                    : TranslationEngineIcon(
                        _configuration.defaultEngineConfig!.type,
                      ),
                title: Builder(
                  builder: (_) {
                    if (_configuration.defaultEngineConfig == null) {
                      return Text('please_choose'.tr());
                    }
                    return TranslationEngineName(
                      _configuration.defaultEngineConfig!,
                    );
                  },
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TranslationEngineChooserPage(
                        initialEngineConfig: _configuration.defaultEngineConfig,
                        onChoosed: (engineConfig) {
                          _configuration.defaultEngineId =
                              engineConfig.identifier;
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        if (_configuration.translationMode == kTranslationModeAuto)
          PreferenceListSection(
            title: Text(t2('pref_section_title_translation_target')),
            children: [
              for (TranslationTarget translationTarget in _translationTargets)
                PreferenceListItem(
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TranslationTargetNewPage(
                          translationTarget: translationTarget,
                        ),
                      ),
                    );
                  },
                ),
              PreferenceListItem(
                title: Text(
                  LocaleKeys.add.tr(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                accessoryView: Container(),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TranslationTargetNewPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        PreferenceListSection(
          children: [
            PreferenceListSwitchItem(
              value: _configuration.doubleClickCopyResult,
              title: Text(t2('pref_item_title_double_click_copy_result')),
              onChanged: (newValue) async {
                _configuration.doubleClickCopyResult = newValue;
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t3('pref_section_title_input_settings')),
          children: [
            PreferenceListRadioItem<String>(
              value: kInputSettingSubmitWithEnter,
              groupValue: _configuration.inputSetting,
              title: Text(t3('pref_item_title_submit_with_enter')),
              onChanged: (newValue) {
                _configuration.inputSetting = newValue;
              },
            ),
            PreferenceListRadioItem<String>(
              value: kInputSettingSubmitWithMetaEnter,
              groupValue: _configuration.inputSetting,
              title: Text(
                t3(
                  kIsMacOS
                      ? 'pref_item_title_submit_with_meta_enter_mac'
                      : 'pref_item_title_submit_with_meta_enter',
                ),
              ),
              onChanged: (newValue) {
                _configuration.inputSetting = newValue;
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          LocaleKeys.app_settings_general_title.tr(),
        ),
      ),
      body: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  String t(String key, {List<String> args = const []}) {
    return 'page_setting_extract_text.$key'.tr(args: args);
  }

  String t2(String key, {List<String> args = const []}) {
    return 'page_setting_translate.$key'.tr(args: args);
  }

  String t3(String key, {List<String> args = const []}) {
    return 'page_settings.$key'.tr(args: args);
  }
}
