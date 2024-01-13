import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TextTranslationsPage extends StatefulWidget {
  const TextTranslationsPage({
    super.key,
    this.selectedEngineId,
  });

  final String? selectedEngineId;

  @override
  State<StatefulWidget> createState() => _TextTranslationsPageState();
}

class _TextTranslationsPageState extends State<TextTranslationsPage> {
  List<TranslationEngineConfig> get _proEngineList {
    return localDb.proEngines.list(where: ((e) => !e.disabled));
  }

  List<TranslationEngineConfig> get _privateEngineList {
    return localDb.privateEngines.list(where: ((e) => !e.disabled));
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
    TranslationEngineConfig? engineConfig =
        localDb.engine(_selectedEngineId).get();
    context.pop<TranslationEngineConfig?>(engineConfig);
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        if (_proEngineList.isNotEmpty)
          PreferenceListSection(
            children: [
              for (var engineConfig in _proEngineList)
                PreferenceListRadioItem<String>(
                  icon: TranslationEngineIcon(engineConfig.type),
                  title: TranslationEngineName(engineConfig),
                  value: engineConfig.identifier,
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
            LocaleKeys.app_text_translations_private_title.tr(),
          ),
          children: [
            for (var engineConfig in _privateEngineList)
              PreferenceListRadioItem<String>(
                icon: TranslationEngineIcon(engineConfig.type),
                title: TranslationEngineName(engineConfig),
                value: engineConfig.identifier,
                groupValue: _selectedEngineId ?? '',
                onChanged: (newValue) {
                  setState(() {
                    _selectedEngineId = newValue;
                  });
                },
              ),
            if (_privateEngineList.isEmpty)
              PreferenceListItem(
                title: Text(
                  LocaleKeys.app_text_translations__msg_no_available_engines
                      .tr(),
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
          LocaleKeys.app_text_translations_title.tr(),
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
