// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      autoCopyDetectedText: json['autoCopyDetectedText'] as bool? ?? true,
      translationMode: $enumDecodeNullable(
          _$TranslationModeEnumMap, json['translationMode']),
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
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'autoCopyDetectedText': instance.autoCopyDetectedText,
      'translationMode': _$TranslationModeEnumMap[instance.translationMode],
      'doubleClickCopyResult': instance.doubleClickCopyResult,
      'inputSubmitMode': _$InputSubmitModeEnumMap[instance.inputSubmitMode]!,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'trayIconEnabled': instance.trayIconEnabled,
      'maxWindowHeight': instance.maxWindowHeight,
      'displayLanguage': instance.displayLanguage,
      'autoStartEnabled': instance.autoStartEnabled,
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
