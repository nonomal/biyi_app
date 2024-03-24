import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/includes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:influxui/influxui.dart';

class OcrEngineTypesPage extends StatefulWidget {
  const OcrEngineTypesPage({
    super.key,
    this.selectedEngineType,
  });

  final String? selectedEngineType;

  @override
  State<OcrEngineTypesPage> createState() => _OcrEngineTypesPageState();
}

class _OcrEngineTypesPageState extends State<OcrEngineTypesPage> {
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
      title: Text(LocaleKeys.app_ocr_engine_types_title.tr()),
      actions: [
        CustomAppBarActionItem(
          text: LocaleKeys.ok.tr(),
          onPressed: _handleClickOk,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        PreferenceListSection.insetGrouped(
          hasLeading: false,
          children: [
            for (var engineType in kSupportedOcrEngineTypes)
              PreferenceListTile(
                leading: OcrEngineIcon(engineType),
                title: Text('ocr_engine.$engineType'.tr()),
                additionalInfo: _selectedEngineType == engineType
                    ? Icon(
                        FluentIcons.checkmark_circle_16_filled,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
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
