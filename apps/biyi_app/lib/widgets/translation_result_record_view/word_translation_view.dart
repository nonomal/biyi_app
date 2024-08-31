import 'dart:ui' as ui;

import 'package:biyi_app/widgets/sound_play_button/sound_play_button.dart';
import 'package:reflect_colors/reflect_colors.dart';
import 'package:reflect_ui/reflect_ui.dart';
import 'package:uni_translate_client/uni_translate_client.dart';

class WordTranslationView extends StatefulWidget {
  const WordTranslationView(
    this.wordTranslation, {
    super.key,
  });
  final TextTranslation wordTranslation;

  @override
  State<WordTranslationView> createState() => _WordTranslationViewState();
}

class _WordTranslationViewState extends State<WordTranslationView> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
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
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 40,
        ),
        padding: const EdgeInsets.only(
          top: 7,
          bottom: 7,
        ),
        alignment: Alignment.centerLeft,
        child: GappedRow(
          gap: 4,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(text: widget.wordTranslation.text),
                ],
              ),
              style: textTheme.bodyMedium!.copyWith(
                height: 1.4,
              ),
              selectionHeightStyle: ui.BoxHeightStyle.max,
            ),
            const Badge(
              variant: BadgeVariant.outlined,
              color: ReflectColors.neutral,
              child: Text('常见释义'),
            ),
            if ((widget.wordTranslation.audioUrl ?? '').isNotEmpty &&
                _isHovered)
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: SoundPlayButton(
                  audioUrl: widget.wordTranslation.audioUrl!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
