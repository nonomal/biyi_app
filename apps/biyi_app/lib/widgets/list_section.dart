import 'package:flutter/cupertino.dart';

class ListSection extends StatelessWidget {
  const ListSection({
    super.key,
    this.children,
    this.header,
    this.footer,
    this.margin = const EdgeInsets.only(left: 12, right: 12),
    this.decoration,
    this.clipBehavior = Clip.none,
    this.topMargin = 8,
    bool hasLeading = true,
    this.separatorColor,
  });

  final Widget? header;
  final Widget? footer;
  final EdgeInsetsGeometry margin;
  final List<Widget>? children;
  final BoxDecoration? decoration;
  final Clip clipBehavior;
  final double? topMargin;
  final Color? separatorColor;

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection(
      header: header,
      footer: footer,
      margin: margin,
      decoration: decoration,
      clipBehavior: clipBehavior,
      topMargin: topMargin,
      separatorColor: separatorColor,
      children: children,
    );
  }
}
