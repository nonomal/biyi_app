import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:reflect_ui/reflect_ui.dart';
import 'package:uni_translate_client/uni_translate_client.dart';

class WordPhraseView extends StatelessWidget {
  const WordPhraseView(
    this.wordPhrase, {
    super.key,
    required this.onTextTapped,
  });

  final WordPhrase wordPhrase;
  final ValueChanged<String> onTextTapped;

  @override
  Widget build(BuildContext context) {
    final DesignThemeData theme = DesignTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 6),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SelectableText.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: wordPhrase.text,
                  style: theme.typography.bodyMedium.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => onTextTapped(wordPhrase.text),
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: wordPhrase.translations.first,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 13,
                      ),
                ),
              ],
            ),
            style: theme.typography.bodyMedium.copyWith(
              height: 1.4,
            ),
            selectionHeightStyle: ui.BoxHeightStyle.max,
          ),
        ],
      ),
    );
  }
}
