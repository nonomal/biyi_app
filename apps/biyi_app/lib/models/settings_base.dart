import 'package:biyi_advanced_features/models/ocr_engine_config.dart';
import 'package:biyi_advanced_features/models/translation_engine_config.dart';
import 'package:biyi_app/models/translation_target.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:json_annotation/json_annotation.dart';

part 'settings_base.g.dart';

enum TranslationMode {
  auto,
  manual;

  static TranslationMode fromString(String value) {
    switch (value) {
      case 'auto':
        return TranslationMode.auto;
      case 'manual':
        return TranslationMode.manual;
      default:
        return TranslationMode.auto;
    }
  }
}

enum InputSubmitMode {
  enter,
  metaEnter,
}

@JsonSerializable()
class SettingsBase {
  SettingsBase({
    this.defaultOcrEngineId,
    this.autoCopyRecognizedText = true,
    this.defaultTranslationEngineId,
    this.translationMode = TranslationMode.manual,
    this.defaultDetectLanguageEngineId,
    this.translationTargets = const [],
    this.doubleClickCopyResult = true,
    this.inputSubmitMode = InputSubmitMode.enter,
    this.themeMode = ThemeMode.light,
    this.trayIconEnabled = true,
    this.maxWindowHeight = 800,
    this.displayLanguage,
    this.autoStartEnabled = false,
    this.ocrEngines = const [],
    this.translationEngines = const [],
  });

  factory SettingsBase.fromJson(Map<String, dynamic> json) =>
      _$SettingsBaseFromJson(json);

  // #region 通用

  /// 默认文字识别引擎
  String? defaultOcrEngineId;

  OcrEngineConfig? get defaultOcrEngineConfig {
    return ocrEngines.firstWhereOrNull(
      (engine) => engine.id == defaultOcrEngineId,
    );
  }

  /// 自动复制检测到的文本
  bool autoCopyRecognizedText;

  /// 默认文本翻译引擎
  String? defaultTranslationEngineId;

  TranslationEngineConfig? get defaultTranslationEngineConfig {
    return translationEngines.firstWhereOrNull(
      (engine) => engine.id == defaultTranslationEngineId,
    );
  }

  /// 翻译模式
  TranslationMode translationMode;

  /// 默认语种识别引擎
  String? defaultDetectLanguageEngineId;

  TranslationEngineConfig? get defaultDetectLanguageEngineConfig {
    return translationEngines.firstWhereOrNull(
      (engine) => engine.id == defaultDetectLanguageEngineId,
    );
  }

  List<TranslationTarget> translationTargets;

  /// 双击复制结果
  bool doubleClickCopyResult;

  /// 输入提交模式
  InputSubmitMode inputSubmitMode;

  // #endregion

  // #region 外观

  /// 主题模式
  ThemeMode themeMode;

  /// 是否启用托盘图标
  bool trayIconEnabled;

  /// 最大窗口高度
  double maxWindowHeight = 800;

  // #endregion

  // #region 快捷键
  // #endregion

  // #region 语言

  /// 显示语言

  String? displayLanguage;

  // #endregion

  // #region 高级

  bool autoStartEnabled;

  // #endregion

  // #region 文字识别

  List<OcrEngineConfig> ocrEngines;

  // #endregion

  // #region 文本翻译

  List<TranslationEngineConfig> translationEngines;

  // #endregion

  Map<String, dynamic> toJson() => _$SettingsBaseToJson(this);
}
