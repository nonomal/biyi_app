import 'package:biyi_app/app/home/page.dart';
import 'package:biyi_app/app/ocr_engines/new/page.dart';
import 'package:biyi_app/app/ocr_engines/page.dart';
import 'package:biyi_app/app/settings/about/page.dart';
import 'package:biyi_app/app/settings/advanced/page.dart';
import 'package:biyi_app/app/settings/appearance/page.dart';
import 'package:biyi_app/app/settings/changelog/page.dart';
import 'package:biyi_app/app/settings/general/page.dart';
import 'package:biyi_app/app/settings/keybinds/page.dart';
import 'package:biyi_app/app/settings/language/page.dart';
import 'package:biyi_app/app/settings/layout.dart';
import 'package:biyi_app/app/settings/ocr_engine_types/page.dart';
import 'package:biyi_app/app/settings/ocr_engines/page.dart';
import 'package:biyi_app/app/settings/page.dart';
import 'package:biyi_app/app/settings/translation_engine_types/page.dart';
import 'package:biyi_app/app/settings/translation_engines/page.dart';
import 'package:biyi_app/app/supported_languages/page.dart';
import 'package:biyi_app/app/translation_engines/new/page.dart';
import 'package:biyi_app/app/translation_engines/page.dart';
import 'package:biyi_app/app/translation_targets/new/page.dart';
import 'package:biyi_app/includes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class PageId {
  static const String home = '/home';
  static const String ocrEngines = '/ocr-engines';
  static const String ocrEnginesNew = '/ocr-engines/new';
  static const String settingsGeneral = '/settings/general';
  static const String settingsAppearance = '/settings/appearance';
  static const String settingsKeybinds = '/settings/keybinds';
  static const String settingsLanguage = '/settings/language';
  static const String settingsAdvanced = '/settings/advanced';
  static const String settingsTranslationEngineTypes =
      '/settings/translation-engine-types';
  static const String settingsTranslationEngines =
      '/settings/translation-engines';
  static const String settingsOcrEngineTypes = '/settings/ocr-engine-types';
  static const String settingsOcrEngines = '/settings/ocr-engines';
  static const String settingsAbout = '/settings/about';
  static const String settingsChangelog = '/settings/changelog';
  static const String supportedLanguages = '/supported-languages';
  static const String translationEngines = '/translation-engines';
  static const String translationEnginesNew = '/translation-engines/new';
  static const String translationTargetsNew = '/translation-targets/new';

  static String ocrEngine(String id) => '/ocr-engines/$id';
  static String translationEngine(String id) => '/translation-engines/$id';
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
    GoRoute(
      path: '/ocr-engines',
      builder: (context, state) {
        return OcrEnginesPage(
          selectedEngineId: state.uri.queryParameters['selectedEngineId'],
        );
      },
    ),
    GoRoute(
      path: '/ocr-engines/new',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return OcrEnginesNewOrEditPage(
          ocrEngineType: extra?['ocrEngineType'],
        );
      },
    ),
    GoRoute(
      path: '/ocr-engines/:id',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return OcrEnginesNewOrEditPage(
          ocrEngineConfig: extra?['ocrEngineConfig'],
          editable: extra?['editable'],
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
          builder: (kIsAndroid || kIsIOS)
              ? (context, state) {
                  return const SettingsPage();
                }
              : null,
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
              path: 'ocr-engine-types',
              builder: (context, state) {
                return const OcrEngineTypesPage();
              },
            ),
            GoRoute(
              path: 'ocr-engines',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const OcrEnginesSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'translation-engine-types',
              builder: (context, state) {
                return const TranslationEngineTypesPage();
              },
            ),
            GoRoute(
              path: 'translation-engines',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const TranslationEnginesSettingPage(),
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/supported-languages',
      builder: (context, state) {
        return SupportedLanguagesPage(
          selectedLanguage: state.uri.queryParameters['selectedLanguage'],
        );
      },
    ),
    GoRoute(
      path: '/translation-engines',
      builder: (context, state) {
        return TranslationEnginesPage(
          selectedEngineId: state.uri.queryParameters['selectedEngineId'],
        );
      },
    ),
    GoRoute(
      path: '/translation-engines/new',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return TranslationEnginesNewOrEditPage(
          engineType: extra?['engineType'],
          editable: extra?['editable'],
        );
      },
    ),
    GoRoute(
      path: '/translation-engines/:id',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return TranslationEnginesNewOrEditPage(
          engineConfig: extra?['engineConfig'],
          editable: extra?['editable'],
        );
      },
    ),
    GoRoute(
      path: '/translation-targets/new',
      builder: (context, state) {
        return const TranslationTargetNewPage();
      },
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
