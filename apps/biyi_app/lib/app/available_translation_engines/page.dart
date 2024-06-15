import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:influxui/influxui.dart';
import 'package:preference_list/preference_list.dart';

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
        .where(((e) => !e.disabled))
        .toList();
  }

  List<TranslationEngineConfig> get _privateEngineList {
    return Settings.instance.privateTranslationEngines
        .where((e) => !e.disabled)
        .toList();
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
        Settings.instance.getTranslationEngine(_selectedEngineId);
    context.pop<TranslationEngineConfig?>(engineConfig);
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (_proEngineList.isNotEmpty)
          PreferenceListSection(
            children: [
              for (var engineConfig in _proEngineList)
                PreferenceListTile(
                  leading: TranslationEngineIcon(engineConfig.type),
                  title: TranslationEngineName(engineConfig),
                  additionalInfo: engineConfig.id == _selectedEngineId
                      ? Icon(
                          FluentIcons.checkmark_circle_16_filled,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedEngineId = engineConfig.id;
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
                additionalInfo: engineConfig.id == _selectedEngineId
                    ? Icon(
                        FluentIcons.checkmark_circle_16_filled,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _selectedEngineId = engineConfig.id;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizedAppBar(
        title: Text(
          LocaleKeys.app_translation_engines_title.tr(),
        ),
        actions: [
          Button(
            label: LocaleKeys.ok.tr(),
            variant: ButtonVariant.subtle,
            onPressed: _handleClickOk,
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }
}
