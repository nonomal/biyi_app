import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/services/ocr_client/ocr_client.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:biyi_app/widgets/ocr_engine_icon/ocr_engine_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:reflect_ui/reflect_ui.dart';

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
    return CustomizedAppBar(
      title: Text(LocaleKeys.app_ocr_engine_types_title.tr()),
      actions: [
        Button(
          variant: ButtonVariant.filled,
          onPressed: _handleClickOk,
          child: Text(LocaleKeys.ok.tr()),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        ListSection(
          children: [
            for (var engineType in kSupportedOcrEngineTypes)
              RadioListTile<String>(
                value: engineType,
                groupValue: _selectedEngineType,
                onChanged: (value) {
                  _selectedEngineType = value;
                  setState(() {});
                },
                useCheckmarkStyle: true,
                leading: OcrEngineIcon(engineType),
                title: Text('ocr_engine.$engineType'.tr()),
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
