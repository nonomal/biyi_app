import 'package:biyi_app/includes.dart';
import 'package:biyi_app/router_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rise_ui/rise_ui.dart';

class TabHomepageScene extends StatefulWidget {
  const TabHomepageScene({super.key});

  @override
  State<StatefulWidget> createState() => _TabHomepageSceneState();
}

class _TabHomepageSceneState extends State<TabHomepageScene> {
  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Button(
          label: 'settings/general',
          onPressed: () {
            context.go(PageId.generalSetting);
          },
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return const CustomAppBar(
      title: Text('比译'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }
}
