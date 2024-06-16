import 'package:biyi_advanced_features/models/models.dart';
import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:influxui/influxui.dart';
import 'package:preference_list/preference_list.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class TranslationEnginesSettingPage extends StatefulWidget {
  const TranslationEnginesSettingPage({super.key});

  @override
  State<TranslationEnginesSettingPage> createState() =>
      _TranslationEnginesSettingPageState();
}

class _TranslationEnginesSettingPageState
    extends State<TranslationEnginesSettingPage> {
  Future<void> _handleClickAdd() async {
    final engineType = await context.push<String?>(
      PageId.settingsTranslationEngineTypes,
    );
    if (engineType != null) {
      // ignore: use_build_context_synchronously
      await context.push<String?>(
        PageId.settingsTranslationEnginesNew,
        extra: {
          'engineType': engineType,
          'editable': true,
        },
      );
    }
  }

  Widget _buildListSectionProEngines(BuildContext context) {
    final proTranslationEngineList =
        context.watch<Settings>().proTranslationEngines.list();
    if (proTranslationEngineList.isEmpty) return Container();
    return PreferenceListSection(
      children: [
        for (TranslationEngineConfig item in proTranslationEngineList)
          PreferenceListTile(
            leading: TranslationEngineIcon(item.type),
            title: TranslationEngineName(item),
            additionalInfo: Switch(
              value: !item.disabled,
              onChanged: (newValue) {
                context
                    .watch<Settings>() // Linewrap
                    .proTranslationEngine(item.id)
                    .update(
                      disabled: !item.disabled,
                    );
              },
            ),
            onTap: () {
              context.push<String?>(
                PageId.settingsTranslationEngine(item.id),
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
    final privateTranslationEngineList =
        context.watch<Settings>().privateTranslationEngines.list();

    void onReorder(int oldIndex, int newIndex) {
      List<String> idList =
          privateTranslationEngineList.map((e) => e.id).toList();
      String oldId = idList.removeAt(oldIndex);
      idList.insert(newIndex, oldId);

      for (var i = 0; i < idList.length; i++) {
        final id = idList[i];
        context
            .read<Settings>() // Linewrap
            .privateTranslationEngine(id)
            .update(
              position: i + 1,
            );
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
            for (var i = 0; i < privateTranslationEngineList.length; i++)
              ReorderableWidget(
                reorderable: true,
                key: ValueKey(i),
                child: Builder(
                  builder: (_) {
                    final item = privateTranslationEngineList[i];
                    return PreferenceListTile(
                      leading: TranslationEngineIcon(item.type),
                      title: TranslationEngineName(item),
                      additionalInfo: Switch(
                        value: !item.disabled,
                        onChanged: (newValue) {
                          context
                              .read<Settings>() // Linewrap
                              .privateTranslationEngine(item.id)
                              .update(
                                disabled: !item.disabled,
                              );
                        },
                      ),
                      onTap: () {
                        context.push<String?>(
                          PageId.settingsTranslationEngine(item.id),
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
        PreferenceListTile(
          title: Text(
            LocaleKeys.add.tr(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          onTap: _handleClickAdd,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildListSectionProEngines(context),
        _buildListSectionPrivateEngines(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizedAppBar(
        title: Text(LocaleKeys.app_settings_translation_engines_title.tr()),
      ),
      body: _buildBody(context),
    );
  }
}
