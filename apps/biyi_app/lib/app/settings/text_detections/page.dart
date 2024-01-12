import 'package:biyi_advanced_features/models/models.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/pages/pages.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class TextDetectionsSettingPage extends StatefulWidget {
  const TextDetectionsSettingPage({super.key});

  @override
  State<TextDetectionsSettingPage> createState() =>
      _TextDetectionsSettingPageState();
}

class _TextDetectionsSettingPageState extends State<TextDetectionsSettingPage> {
  List<OcrEngineConfig> get _proOcrEngineList => (localDb.proOcrEngines.list());
  List<OcrEngineConfig> get _privateOcrEngineList =>
      (localDb.privateOcrEngines.list());

  @override
  void initState() {
    localDb.privateOcrEngines.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.privateOcrEngines.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  void _handleClickAdd() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OcrEngineTypeChooserPage(
          engineType: null,
          onChoosed: (String ocrEngineType) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => OcrEngineCreateOrEditPage(
                  ocrEngineType: ocrEngineType,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListSectionProEngines(BuildContext context) {
    if (_proOcrEngineList.isEmpty) return Container();
    return PreferenceListSection(
      children: [
        for (OcrEngineConfig item in _proOcrEngineList)
          PreferenceListSwitchItem(
            icon: OcrEngineIcon(item.type),
            title: OcrEngineName(item),
            value: !item.disabled,
            onChanged: (newValue) {
              localDb //
                  .proOcrEngine(item.identifier)
                  .update(disabled: !item.disabled);
            },
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OcrEngineCreateOrEditPage(
                    ocrEngineConfig: item,
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
          _privateOcrEngineList.map((e) => e.identifier).toList();
      String oldId = idList.removeAt(oldIndex);
      idList.insert(newIndex, oldId);

      for (var i = 0; i < idList.length; i++) {
        final identifier = idList[i];
        localDb //
            .privateOcrEngine(identifier)
            .update(position: i + 1);
      }
    }

    return PreferenceListSection(
      title: Text(
        LocaleKeys.app_settings_text_detections_private_title.tr(),
      ),
      description: Text(
        LocaleKeys.app_settings_text_detections_private_description.tr(),
      ),
      children: [
        ReorderableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          onReorder: onReorder,
          children: [
            for (var i = 0; i < _privateOcrEngineList.length; i++)
              ReorderableWidget(
                reorderable: true,
                key: ValueKey(i),
                child: Builder(
                  builder: (_) {
                    final item = _privateOcrEngineList[i];
                    return PreferenceListSwitchItem(
                      icon: OcrEngineIcon(item.type),
                      title: OcrEngineName(item),
                      value: !item.disabled,
                      onChanged: (newValue) {
                        localDb //
                            .privateOcrEngine(item.identifier)
                            .update(disabled: !item.disabled);
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OcrEngineCreateOrEditPage(
                              ocrEngineConfig: item,
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
        title: Text(LocaleKeys.app_settings_text_detections_title.tr()),
      ),
      body: _buildBody(context),
    );
  }
}
