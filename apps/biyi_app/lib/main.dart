// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/extension/hotkey.dart';
import 'package:biyi_app/i18n/strings.g.dart';
import 'package:biyi_app/services/local_db/local_db.dart';
import 'package:biyi_app/states/actions/translate_input_content.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/utils/env.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:protocol_handler/protocol_handler.dart';
import 'package:provider/provider.dart';
import 'package:reflect_ui/reflect_ui.dart';
import 'package:uni_platform/uni_platform.dart';
import 'package:window_manager/window_manager.dart';

Future<void> _ensureInitialized() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    TranslationProvider(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Settings.instance),
        ],
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
    return MaterialApp.router(
      routerConfig: routerConfig,
      themeMode: settings.themeMode,
      builder: (context, child) {
        Brightness brightness = Theme.of(context).brightness;
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
        child = DesignTheme(
          data: brightness == Brightness.light
              ? DesignThemeData.lightCompact(
                  iconLibrary: const IconLibrary(
                    chevronLeft: FluentIcons.chevron_left_16_regular,
                    chevronRight: FluentIcons.chevron_right_16_regular,
                  ),
                )
              : DesignThemeData.darkCompact(
                  iconLibrary: const IconLibrary(
                    chevronLeft: FluentIcons.chevron_left_16_regular,
                    chevronRight: FluentIcons.chevron_right_16_regular,
                  ),
                ),
          child: child!,
        );
        child = botToastBuilder(context, child);
        return child;
      },
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      debugShowCheckedModeBanner: false,
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
