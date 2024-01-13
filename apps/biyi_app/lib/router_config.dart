import 'package:biyi_app/app/settings/about/page.dart';
import 'package:biyi_app/app/settings/advanced/page.dart';
import 'package:biyi_app/app/settings/appearance/page.dart';
import 'package:biyi_app/app/settings/changelog/page.dart';
import 'package:biyi_app/app/settings/general/page.dart';
import 'package:biyi_app/app/settings/keybinds/page.dart';
import 'package:biyi_app/app/settings/language/page.dart';
import 'package:biyi_app/app/settings/layout.dart';
import 'package:biyi_app/app/settings/text_detections/page.dart';
import 'package:biyi_app/app/settings/text_translations/page.dart';
import 'package:biyi_app/pages/pages.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class PageId {
  static const String home = '/home';
  // 设置相关的
  static const String generalSetting = '/settings/general';
  static const String appearanceSetting = '/settings/appearance';
  static const String keybindsSetting = '/settings/keybinds';
  static const String languageSetting = '/settings/language';
  static const String advancedSetting = '/settings/advanced';
  static const String textTranslationsSetting = '/settings/text-translations';
  static const String textDetectionsSetting = '/settings/text-detections';
  static const String about = '/settings/about';
  static const String changelog = '/settings/changelog';
}

// GoRouter configuration
final routerConfig = GoRouter(
  observers: [BotToastNavigatorObserver()],
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        return '/home';
      },
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return FadeTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
        );
      },
    ),
    ShellRoute(
      pageBuilder: (context, state, child) {
        return FadeTransitionPage(
          key: state.pageKey,
          child: SettingsLayout(child: child),
        );
      },
      routes: [
        GoRoute(
          path: '/settings',
          redirect: (context, state) {
            return null;
          },
          routes: [
            GoRoute(
              path: 'about',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const AboutSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'advanced',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const AdvancedSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'appearance',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const AppearanceSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'changelog',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const ChangelogSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'general',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const GeneralSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'keybinds',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const KeybindsSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'language',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const LanguageSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'text-detections',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const TextDetectionsSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'text-translations',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const TextTranslationsSettingPage(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

/// A page that fades in an out.
class FadeTransitionPage extends CustomTransitionPage<void> {
  /// Creates a [FadeTransitionPage].
  FadeTransitionPage({
    required LocalKey super.key,
    required super.child,
  }) : super(
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation.drive(_curveTween),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 100),
          reverseTransitionDuration: const Duration(milliseconds: 100),
        );

  static final CurveTween _curveTween = CurveTween(curve: Curves.easeIn);
}
