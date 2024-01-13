import 'package:biyi_app/widgets/custom_image/custom_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_translate_client/uni_translate_client.dart';

const kWordImageSize = 74.0;

class WordImageView extends StatelessWidget {
  const WordImageView(
    this.wordImage, {
    super.key,
    this.onPressed,
  });

  final WordImage wordImage;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: kWordImageSize,
      height: kWordImageSize,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(2),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Hero(
          tag: wordImage.url,
          child: CustomImage(
            wordImage.url,
            width: kWordImageSize,
            height: kWordImageSize,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
