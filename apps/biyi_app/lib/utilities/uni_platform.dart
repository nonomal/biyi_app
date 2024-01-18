import 'dart:io';

import 'package:flutter/foundation.dart';

class UniPlatform {
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isWeb => kIsWeb;

  static T select<T>({
    // 根据平台选择
    T Function()? android,
    T Function()? iOS,
    T Function()? linux,
    T Function()? macOS,
    T Function()? windows,
    T Function()? web,
    // 根据平台类型选择
    T Function()? desktop,
    T Function()? mobile,
    // 无匹配
    T Function()? otherwise,
  }) {
    final isDesktop = isLinux || isMacOS || isWindows;
    final isMobile = isAndroid || isIOS;
    if (isAndroid && android != null) {
      return android();
    } else if (isIOS && iOS != null) {
      return iOS();
    } else if (isLinux && linux != null) {
      return linux();
    } else if (isMacOS && macOS != null) {
      return macOS();
    } else if (isWindows && windows != null) {
      return windows();
    } else if (isWeb && web != null) {
      return web();
    } else if (isDesktop && desktop != null) {
      return desktop();
    } else if (isMobile && mobile != null) {
      return mobile();
    } else if (otherwise != null) {
      return otherwise();
    }
    throw Exception('No platform selected');
  }
}
