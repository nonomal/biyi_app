import 'dart:io';

import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/codegen_loader.g.dart';
import 'package:biyi_app/includes.dart';
import 'package:biyi_app/providers/providers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:protocol_handler/protocol_handler.dart';
import 'package:provider/provider.dart';
import 'package:rise_ui/rise_ui.dart';
import 'package:window_manager/window_manager.dart';

Future<void> _ensureInitialized() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (kIsLinux || kIsMacOS || kIsWindows) {
    await windowManager.ensureInitialized();
  }

  if (kIsMacOS || kIsWindows) {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    LaunchAtStartup.instance.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
    await protocolHandler.register('biyiapp');
  }

  await initEnv();
  await initLocalDb();
}

void main() async {
  await _ensureInitialized();

  if (!kIsWeb) {
    const WindowOptions windowOptions = WindowOptions(
      alwaysOnTop: false,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      if (kIsMacOS) {
        await windowManager.setVisibleOnAllWorkspaces(
          true,
          visibleOnFullScreen: true,
        );
      }
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettings()),
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
  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    final AppSettings appSettings = context.watch<AppSettings>();

    return MaterialApp.router(
      routerConfig: routerConfig,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: appSettings.themeMode,
      builder: (context, child) {
        if (kIsLinux || kIsWindows) {
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
        child = ExtendedTheme(
          data: ExtendedThemeData(
            brightness: appSettings.themeMode == ThemeMode.dark
                ? Brightness.dark
                : Brightness.light,
            primaryColor: ExtendedColors.indigo,
          ),
          child: child,
        );
        return child;
      },
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
