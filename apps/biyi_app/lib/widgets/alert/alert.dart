import 'package:biyi_app/widgets/alert/alert_style.dart';
import 'package:biyi_app/widgets/alert/alert_theme.dart';
import 'package:open_colors/open_colors.dart';
import 'package:reflect_ui/reflect_ui.dart';

enum AlertType {
  success,
  info,
  warning,
  danger;
}

/// Attract user attention with important static message
class Alert extends StatefulWidget {
  const Alert({
    super.key,
    this.style,
    this.type = AlertType.info,
    this.icon,
    this.title,
    this.titleBuilder,
    this.message,
    this.messageBuilder,
    this.actions,
  });

  final AlertStyle? style;

  /// Alert type
  final AlertType? type;

  final Widget? icon;

  /// Alert title
  final String? title;

  /// Alert title builder
  final WidgetBuilder? titleBuilder;

  /// Alert message
  final String? message;

  /// Alert message builder
  final WidgetBuilder? messageBuilder;

  final List<Widget>? actions;

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  @override
  Widget build(BuildContext context) {
    final AlertThemeData? themeData = AlertTheme.of(context);
    final AlertThemeData defaults = _AlertDefaults(context);
    AlertStyle mergedStyle = widget.style ?? const AlertStyle();

    switch (widget.type!) {
      case AlertType.success:
        mergedStyle = mergedStyle // merge success style
            .merge(themeData?.successStyle)
            .merge(defaults.successStyle);
        break;
      case AlertType.info:
        mergedStyle = mergedStyle // merge info style
            .merge(themeData?.infoStyle)
            .merge(defaults.infoStyle);
        break;
      case AlertType.warning:
        mergedStyle = mergedStyle // merge warning style
            .merge(themeData?.warningStyle)
            .merge(defaults.warningStyle);
        break;
      case AlertType.danger:
        mergedStyle = mergedStyle // merge danger style
            .merge(themeData?.dangerStyle)
            .merge(defaults.dangerStyle);
        break;
    }

    final Widget? iconWidget = widget.icon != null
        ? IconTheme(
            data: IconThemeData(
              size: mergedStyle.iconSize,
              color: mergedStyle.titleStyle!.color,
            ),
            child: widget.icon!,
          )
        : null;

    final Widget? titleWidget = widget.titleBuilder != null
        ? widget.titleBuilder!(context)
        : widget.title != null
            ? Text(widget.title!)
            : null;

    final Widget? messageWidget = widget.messageBuilder != null
        ? widget.messageBuilder!(context)
        : widget.message != null
            ? Text(widget.message!)
            : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: mergedStyle.backgroundColor,
      ),
      child: GappedRow(
        gap: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (iconWidget != null) iconWidget,
          Expanded(
            child: GappedColumn(
              gap: 8,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (titleWidget != null)
                  DefaultTextStyle(
                    style: mergedStyle.titleStyle!,
                    child: titleWidget,
                  ),
                if (messageWidget != null)
                  DefaultTextStyle(
                    style: mergedStyle.messageStyle!,
                    child: messageWidget,
                  ),
                if ((widget.actions ?? []).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: GappedRow(gap: 8, children: widget.actions!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertDefaults extends AlertThemeData {
  _AlertDefaults(this.context) : super();

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);

  @override
  AlertStyle? get successStyle {
    return AlertStyle.fromColor(_theme, OpenColors.green);
  }

  @override
  AlertStyle? get infoStyle {
    return AlertStyle.fromColor(_theme, OpenColors.blue);
  }

  @override
  AlertStyle? get warningStyle {
    return AlertStyle.fromColor(_theme, OpenColors.yellow);
  }

  @override
  AlertStyle? get dangerStyle {
    return AlertStyle.fromColor(_theme, OpenColors.red);
  }
}
