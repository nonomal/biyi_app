// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas

part of 'settings_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsBase _$SettingsBaseFromJson(Map<String, dynamic> json) => SettingsBase(
      defaultOcrEngineId: json['defaultOcrEngineId'] as String?,
      autoCopyRecognizedText: json['autoCopyRecognizedText'] as bool? ?? true,
      defaultTranslationEngineId: json['defaultTranslationEngineId'] as String?,
      translationMode: $enumDecodeNullable(
              _$TranslationModeEnumMap, json['translationMode']) ??
          TranslationMode.manual,
      defaultDetectLanguageEngineId:
          json['defaultDetectLanguageEngineId'] as String?,
      translationTargets: (json['translationTargets'] as List<dynamic>?)
              ?.map(
                  (e) => TranslationTarget.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      doubleClickCopyResult: json['doubleClickCopyResult'] as bool? ?? true,
      inputSubmitMode: $enumDecodeNullable(
              _$InputSubmitModeEnumMap, json['inputSubmitMode']) ??
          InputSubmitMode.enter,
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.light,
      trayIconEnabled: json['trayIconEnabled'] as bool? ?? true,
      maxWindowHeight: (json['maxWindowHeight'] as num?)?.toDouble() ?? 800,
      displayLanguage: json['displayLanguage'] as String?,
      autoStartEnabled: json['autoStartEnabled'] as bool? ?? false,
      ocrEngines: (json['ocrEngines'] as List<dynamic>?)
              ?.map((e) => OcrEngineConfig.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      translationEngines: (json['translationEngines'] as List<dynamic>?)
              ?.map((e) =>
                  TranslationEngineConfig.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SettingsBaseToJson(SettingsBase instance) =>
    <String, dynamic>{
      'defaultOcrEngineId': instance.defaultOcrEngineId,
      'autoCopyRecognizedText': instance.autoCopyRecognizedText,
      'defaultTranslationEngineId': instance.defaultTranslationEngineId,
      'translationMode': _$TranslationModeEnumMap[instance.translationMode]!,
      'defaultDetectLanguageEngineId': instance.defaultDetectLanguageEngineId,
      'translationTargets': instance.translationTargets,
      'doubleClickCopyResult': instance.doubleClickCopyResult,
      'inputSubmitMode': _$InputSubmitModeEnumMap[instance.inputSubmitMode]!,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'trayIconEnabled': instance.trayIconEnabled,
      'maxWindowHeight': instance.maxWindowHeight,
      'displayLanguage': instance.displayLanguage,
      'autoStartEnabled': instance.autoStartEnabled,
      'ocrEngines': instance.ocrEngines,
      'translationEngines': instance.translationEngines,
    };

const _$TranslationModeEnumMap = {
  TranslationMode.auto: 'auto',
  TranslationMode.manual: 'manual',
};

const _$InputSubmitModeEnumMap = {
  InputSubmitMode.enter: 'enter',
  InputSubmitMode.metaEnter: 'metaEnter',
};

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
