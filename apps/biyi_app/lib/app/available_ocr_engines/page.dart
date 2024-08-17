import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/services/api_client.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:biyi_app/widgets/list_section.dart';
import 'package:biyi_app/widgets/list_tile.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:reflect_ui/reflect_ui.dart';

class AvailableOcrEnginesPage extends StatefulWidget {
  const AvailableOcrEnginesPage({
    super.key,
    this.selectedEngineId,
  });

  final String? selectedEngineId;

  @override
  State<StatefulWidget> createState() => _AvailableOcrEnginesPageState();
}

class _AvailableOcrEnginesPageState extends State<AvailableOcrEnginesPage> {
  List<OcrEngineConfig> get _proOcrEngineList {
    return Settings.instance.proOcrEngines.list(where: ((e) => !e.disabled));
  }

  List<OcrEngineConfig> get _privateOcrEngineList {
    return Settings.instance.privateOcrEngines
        .list(where: ((e) => !e.disabled));
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
        Settings.instance.privateOcrEngine(_selectedEngineId).get() ??
            Settings.instance.proOcrEngine(_selectedEngineId).get();
    context.pop<OcrEngineConfig?>(ocrEngineConfig);
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        if (_proOcrEngineList.isNotEmpty)
          ListSection(
            children: [
              for (var ocrEngineConfig in _proOcrEngineList)
                ListTile(
                  leading: OcrEngineIcon(ocrEngineConfig.type),
                  title: OcrEngineName(ocrEngineConfig),
                  additionalInfo: ocrEngineConfig.id == _selectedEngineId
                      ? const Icon(
                          FluentIcons.checkmark_circle_16_filled,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedEngineId = ocrEngineConfig.id;
                    });
                  },
                ),
            ],
          ),
        ListSection(
          header: Text(
            LocaleKeys.app_ocr_engines_private_title.tr(),
          ),
          children: [
            for (var ocrEngineConfig in _privateOcrEngineList)
              ListTile(
                leading: OcrEngineIcon(ocrEngineConfig.type),
                title: OcrEngineName(ocrEngineConfig),
                additionalInfo: ocrEngineConfig.id == _selectedEngineId
                    ? const Icon(
                        FluentIcons.checkmark_circle_16_filled,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _selectedEngineId = ocrEngineConfig.id;
                  });
                },
              ),
            if (_privateOcrEngineList.isEmpty)
              ListTile(
                title: Text(
                  LocaleKeys.app_ocr_engines__msg_no_available_engines.tr(),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizedAppBar(
        title: Text(
          LocaleKeys.app_ocr_engines_title.tr(),
        ),
        actions: [
          Button(
            variant: ButtonVariant.filled,
            onPressed: _handleClickOk,
            child: Text(LocaleKeys.ok.tr()),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }
}
