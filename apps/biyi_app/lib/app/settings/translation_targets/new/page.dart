import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/models/models.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reflect_ui/reflect_ui.dart';

class TranslationTargetNewOrEditPage extends StatefulWidget {
  const TranslationTargetNewOrEditPage({
    super.key,
    this.translationTarget,
  });

  final TranslationTarget? translationTarget;

  @override
  State<TranslationTargetNewOrEditPage> createState() =>
      _TranslationTargetNewOrEditPageState();
}

class _TranslationTargetNewOrEditPageState
    extends State<TranslationTargetNewOrEditPage> {
  String? _sourceLanguage;
  String? _targetLanguage;

  @override
  void initState() {
    if (widget.translationTarget != null) {
      _sourceLanguage = widget.translationTarget?.sourceLanguage;
      _targetLanguage = widget.translationTarget?.targetLanguage;
    }
    super.initState();
  }

  void _handleClickOk() {
    context.read<Settings>().transTargets.updateOrCreate(
          sourceLanguage: _sourceLanguage!,
          targetLanguage: _targetLanguage!,
        );
    Navigator.of(context).pop();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomizedAppBar(
      title: Text(
        widget.translationTarget != null
            ? LocaleKeys.app_translation_targets_new_title_with_edit.tr()
            : LocaleKeys.app_translation_targets_new_title.tr(),
      ),
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
            ListTile(
              title: Text(
                LocaleKeys.app_translation_targets_new_source_language.tr(),
              ),
              additionalInfo: _sourceLanguage != null
                  ? LanguageLabel(_sourceLanguage!)
                  : Text(LocaleKeys.please_choose.tr()),
              onTap: () async {
                final selectedLanguage = await context.push<String?>(
                  '${PageId.supportedLanguages}?selectedLanguage=$_sourceLanguage',
                );
                if (selectedLanguage != null) {
                  _sourceLanguage = selectedLanguage;
                  setState(() {});
                }
              },
            ),
            ListTile(
              title: Text(
                LocaleKeys.app_translation_targets_new_target_language.tr(),
              ),
              additionalInfo: _targetLanguage != null
                  ? LanguageLabel(_targetLanguage!)
                  : Text(LocaleKeys.please_choose.tr()),
              onTap: () async {
                final selectedLanguage = await context.push<String?>(
                  '${PageId.supportedLanguages}?selectedLanguage=$_targetLanguage',
                );
                if (selectedLanguage != null) {
                  _targetLanguage = selectedLanguage;
                  setState(() {});
                }
              },
            ),
          ],
        ),
        if (widget.translationTarget != null)
          ListSection(
            header: const Text(''),
            children: [
              ListTile(
                title: Center(
                  child: Text(
                    LocaleKeys.delete.tr(),
                    // style: const TextStyle(color: ReflectColors),
                  ),
                ),
                // accessoryView: Container(),
                onTap: () {
                  context
                      .read<Settings>()
                      .transTarget(widget.translationTarget!.id!)
                      .delete();
                  Navigator.of(context).pop();
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
