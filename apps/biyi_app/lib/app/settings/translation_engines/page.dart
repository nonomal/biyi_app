import 'package:biyi_advanced_features/models/models.dart';
import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reorderables/reorderables.dart';
import 'package:rise_ui/rise_ui.dart';

class TranslationEnginesSettingPage extends StatefulWidget {
  const TranslationEnginesSettingPage({super.key});

  @override
  State<TranslationEnginesSettingPage> createState() =>
      _TranslationEnginesSettingPageState();
}

class _TranslationEnginesSettingPageState
    extends State<TranslationEnginesSettingPage> {
  List<TranslationEngineConfig> get _proEngineList =>
      (localDb.proEngines.list());
  List<TranslationEngineConfig> get _privateEngineList =>
      (localDb.privateEngines.list());

  @override
  void initState() {
    localDb.privateEngines.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.privateEngines.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _handleClickAdd() async {
    final engineType = await context.push<String?>(
      PageId.translationEngineTypes,
    );
    if (engineType != null) {
      // ignore: use_build_context_synchronously
      await context.push<String?>(
        PageId.translationEnginesNew,
        extra: {
          'engineType': engineType,
        },
      );
    }
  }

  Widget _buildListSectionProEngines(BuildContext context) {
    if (_proEngineList.isEmpty) return Container();
    return PreferenceListSection(
      children: [
        for (TranslationEngineConfig item in _proEngineList)
          PreferenceListSwitchItem(
            icon: TranslationEngineIcon(item.type),
            title: TranslationEngineName(item),
            value: !item.disabled,
            onChanged: (newValue) {
              localDb //
                  .proEngine(item.identifier)
                  .update(disabled: !item.disabled);
            },
            onTap: () {
              context.push<String?>(
                PageId.translationEngine(item.identifier),
                extra: {
                  'engineConfig': item,
                  'editable': false,
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildListSectionPrivateEngines(BuildContext context) {
    void onReorder(int oldIndex, int newIndex) {
      List<String> idList =
          _privateEngineList.map((e) => e.identifier).toList();
      String oldId = idList.removeAt(oldIndex);
      idList.insert(newIndex, oldId);

      for (var i = 0; i < idList.length; i++) {
        final identifier = idList[i];
        localDb //
            .privateEngine(identifier)
            .update(position: i + 1);
      }
    }

    return PreferenceListSection(
      header: Text(
        LocaleKeys.app_settings_translation_engines_private_title.tr(),
      ),
      footer: Text(
        LocaleKeys.app_settings_translation_engines_private_description.tr(),
      ),
      children: [
        ReorderableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          onReorder: onReorder,
          children: [
            for (var i = 0; i < _privateEngineList.length; i++)
              ReorderableWidget(
                reorderable: true,
                key: ValueKey(i),
                child: Builder(
                  builder: (_) {
                    final item = _privateEngineList[i];
                    return PreferenceListSwitchItem(
                      icon: TranslationEngineIcon(item.type),
                      title: TranslationEngineName(item),
                      value: !item.disabled,
                      onChanged: (newValue) {
                        localDb //
                            .privateEngine(item.identifier)
                            .update(disabled: !item.disabled);
                      },
                      onTap: () {
                        context.push<String?>(
                          PageId.translationEngine(item.identifier),
                          extra: {
                            'engineConfig': item,
                            'editable': true,
                          },
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
        PreferenceListItem(
          title: Text(
            LocaleKeys.add.tr(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          accessoryView: Container(),
          onTap: _handleClickAdd,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildListSectionProEngines(context),
        _buildListSectionPrivateEngines(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: LocaleKeys.app_settings_translation_engines_title.tr(),
      child: _buildBody(context),
    );
  }
}
