import 'package:biyi_advanced_features/models/models.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/pages/translation_engine_create_or_edit/translation_engine_create_or_edit.dart';
import 'package:biyi_app/pages/translation_engine_type_chooser/translation_engine_type_chooser.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class TextTranslationsSettingPage extends StatefulWidget {
  const TextTranslationsSettingPage({super.key});

  @override
  State<TextTranslationsSettingPage> createState() =>
      _TextTranslationsSettingPageState();
}

class _TextTranslationsSettingPageState
    extends State<TextTranslationsSettingPage> {
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

  void _handleClickAdd() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TranslationEngineTypeChooserPage(
          engineType: null,
          onChoosed: (String engineType) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => TranslationEngineCreateOrEditPage(
                  engineType: engineType,
                ),
              ),
            );
          },
        ),
      ),
    );
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TranslationEngineCreateOrEditPage(
                    engineConfig: item,
                    editable: false,
                  ),
                ),
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
      title: Text(
        LocaleKeys.app_settings_text_translations_private_title.tr(),
      ),
      description: Text(
        LocaleKeys.app_settings_text_translations_private_description.tr(),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TranslationEngineCreateOrEditPage(
                              engineConfig: item,
                            ),
                          ),
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
    return PreferenceList(
      children: [
        _buildListSectionProEngines(context),
        _buildListSectionPrivateEngines(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.app_settings_text_translations_title.tr()),
      ),
      body: _buildBody(context),
    );
  }
}
