import 'package:flutter/material.dart';
import 'package:reflect_colors/reflect_colors.dart';

/// Display keyboard button or keys combination
class Kbd extends StatefulWidget {
  const Kbd(
    this.label, {
    super.key,
  });

  final String label;

  @override
  State<Kbd> createState() => _KbdState();
}

class _KbdState extends State<Kbd> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final bool isDark = themeData.brightness == Brightness.dark;

    final backgroundColor =
        isDark ? ReflectColors.neutral.shade500 : ReflectColors.neutral.shade50;

    final borderColor = isDark
        ? ReflectColors.neutral.shade300
        : ReflectColors.neutral.shade300;

    final labelColor =
        isDark ? ReflectColors.neutral.shade50 : ReflectColors.neutral.shade700;

    final TextStyle textStyle =
        (textTheme.labelMedium ?? const TextStyle()).copyWith(
      color: labelColor,
      fontWeight: FontWeight.w700,
      fontFamily: 'Roboto Mono',
      fontFamilyFallback: ['Roboto'],
      fontSize: 12,
    );

    return Container(
      constraints: const BoxConstraints(
        minWidth: 0,
        minHeight: 22,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: BorderDirectional(
          start: BorderSide(
            color: borderColor,
            width: 1,
          ),
          top: BorderSide(
            color: borderColor,
            width: 1,
          ),
          end: BorderSide(
            color: borderColor,
            width: 1,
          ),
          bottom: BorderSide(
            color: borderColor,
            width: 3,
          ),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: DefaultTextStyle(
          style: textStyle,
          child: Text(widget.label),
        ),
      ),
    );
  }
}
