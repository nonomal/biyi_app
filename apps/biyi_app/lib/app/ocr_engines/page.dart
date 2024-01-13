import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/includes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OcrEnginesPage extends StatefulWidget {
  const OcrEnginesPage({
    super.key,
    this.selectedEngineId,
  });

  final String? selectedEngineId;

  @override
  State<StatefulWidget> createState() => _OcrEnginesPageState();
}

class _OcrEnginesPageState extends State<OcrEnginesPage> {
  List<OcrEngineConfig> get _proOcrEngineList {
    return localDb.proOcrEngines.list(where: ((e) => !e.disabled));
  }

  List<OcrEngineConfig> get _privateOcrEngineList {
    return localDb.privateOcrEngines.list(where: ((e) => !e.disabled));
  }

  String? _selectedEngineId;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedEngineId = widget.selectedEngineId;
    });
  }

  Future<void> _handleClickOk() async {
    OcrEngineConfig? ocrEngineConfig =
        localDb.ocrEngine(_selectedEngineId).get();
    context.pop<OcrEngineConfig?>(ocrEngineConfig);
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        if (_proOcrEngineList.isNotEmpty)
          PreferenceListSection(
            children: [
              for (var ocrEngineConfig in _proOcrEngineList)
                PreferenceListRadioItem<String>(
                  icon: OcrEngineIcon(ocrEngineConfig.type),
                  title: OcrEngineName(ocrEngineConfig),
                  value: ocrEngineConfig.identifier,
                  groupValue: _selectedEngineId ?? '',
                  onChanged: (newValue) {
                    setState(() {
                      _selectedEngineId = newValue;
                    });
                  },
                ),
            ],
          ),
        PreferenceListSection(
          title: Text(
            LocaleKeys.app_ocr_engines_private_title.tr(),
          ),
          children: [
            for (var ocrEngineConfig in _privateOcrEngineList)
              PreferenceListRadioItem<String>(
                icon: OcrEngineIcon(ocrEngineConfig.type),
                title: OcrEngineName(ocrEngineConfig),
                value: ocrEngineConfig.identifier,
                groupValue: _selectedEngineId ?? '',
                onChanged: (newValue) {
                  setState(() {
                    _selectedEngineId = newValue;
                  });
                },
              ),
            if (_privateOcrEngineList.isEmpty)
              PreferenceListItem(
                title: Text(
                  LocaleKeys.app_ocr_engines__msg_no_available_engines.tr(),
                ),
                accessoryView: Container(),
              ),
          ],
        ),
      ],
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          LocaleKeys.app_ocr_engines_private_title.tr(),
        ),
        actions: [
          CustomAppBarActionItem(
            text: LocaleKeys.ok.tr(),
            onPressed: _handleClickOk,
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
