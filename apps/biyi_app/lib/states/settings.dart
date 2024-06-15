import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:biyi_advanced_features/models/ocr_engine_config.dart';
import 'package:biyi_advanced_features/models/translation_engine_config.dart';
import 'package:biyi_app/models/settings_base.dart';
import 'package:biyi_app/models/translation_target.dart';
import 'package:biyi_app/services/local_db/migrate_old_settings.dart';
import 'package:biyi_app/utilities/utilities.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:shortid/shortid.dart';
import 'package:uni_translate_client/uni_translate_client.dart';

export 'package:biyi_app/models/settings_base.dart';

Future<File> _getOldSettingsMigratedFile() async {
  final appDir = await getAppDirectory();
  return File('${appDir.path}/old_settings_migrated.json');
}

Future<File> _getSettingsFile() async {
  final appDir = await getAppDirectory();
  return File('${appDir.path}/settings.json');
}

class Settings extends SettingsBase with ChangeNotifier {
  Settings._();

  /// The shared instance of [Settings].
  static final Settings instance = Settings._();

  Future<void> loadFromLocalFile() => _readFromLocalFile();

  Locale get locale => languageToLocale(displayLanguage ?? 'en');

  set locale(Locale locale) {
    update(displayLanguage: locale.toLanguageTag());
  }

  Future<void> create({
    String group = 'private',
    required String type,
    required Map<String, dynamic> option,
  }) async {
    int position = 1;
    if (ocrEngines.isNotEmpty) {
      position = ocrEngines.last.position + 1;
    }
    final value = OcrEngineConfig(
      position: position,
      group: group,
      id: shortid.generate(),
      type: type,
      option: option,
    );
    ocrEngines.add(value);

    notifyListeners();
    unawaited(_writeToLocalFile());
  }

  void updateOcrEngine(
    String id, {
    int? position,
    String? type,
    Map<String, dynamic>? option,
    bool? disabled,
  }) {
    final index = ocrEngines.indexWhere((element) => element.id == id);
    if (index == -1) return;

    final ocrEngine = ocrEngines[index];
    ocrEngines[index].position = position ?? ocrEngine.position;
    ocrEngines[index].type = type ?? ocrEngine.type;
    ocrEngines[index].option = option ?? ocrEngine.option;
    ocrEngines[index].disabled = disabled ?? ocrEngine.disabled;

    notifyListeners();
    unawaited(_writeToLocalFile());
  }

  void deleteOcrEngine(String id) {
    ocrEngines.removeWhere((element) => element.id == id);
    notifyListeners();
    unawaited(_writeToLocalFile());
  }

  void createTranslationEngine({
    String? id,
    String group = 'private',
    required String type,
    required Map<String, dynamic> option,
    List<String>? supportedScopes,
    bool? disabled,
  }) {
    int position = 1;
    if (translationEngines.isNotEmpty) {
      position = translationEngines.last.position + 1;
    }
    final value = TranslationEngineConfig(
      position: position,
      group: group,
      id: id ?? shortid.generate(),
      type: type,
      option: option,
      supportedScopes: (supportedScopes ?? [])
          .map(
            (e) => TranslationEngineScope.values.firstWhere((v) => e == v.name),
          )
          .toList(),
      disabled: disabled ?? false,
    );
    translationEngines.add(value);

    notifyListeners();
    unawaited(_writeToLocalFile());
  }

  void updateTranslationEngine(
    String id, {
    int? position,
    String? type,
    Map<String, dynamic>? option,
    List<String>? supportedScopes,
    bool? disabled,
  }) {
    final index = translationEngines.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final translationEngine = translationEngines[index];
    translationEngines[index].position = position ?? translationEngine.position;
    translationEngines[index].type = type ?? translationEngine.type;
    translationEngines[index].option = option ?? translationEngine.option;
    translationEngines[index].supportedScopes =
        (supportedScopes ?? translationEngine.supportedScopes)
            .map(
              (e) =>
                  TranslationEngineScope.values.firstWhere((v) => e == v.name),
            )
            .toList();
    translationEngines[index].disabled = disabled ?? translationEngine.disabled;
    notifyListeners();
    unawaited(_writeToLocalFile());
  }

  void deleteTranslationEngine(String id) {
    translationEngines.removeWhere((element) => element.id == id);
    notifyListeners();
    unawaited(_writeToLocalFile());
  }

  void updateOrCreateTranslationTarget({
    required String sourceLanguage,
    required String targetLanguage,
  }) {
    final index = translationTargets.indexWhere(
      (e) =>
          e.sourceLanguage == sourceLanguage &&
          e.targetLanguage == targetLanguage,
    );
    if (index != -1) {
      translationTargets[index].sourceLanguage = sourceLanguage;
      translationTargets[index].targetLanguage = targetLanguage;
    } else {
      translationTargets.add(
        TranslationTarget(
          id: shortid.generate(),
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
        ),
      );
    }

    notifyListeners();
    unawaited(_writeToLocalFile());
  }

  void deleteTranslationTarget({
    required String sourceLanguage,
    required String targetLanguage,
  }) {
    translationTargets.removeWhere(
      (e) =>
          e.sourceLanguage == sourceLanguage &&
          e.targetLanguage == targetLanguage,
    );
    notifyListeners();
    unawaited(_writeToLocalFile());
  }

  /// Update settings
  void update({
    String? defaultOcrEngineId,
    bool? autoCopyRecognizedText,
    String? defaultTranslationEngineId,
    TranslationMode? translationMode,
    String? defaultDetectLanguageEngineId,
    bool? doubleClickCopyResult,
    InputSubmitMode? inputSubmitMode,
    ThemeMode? themeMode,
    bool? trayIconEnabled,
    double? maxWindowHeight,
    String? displayLanguage,
    bool? autoStartEnabled,
    List<OcrEngineConfig>? ocrEngines,
    List<TranslationEngineConfig>? translationEngines,
    // Merge other settings
    Settings? settings,
  }) {
    this.defaultOcrEngineId = defaultOcrEngineId ??
        settings?.defaultOcrEngineId ??
        this.defaultOcrEngineId;
    this.autoCopyRecognizedText = autoCopyRecognizedText ??
        settings?.autoCopyRecognizedText ??
        this.autoCopyRecognizedText;
    this.defaultTranslationEngineId = defaultTranslationEngineId ??
        settings?.defaultTranslationEngineId ??
        this.defaultTranslationEngineId;
    this.translationMode =
        translationMode ?? settings?.translationMode ?? this.translationMode;
    this.defaultDetectLanguageEngineId = defaultDetectLanguageEngineId ??
        settings?.defaultDetectLanguageEngineId ??
        this.defaultDetectLanguageEngineId;
    this.doubleClickCopyResult = doubleClickCopyResult ??
        settings?.doubleClickCopyResult ??
        this.doubleClickCopyResult;
    this.inputSubmitMode =
        inputSubmitMode ?? settings?.inputSubmitMode ?? this.inputSubmitMode;
    this.themeMode = themeMode ?? settings?.themeMode ?? this.themeMode;
    this.trayIconEnabled =
        trayIconEnabled ?? settings?.trayIconEnabled ?? this.trayIconEnabled;
    this.maxWindowHeight =
        maxWindowHeight ?? settings?.maxWindowHeight ?? this.maxWindowHeight;
    this.displayLanguage =
        displayLanguage ?? settings?.displayLanguage ?? this.displayLanguage;
    this.autoStartEnabled =
        autoStartEnabled ?? settings?.autoStartEnabled ?? this.autoStartEnabled;
    this.ocrEngines = ocrEngines ?? settings?.ocrEngines ?? this.ocrEngines;
    this.translationEngines = translationEngines ??
        settings?.translationEngines ??
        this.translationEngines;

    notifyListeners();
    unawaited(_writeToLocalFile());
  }

  /// Load settings from local file
  Future<void> _readFromLocalFile() async {
    // Migrate old settings
    final oldSettingsMigratedFile = await _getOldSettingsMigratedFile();
    if (!oldSettingsMigratedFile.existsSync()) {
      await migrateOldSettings(this);
      await _writeToLocalFile();
      oldSettingsMigratedFile.writeAsStringSync(
        jsonEncode({'timestamp': DateTime.now().millisecondsSinceEpoch}),
      );
    }

    final settingsFile = await _getSettingsFile();
    if (settingsFile.existsSync()) {
      final json = jsonDecode(settingsFile.readAsStringSync());
      SettingsBase settings = SettingsBase.fromJson(json);
      defaultOcrEngineId = settings.defaultOcrEngineId;
      autoCopyRecognizedText = settings.autoCopyRecognizedText;
      defaultTranslationEngineId = settings.defaultTranslationEngineId;
      translationMode = instance.translationMode;
      defaultDetectLanguageEngineId = settings.defaultDetectLanguageEngineId;
      doubleClickCopyResult = settings.doubleClickCopyResult;
      inputSubmitMode = settings.inputSubmitMode;
      themeMode = settings.themeMode;
      trayIconEnabled = settings.trayIconEnabled;
      maxWindowHeight = settings.maxWindowHeight;
      displayLanguage = settings.displayLanguage;
      autoStartEnabled = settings.autoStartEnabled;
      ocrEngines = settings.ocrEngines;
      translationEngines = settings.translationEngines;
    }
  }

  /// Write to local file
  Future<void> _writeToLocalFile() async {
    const encoder = JsonEncoder.withIndent('  ');
    final settingsFile = await _getSettingsFile();
    settingsFile.writeAsStringSync(encoder.convert(toJson()));
  }
}
