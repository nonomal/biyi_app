import 'package:flutter/material.dart' show ThemeMode;
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

enum TranslationMode {
  auto,
  manual,
}

enum InputSubmitMode {
  enter,
  metaEnter,
}

@JsonSerializable()
class Settings {
  Settings({
    this.autoCopyDetectedText = true,
    this.translationMode,
    this.doubleClickCopyResult = true,
    this.inputSubmitMode = InputSubmitMode.enter,
    this.themeMode = ThemeMode.light,
    this.trayIconEnabled = true,
    this.maxWindowHeight = 800,
    this.displayLanguage,
    this.autoStartEnabled = false,
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  // #region 通用

  /// 自动复制检测到的文本
  bool autoCopyDetectedText;

  /// 翻译模式
  TranslationMode? translationMode;

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

  // #endregion

  // #region 文本翻译

  // #endregion

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
