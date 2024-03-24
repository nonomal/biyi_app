// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/codegen_loader.g.dart';
import 'package:biyi_app/providers/providers.dart';
import 'package:biyi_app/services/local_db/local_db.dart';
import 'package:biyi_app/utilities/env.dart';
import 'package:biyi_app/utilities/language_util.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:influxui/influxui.dart';
import 'package:influxui/themes.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:protocol_handler/protocol_handler.dart';
import 'package:provider/provider.dart';
import 'package:uni_platform/uni_platform.dart';
import 'package:window_manager/window_manager.dart';

class TablerIconLibrary extends IconLibrary {
  @override
  IconData get chevron_left => FluentIcons.chevron_left_20_regular;

  @override
  IconData get chevron_right => FluentIcons.chevron_right_20_regular;

  @override
  IconData get square => FluentIcons.square_20_regular;

  @override
  IconData get light_mode => FluentIcons.square_20_regular;

  @override
  IconData get dark_mode => FluentIcons.square_20_regular;
}

Future<void> _ensureInitialized() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  ExtendedIcons.iconLibrary = TablerIconLibrary();
  if (UniPlatform.isLinux || UniPlatform.isMacOS || UniPlatform.isWindows) {
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
  await initLocalDb();
}

void main() async {
  await _ensureInitialized();

  UniPlatform.call<Future<void>>(
    desktop: () async {
      const WindowOptions windowOptions = WindowOptions(
        alwaysOnTop: false,
        skipTaskbar: false,
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
      theme: influxLight,
      darkTheme: influxDark,
      themeMode: appSettings.themeMode,
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
        child = ExtendedTheme(
          data: ExtendedThemeData(
            brightness: appSettings.themeMode == ThemeMode.dark
                ? Brightness.dark
                : Brightness.light,
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
