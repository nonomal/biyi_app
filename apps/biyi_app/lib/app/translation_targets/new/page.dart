import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TranslationTargetNewPage extends StatefulWidget {
  const TranslationTargetNewPage({
    super.key,
    this.translationTarget,
  });

  final TranslationTarget? translationTarget;

  @override
  State<TranslationTargetNewPage> createState() =>
      _TranslationTargetNewPageState();
}

class _TranslationTargetNewPageState extends State<TranslationTargetNewPage> {
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
    return PreferenceList(
      children: [
        PreferenceListSection(
          children: [
            PreferenceListItem(
              title: Text(
                LocaleKeys.app_translation_targets_new_source_language.tr(),
              ),
              detailText: _sourceLanguage != null
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
            PreferenceListItem(
              title: Text(
                LocaleKeys.app_translation_targets_new_target_language.tr(),
              ),
              detailText: _targetLanguage != null
                  ? LanguageLabel(_targetLanguage!)
                  : Text('please_choose'.tr()),
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
            title: const Text(''),
            children: [
              PreferenceListItem(
                title: Center(
                  child: Text(
                    LocaleKeys.delete.tr(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                accessoryView: Container(),
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
