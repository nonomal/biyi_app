import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:reflect_ui/reflect_ui.dart';

class RecordShortcutPage extends StatefulWidget {
  const RecordShortcutPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _RecordShortcutPageState();
}

class _RecordShortcutPageState extends State<RecordShortcutPage> {
  HotKey? _hotKey;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleClickOk() async {
    context.pop<HotKey?>(_hotKey);
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            height: 100,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                HotKeyRecorder(
                  onHotKeyRecorded: (hotKey) {
                    _hotKey = hotKey;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizedAppBar(
        title: Text(
          LocaleKeys.app_record_shortcut_title.tr(),
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
