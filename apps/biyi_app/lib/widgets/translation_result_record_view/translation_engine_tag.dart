import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/models/models.dart';
import 'package:biyi_app/services/local_db/local_db.dart';
import 'package:biyi_app/widgets/translation_engine_icon/translation_engine_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:influxui/influxui.dart';

class TranslationEngineTag extends StatefulWidget {
  const TranslationEngineTag({
    super.key,
    required this.translationResultRecord,
  });

  final TranslationResultRecord translationResultRecord;

  @override
  State<TranslationEngineTag> createState() => _TranslationEngineTagState();
}

class _TranslationEngineTagState extends State<TranslationEngineTag> {
  bool _isHovered = false;

  TranslationEngineConfig get _translationEngineConfig {
    return localDb
        .engine(widget.translationResultRecord.translationEngineId!)
        .get()!;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        _isHovered = true;
        setState(() {});
      },
      onExit: (event) {
        _isHovered = false;
        setState(() {});
      },
      child: Container(
        height: 40,
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.only(
            top: 3,
            bottom: 3,
            left: 4,
            right: 2,
          ),
          child: CupertinoButton(
            minSize: 0,
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: AnimatedCrossFade(
              crossFadeState: !_isHovered
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.ease,
              secondCurve: Curves.ease,
              sizeCurve: Curves.ease,
              firstChild: Row(
                children: [
                  TranslationEngineIcon(
                    _translationEngineConfig.type,
                    size: 12,
                  ),
                ],
              ),
              secondChild: Row(
                children: [
                  TranslationEngineIcon(
                    _translationEngineConfig.type,
                    size: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 2),
                    child: Text(
                      _translationEngineConfig.typeName,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 10,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
