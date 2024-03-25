import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/includes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:influxui/influxui.dart';
import 'package:preference_list/preference_list.dart';

class TranslationEnginesPage extends StatefulWidget {
  const TranslationEnginesPage({
    super.key,
    this.selectedEngineId,
  });

  final String? selectedEngineId;

  @override
  State<StatefulWidget> createState() => _TranslationEnginesPageState();
}

class _TranslationEnginesPageState extends State<TranslationEnginesPage> {
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
    return ListView(
      children: [
        if (_proEngineList.isNotEmpty)
          PreferenceListSection(
            children: [
              for (var engineConfig in _proEngineList)
                PreferenceListTile(
                  leading: TranslationEngineIcon(engineConfig.type),
                  title: TranslationEngineName(engineConfig),
                  additionalInfo: engineConfig.identifier == _selectedEngineId
                      ? Icon(
                          FluentIcons.checkmark_circle_16_filled,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedEngineId = engineConfig.identifier;
                    });
                  },
                ),
            ],
          ),
        PreferenceListSection(
          header: Text(
            LocaleKeys.app_translation_engines_private_title.tr(),
          ),
          children: [
            for (var engineConfig in _privateEngineList)
              PreferenceListTile(
                leading: TranslationEngineIcon(engineConfig.type),
                title: TranslationEngineName(engineConfig),
                additionalInfo: engineConfig.identifier == _selectedEngineId
                    ? Icon(
                        FluentIcons.checkmark_circle_16_filled,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _selectedEngineId = engineConfig.identifier;
                  });
                },
              ),
            if (_privateEngineList.isEmpty)
              PreferenceListTile(
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

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          LocaleKeys.app_translation_engines_title.tr(),
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
