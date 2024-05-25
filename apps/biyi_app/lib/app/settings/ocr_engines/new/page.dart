import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/app/router_config.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/networking/ocr_client/ocr_client.dart';
import 'package:biyi_app/services/local_db/local_db.dart';
import 'package:biyi_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:biyi_app/widgets/ocr_engine_icon/ocr_engine_icon.dart';
import 'package:biyi_app/widgets/ocr_engine_name/ocr_engine_name.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:influxui/influxui.dart';
import 'package:ocr_engine_youdao/ocr_engine_youdao.dart';
import 'package:preference_list/preference_list.dart';
import 'package:shortid/shortid.dart';

class OcrEnginesNewOrEditPage extends StatefulWidget {
  const OcrEnginesNewOrEditPage({
    super.key,
    this.editable = true,
    this.ocrEngineType,
    this.ocrEngineConfig,
  });

  final bool editable;
  final String? ocrEngineType;
  final OcrEngineConfig? ocrEngineConfig;

  @override
  State<OcrEnginesNewOrEditPage> createState() =>
      _OcrEnginesNewOrEditPageState();
}

class _OcrEnginesNewOrEditPageState extends State<OcrEnginesNewOrEditPage> {
  final Map<String, TextEditingController> _textEditingControllerMap = {};

  String? _identifier;
  String? _type;
  Map<String, dynamic> _option = {};

  List<String> get _engineOptionKeys {
    switch (_type) {
      case kOcrEngineTypeYoudao:
        return YoudaoOcrEngine.optionKeys;
    }
    return [];
  }

  @override
  void initState() {
    if (widget.ocrEngineConfig != null) {
      _identifier = widget.ocrEngineConfig?.identifier;
      _type = widget.ocrEngineConfig?.type;
      _option = widget.ocrEngineConfig?.option ?? {};

      for (var optionKey in _engineOptionKeys) {
        var textEditingController =
            TextEditingController(text: _option[optionKey]);
        _textEditingControllerMap[optionKey] = textEditingController;
      }
    } else {
      _identifier = shortid.generate();
      _type = widget.ocrEngineType;
    }
    super.initState();
  }

  Future<void> _handleClickOk() async {
    await localDb //
        .privateOcrEngine(_identifier)
        .updateOrCreate(
          type: _type,
          option: _option,
        );

    (sharedOcrClient.adapter as AutoloadOcrClientAdapter).renew(_identifier!);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: widget.ocrEngineConfig != null
          ? OcrEngineName(widget.ocrEngineConfig!)
          : Text(LocaleKeys.app_ocr_engines_new_title.tr()),
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
    return ListView(
      children: [
        PreferenceListSection(
          header: Text(
            LocaleKeys.app_ocr_engines_new_engine_type_title.tr(),
          ),
          children: [
            PreferenceListTile(
              leading: _type == null ? null : OcrEngineIcon(_type!),
              title: _type == null
                  ? Text(LocaleKeys.please_choose.tr())
                  : Text('ocr_engine.$_type'.tr()),
              trailing: const PreferenceListTileChevron(),
              onTap: widget.editable
                  ? () async {
                      final newEngineType = await context.push<String?>(
                        PageId.settingsOcrEngineTypes,
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
        if (widget.editable && _type != null)
          PreferenceListSection(
            header: Text(
              LocaleKeys.app_ocr_engines_new_option_title.tr(),
            ),
            children: [
              for (var optionKey in _engineOptionKeys)
                PreferenceListTile(
                  title: CupertinoTextField(
                    controller: _textEditingControllerMap[optionKey],
                    placeholder: optionKey,
                    onChanged: (value) {
                      _option[optionKey] = value;
                      setState(() {});
                    },
                  ),
                ),
              if (_engineOptionKeys.isEmpty)
                const PreferenceListTile(
                  title: Text('No options'),
                ),
            ],
          ),
        if (widget.editable && widget.ocrEngineConfig != null)
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
                onTap: () async {
                  await localDb.privateOcrEngine(_identifier).delete();
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
