// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/extension/hotkey.dart';
import 'package:biyi_app/generated/codegen_loader.g.dart';
import 'package:biyi_app/services/local_db/local_db.dart';
import 'package:biyi_app/states/actions/translate_input_content.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/utils/env.dart';
import 'package:biyi_app/utils/language_util.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:open_colors/open_colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:protocol_handler/protocol_handler.dart';
import 'package:provider/provider.dart';
import 'package:uni_platform/uni_platform.dart';
import 'package:window_manager/window_manager.dart';

const String _kDefaultFontFamily = 'Inter';

const TextStyle _kBodyLargeTextStyle = TextStyle(
  fontFamily: _kDefaultFontFamily,
  color: Colors.black,
  fontSize: 16,
  height: 20 / 16,
);

const TextStyle _kBodyMediumTextStyle = TextStyle(
  fontFamily: _kDefaultFontFamily,
  color: Colors.black,
  fontSize: 14,
  height: 18 / 14,
);

const TextStyle _kBodySmallTextStyle = TextStyle(
  fontFamily: _kDefaultFontFamily,
  color: Colors.black,
  fontSize: 12,
  height: 16 / 12,
);

const TextStyle _kLabelLargeTextStyle = TextStyle(
  fontFamily: _kDefaultFontFamily,
  fontWeight: FontWeight.w600,
  color: Colors.black,
  fontSize: 14,
  height: 18 / 14,
);

const TextStyle _kLabelMediumTextStyle = TextStyle(
  fontFamily: _kDefaultFontFamily,
  fontWeight: FontWeight.w600,
  color: Colors.black,
  fontSize: 12,
  height: 16 / 12,
);

const TextStyle _kLabelSmallTextStyle = TextStyle(
  fontFamily: _kDefaultFontFamily,
  fontWeight: FontWeight.w600,
  color: Colors.black,
  fontSize: 10,
  height: 14 / 10,
);

final _lightThemeBase = ThemeData.light();

final _lightTheme = _lightThemeBase.copyWith(
  colorScheme: _lightThemeBase.colorScheme.copyWith(
    primary: OpenColors.indigo,
  ),
  textTheme: _lightThemeBase.textTheme.copyWith(
    bodyLarge: _kBodyLargeTextStyle,
    bodyMedium: _kBodyMediumTextStyle,
    bodySmall: _kBodySmallTextStyle,
    labelLarge: _kLabelLargeTextStyle,
    labelMedium: _kLabelMediumTextStyle,
    labelSmall: _kLabelSmallTextStyle,
  ),
);

final _darkThemeBase = ThemeData.dark();

final _darkTheme = _darkThemeBase.copyWith(
  colorScheme: _lightThemeBase.colorScheme.copyWith(
    primary: OpenColors.indigo,
  ),
  textTheme: _darkThemeBase.textTheme.copyWith(
    bodyLarge: _kBodyLargeTextStyle,
    bodyMedium: _kBodyMediumTextStyle,
    bodySmall: _kBodySmallTextStyle,
    labelLarge: _kLabelLargeTextStyle,
    labelMedium: _kLabelMediumTextStyle,
    labelSmall: _kLabelSmallTextStyle,
  ),
);

Future<void> _ensureInitialized() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (UniPlatform.isLinux || UniPlatform.isMacOS || UniPlatform.isWindows) {
    await hotKeyManager.unregisterAll();
    await windowManager.ensureInitialized();
  }

  if (UniPlatform.isMacOS || UniPlatform.isWindows) {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    LaunchAtStartup.instance.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
    await protocolHandler.register('biyiapp');
  }

  await initEnv();
  // ignore: deprecated_member_use_from_same_package
  await initLocalDb();
  await Settings.instance.loadFromLocalFile();
}

void main() async {
  await _ensureInitialized();

  UniPlatform.call<Future<void>>(
    desktop: () async {
      const WindowOptions windowOptions = WindowOptions(
        alwaysOnTop: false,
        skipTaskbar: true,
        titleBarStyle: TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        if (UniPlatform.isMacOS) {
          await windowManager.setVisibleOnAllWorkspaces(
            true,
            visibleOnFullScreen: true,
          );
        }
      });
    },
    otherwise: () => Future(() => null),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Settings.instance),
      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale(kLanguageEN),
          Locale(kLanguageZH),
        ],
        path: 'resources/langs',
        assetLoader: const CodegenLoader(),
        fallbackLocale: const Locale(kLanguageEN),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final botToastBuilder = BotToastInit();

  Widget _buildApp(BuildContext context) {
    final settings = context.watch<Settings>();
    if (context.locale != settings.locale) {
      context.setLocale(settings.locale);
    }
    return MaterialApp.router(
      routerConfig: routerConfig,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: settings.themeMode,
      builder: (context, child) {
        if (UniPlatform.isLinux || UniPlatform.isWindows) {
          child = Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  topRight: Radius.circular(7),
                ),
                child: child,
              ),
              const DragToMoveArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 34,
                ),
              ),
            ],
          );
        }
        child = botToastBuilder(context, child);
        return child;
      },
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final boundShortcuts = Settings.instance.boundShortcuts;

    final translateInputContentSingleActivator =
        boundShortcuts.translateInputContent.singleActivator;
    return Actions(
      actions: <Type, Action<Intent>>{
        TranslateInputContentIntent: TranslateInputContentAction(),
      },
      child: GlobalShortcuts(
        shortcuts: {
          translateInputContentSingleActivator: TranslateInputContentIntent(),
        },
        child: _buildApp(context),
      ),
    );
  }
}
