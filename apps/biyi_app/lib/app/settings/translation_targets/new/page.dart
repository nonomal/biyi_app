import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/models/models.dart';
import 'package:biyi_app/services/local_db/local_db.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:influxui/influxui.dart';
import 'package:preference_list/preference_list.dart';

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

  Future<void> _handleClickOk() async {
    await localDb //
        .translationTarget(widget.translationTarget?.id)
        .updateOrCreate(
          sourceLanguage: _sourceLanguage,
          targetLanguage: _targetLanguage,
        );

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: Text(
        widget.translationTarget != null
            ? LocaleKeys.app_translation_targets_new_title_with_edit.tr()
            : LocaleKeys.app_translation_targets_new_title.tr(),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        PreferenceListSection(
          children: [
            PreferenceListTile(
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
            PreferenceListTile(
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
          PreferenceListSection(
            header: const Text(''),
            children: [
              PreferenceListTile(
                title: Center(
                  child: Text(
                    LocaleKeys.delete.tr(),
                    style: const TextStyle(color: ExtendedColors.red),
                  ),
                ),
                // accessoryView: Container(),
                onTap: () async {
                  await localDb
                      .translationTarget(widget.translationTarget?.id)
                      .delete();

                  // ignore: use_build_context_synchronously
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
