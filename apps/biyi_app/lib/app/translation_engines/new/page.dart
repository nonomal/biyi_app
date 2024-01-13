import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/includes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shortid/shortid.dart';
import 'package:uni_translate_client/uni_translate_client.dart';

const List<String> _kAllScopes = [
  kScopeDetectLanguage,
  kScopeLookUp,
  kScopeTranslate,
];

class TranslationEnginesNewOrEditPage extends StatefulWidget {
  const TranslationEnginesNewOrEditPage({
    super.key,
    this.editable = true,
    this.engineType,
    this.engineConfig,
  });

  final bool editable;
  final String? engineType;
  final TranslationEngineConfig? engineConfig;

  @override
  State<TranslationEnginesNewOrEditPage> createState() =>
      _TranslationEnginesNewOrEditPageState();
}

class _TranslationEnginesNewOrEditPageState
    extends State<TranslationEnginesNewOrEditPage> {
  final Map<String, TextEditingController> _textEditingControllerMap = {};

  String? _identifier;
  String? _type;
  Map<String, dynamic> _option = {};

  List<String> get _engineOptionKeys {
    return kKnownSupportedEngineOptionKeys[_type] ?? [];
  }

  TranslationEngine? get translationEngine {
    if (_type != null) {
      var engineConfig = TranslationEngineConfig(
        identifier: '',
        type: _type!,
        option: _option,
      );
      if (widget.engineConfig != null && widget.engineConfig?.option == null) {
        engineConfig = TranslationEngineConfig(
          identifier: '',
          type: _type!,
          option: {},
        );
      }
      return createTranslationEngine(engineConfig)!;
    }
    return null;
  }

  @override
  void initState() {
    if (widget.engineConfig != null) {
      _identifier = widget.engineConfig?.identifier;
      _type = widget.engineConfig?.type;
      _option = widget.engineConfig?.option ?? {};

      for (var optionKey in _engineOptionKeys) {
        var textEditingController = TextEditingController(
          text: _option[optionKey] ?? '',
        );
        _textEditingControllerMap[optionKey] = textEditingController;
      }
    } else {
      _identifier = shortid.generate();
      _type = widget.engineType;
    }

    super.initState();
  }

  Future<void> _handleClickOk() async {
    // try {
    //   var resp = await translationEngine?.lookUp(
    //     LookUpRequest(
    //       sourceLanguage: kLanguageEN,
    //       targetLanguage: kLanguageZH,
    //       word: 'hello',
    //     ),
    //   );
    //   print(resp?.toJson());
    // } catch (error) {
    //   print((error as UniTranslateClientError).message);
    // }

    await localDb //
        .privateEngine(_identifier)
        .updateOrCreate(
          type: _type,
          option: _option,
        );

    (translateClient.adapter as AutoloadTranslateClientAdapter)
        .renew(_identifier!);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: widget.engineConfig != null
          ? TranslationEngineName(widget.engineConfig!)
          : Text(LocaleKeys.app_translation_engines_new_title.tr()),
      actions: [
        if (widget.editable)
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
          title: Text(
            LocaleKeys.app_translation_engines_new_engine_type_title.tr(),
          ),
          children: [
            PreferenceListItem(
              icon: _type == null ? null : TranslationEngineIcon(_type!),
              title: _type == null
                  ? Text('please_choose'.tr())
                  : Text('engine.$_type'.tr()),
              accessoryView: widget.editable ? null : Container(),
              onTap: widget.editable
                  ? () async {
                      final newEngineType = await context.push<String?>(
                        PageId.translationEngineTypes,
                        extra: {
                          'selectedEngineType': _type,
                        },
                      );
                      if (newEngineType != null) {
                        setState(() {
                          _type = newEngineType;
                        });
                      }
                    }
                  : null,
            ),
          ],
        ),
        if (translationEngine != null)
          PreferenceListSection(
            title: Text(
              LocaleKeys.app_translation_engines_new_support_interface_title
                  .tr(),
            ),
            children: [
              for (var scope in _kAllScopes)
                PreferenceListItem(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 12,
                    right: 12,
                  ),
                  title: Text(
                    'engine_scope.${scope.toLowerCase()}'.tr(),
                  ),
                  summary: Text(scope),
                  accessoryView: Container(
                    margin: EdgeInsets.zero,
                    child: Builder(
                      builder: (_) {
                        if (!(translationEngine?.supportedScopes ?? [])
                            .contains(scope)) {
                          return const Icon(
                            FluentIcons.dismiss_circle_20_filled,
                            color: Colors.red,
                          );
                        }
                        return const Icon(
                          FluentIcons.checkmark_circle_20_filled,
                          color: Colors.green,
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        if (widget.editable && _type != null)
          PreferenceListSection(
            title: Text(
              LocaleKeys.app_translation_engines_new_option_title.tr(),
            ),
            children: [
              for (var optionKey in _engineOptionKeys)
                PreferenceListTextFieldItem(
                  controller: _textEditingControllerMap[optionKey],
                  placeholder: optionKey,
                  accessoryView: Container(),
                  onChanged: (value) {
                    _option[optionKey] = value;
                    setState(() {});
                  },
                ),
              if (_engineOptionKeys.isEmpty)
                PreferenceListItem(
                  title: const Text('No options'),
                  accessoryView: Container(),
                ),
            ],
          ),
        if (widget.editable && widget.engineConfig != null)
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
                  await localDb.privateEngine(_identifier).delete();

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
