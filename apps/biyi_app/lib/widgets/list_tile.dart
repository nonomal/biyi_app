import 'dart:async';

import 'package:flutter/cupertino.dart';

class ListTile extends StatelessWidget {
  const ListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.additionalInfo,
    this.leading,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.backgroundColorActivated,
    this.padding,
    this.leadingSize = 0,
    this.leadingToTitle = 0,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? additionalInfo;
  final Widget? leading;
  final Widget? trailing;
  final FutureOr<void> Function()? onTap;
  final Color? backgroundColor;
  final Color? backgroundColorActivated;
  final EdgeInsetsGeometry? padding;
  final double leadingSize;
  final double leadingToTitle;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: title,
      subtitle: subtitle,
      additionalInfo: additionalInfo,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      backgroundColor: backgroundColor,
      backgroundColorActivated: backgroundColorActivated,
      padding: padding,
      leadingSize: leadingSize,
      leadingToTitle: leadingToTitle,
    );
  }
}

class ListTileChevron extends StatelessWidget {
  const ListTileChevron({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(12, 24),
      painter: _ChevronRightPainter(),
    );
  }
}

class _ChevronRightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define the path from the SVG data
    Path path = Path();
    path.moveTo(2.81, 18.83);
    path.cubicTo(2.98, 19.01, 3.17, 19.09, 3.37, 19.08);
    path.cubicTo(3.57, 19.08, 3.74, 19, 3.89, 18.83);
    path.lineTo(9.17, 12.77);
    path.cubicTo(9.37, 12.54, 9.47, 12.28, 9.47, 12);
    path.cubicTo(9.46, 11.71, 9.36, 11.45, 9.17, 11.23);
    path.lineTo(3.89, 5.14);
    path.cubicTo(3.76, 4.97, 3.59, 4.9, 3.37, 4.91);
    path.cubicTo(3.15, 4.91, 2.97, 4.99, 2.83, 5.14);
    path.cubicTo(2.69, 5.28, 2.62, 5.45, 2.62, 5.64);
    path.cubicTo(2.62, 5.85, 2.69, 6.03, 2.83, 6.18);
    path.lineTo(7.85, 12);
    path.lineTo(2.81, 17.78);
    path.cubicTo(2.68, 17.93, 2.61, 18.12, 2.6, 18.32);
    path.cubicTo(2.59, 18.52, 2.66, 18.69, 2.81, 18.83);
    path.close();

    // Create a paint object with the desired color
    Paint paint = Paint()
      ..color = const Color(0xE6000000)
      ..style = PaintingStyle.fill;

    // Draw the path on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
