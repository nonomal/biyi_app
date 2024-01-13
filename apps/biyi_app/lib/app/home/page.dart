import 'package:biyi_app/app/home/desktop_popup.dart';
import 'package:biyi_app/utilities/platform_util.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsLinux || kIsMacOS || kIsWindows) {
      return const DesktopPopupPage();
    }
    return const Scaffold(
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
