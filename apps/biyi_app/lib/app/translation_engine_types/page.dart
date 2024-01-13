import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/includes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TranslationEngineTypesPage extends StatefulWidget {
  const TranslationEngineTypesPage({
    super.key,
    this.selectedEngineType,
  });

  final String? selectedEngineType;

  @override
  State<TranslationEngineTypesPage> createState() =>
      _TranslationEngineTypesPageState();
}

class _TranslationEngineTypesPageState
    extends State<TranslationEngineTypesPage> {
  String? _selectedEngineType;

  @override
  void initState() {
    _selectedEngineType = widget.selectedEngineType;
    super.initState();
  }

  Future<void> _handleClickOk() async {
    context.pop<String?>(_selectedEngineType);
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: Text(LocaleKeys.app_translation_engine_types_title.tr()),
      actions: [
        CustomAppBarActionItem(
          text: LocaleKeys.ok.tr(),
          onPressed: _handleClickOk,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        PreferenceListSection(
          children: [
            for (var engineType in kSupportedEngineTypes)
              PreferenceListRadioItem(
                icon: TranslationEngineIcon(engineType),
                title: Text('engine.$engineType'.tr()),
                value: engineType,
                groupValue: _selectedEngineType,
                onChanged: (newGroupValue) {
                  _selectedEngineType = engineType;
                  setState(() {});
                },
              ),
          ],
        ),
      ],
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
