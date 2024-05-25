import 'package:biyi_advanced_features/models/models.dart';
import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:influxui/influxui.dart';
import 'package:preference_list/preference_list.dart';
import 'package:reorderables/reorderables.dart';

class OcrEnginesSettingPage extends StatefulWidget {
  const OcrEnginesSettingPage({super.key});

  @override
  State<OcrEnginesSettingPage> createState() => _OcrEnginesSettingPageState();
}

class _OcrEnginesSettingPageState extends State<OcrEnginesSettingPage> {
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

  Future<void> _handleClickAdd() async {
    final ocrEngineType = await context.push<String?>(
      PageId.settingsOcrEngineTypes,
    );
    if (ocrEngineType != null) {
      // ignore: use_build_context_synchronously
      await context.push<String?>(
        PageId.settingsOcrEnginesNew,
        extra: {
          'ocrEngineType': ocrEngineType,
          'editable': true,
        },
      );
    }
  }

  Widget _buildListSectionProEngines(BuildContext context) {
    if (_proOcrEngineList.isEmpty) return Container();
    return PreferenceListSection(
      children: [
        for (OcrEngineConfig item in _proOcrEngineList)
          PreferenceListTile(
            leading: OcrEngineIcon(item.type),
            title: OcrEngineName(item),
            additionalInfo: Switch(
              value: !item.disabled,
              onChanged: (newValue) {
                localDb //
                    .proOcrEngine(item.identifier)
                    .update(disabled: !item.disabled);
              },
            ),
            onTap: () {
              context.push<String?>(
                PageId.settingsOcrEngine(item.identifier),
                extra: {
                  'ocrEngineConfig': item,
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
      header: Text(
        LocaleKeys.app_settings_ocr_engines_private_title.tr(),
      ),
      footer: Text(
        LocaleKeys.app_settings_ocr_engines_private_description.tr(),
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
                    return PreferenceListTile(
                      leading: OcrEngineIcon(item.type),
                      title: OcrEngineName(item),
                      additionalInfo: Switch(
                        value: !item.disabled,
                        onChanged: (newValue) {
                          localDb //
                              .privateOcrEngine(item.identifier)
                              .update(disabled: !item.disabled);
                        },
                      ),
                      onTap: () {
                        context.push<String?>(
                          PageId.settingsOcrEngine(item.identifier),
                          extra: {
                            'ocrEngineConfig': item,
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
      appBar: AppBar(
        title: Text(LocaleKeys.app_settings_ocr_engines_title.tr()),
      ),
      body: _buildBody(context),
    );
  }
}
