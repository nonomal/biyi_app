import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/services/api_client.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:reflect_ui/reflect_ui.dart';

class AvailableTranslationEnginesPage extends StatefulWidget {
  const AvailableTranslationEnginesPage({
    super.key,
    this.selectedEngineId,
  });

  final String? selectedEngineId;

  @override
  State<StatefulWidget> createState() =>
      _AvailableTranslationEnginesPageState();
}

class _AvailableTranslationEnginesPageState
    extends State<AvailableTranslationEnginesPage> {
  List<TranslationEngineConfig> get _proEngineList {
    return Settings.instance.proTranslationEngines
        .list(where: ((e) => !e.disabled));
  }

  List<TranslationEngineConfig> get _privateEngineList {
    return Settings.instance.privateTranslationEngines
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

  void _handleSelectedEngineIdChanged(String? engineId) {
    setState(() {
      _selectedEngineId = engineId;
    });
  }

  Future<void> _handleClickOk() async {
    TranslationEngineConfig? engineConfig =
        Settings.instance.privateTranslationEngine(_selectedEngineId).get() ??
            Settings.instance.proTranslationEngine(_selectedEngineId).get();
    context.pop<TranslationEngineConfig?>(engineConfig);
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        if (_proEngineList.isNotEmpty)
          ListSection(
            children: [
              for (var engineConfig in _proEngineList)
                RadioListTile<String>(
                  value: engineConfig.id,
                  groupValue: _selectedEngineId,
                  onChanged: _handleSelectedEngineIdChanged,
                  useCheckmarkStyle: true,
                  leading: TranslationEngineIcon(engineConfig.type),
                  title: TranslationEngineName(engineConfig),
                ),
            ],
          ),
        ListSection(
          header: Text(
            LocaleKeys.app_translation_engines_private_title.tr(),
          ),
          children: [
            for (var engineConfig in _privateEngineList)
              RadioListTile<String>(
                value: engineConfig.id,
                groupValue: _selectedEngineId,
                onChanged: _handleSelectedEngineIdChanged,
                useCheckmarkStyle: true,
                leading: TranslationEngineIcon(engineConfig.type),
                title: TranslationEngineName(engineConfig),
              ),
            if (_privateEngineList.isEmpty)
              ListTile(
                title: Text(
                  LocaleKeys.app_translation_engines__msg_no_available_engines
                      .tr(),
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
          LocaleKeys.app_translation_engines_title.tr(),
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
