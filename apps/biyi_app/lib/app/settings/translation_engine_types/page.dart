import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/services/translate_client/translate_client.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:harmonic/noprefix/harmonic.dart';
import 'package:influxui/influxui.dart' show Button, ButtonVariant;

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
    return CustomizedAppBar(
      title: Text(LocaleKeys.app_translation_engine_types_title.tr()),
      actions: [
        Button(
          label: LocaleKeys.ok.tr(),
          variant: ButtonVariant.subtle,
          onPressed: _handleClickOk,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ListSection(
          children: [
            for (final engineType in kSupportedEngineTypes)
              ListTile(
                leading: TranslationEngineIcon(engineType),
                title: Text('engine.$engineType'.tr()),
                additionalInfo: _selectedEngineType == engineType
                    ? const Icon(
                        FluentIcons.checkmark_circle_16_filled,
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
