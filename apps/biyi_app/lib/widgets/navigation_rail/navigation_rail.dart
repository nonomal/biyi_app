import 'package:biyi_app/widgets/navigation_rail/navigation_rail_destination.dart';
import 'package:reflect_colors/reflect_colors.dart';
import 'package:reflect_ui/reflect_ui.dart';

export 'navigation_rail_destination.dart';

class NavigationRail extends StatelessWidget {
  const NavigationRail({
    super.key,
    this.leading,
    this.trailing,
    required this.destinations,
    this.selectedValue,
    this.onDestinationSelected,
  });

  final Widget? leading;
  final Widget? trailing;
  final List<NavigationRailDestination> destinations;
  final String? selectedValue;
  final ValueChanged<String>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    late final ThemeData themeData = Theme.of(context);
    late final bool isDark = themeData.brightness == Brightness.dark;

    IconThemeData? unselectedIconTheme = IconThemeData(
      color: isDark ? Colors.white : ReflectColors.neutral.shade600,
      size: 18,
    );

    TextStyle? unselectedLabelStyle = themeData.textTheme.bodyMedium?.copyWith(
      color: isDark ? Colors.white : ReflectColors.neutral.shade900,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );

    IconThemeData? selectedIconTheme = IconThemeData(
      color: isDark ? Colors.white : ReflectColors.neutral.shade600,
      size: 18,
    );

    TextStyle? selectedLabelStyle = themeData.textTheme.bodyMedium?.copyWith(
      color: isDark ? Colors.white : ReflectColors.neutral.shade900,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );

    Color? indicatorColor = isDark
        ? ReflectColors.neutral.shade800
        : ReflectColors.neutral.shade200;

    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) leading!,
          for (var i = 0; i < destinations.length; i++)
            Builder(
              builder: (_) {
                final destination = destinations[i];
                final bool selected = destination.value == selectedValue;
                return _RailDestination(
                  icon: destination.icon,
                  iconBuilder: destination.iconBuilder != null
                      ? (ctx) {
                          return destination.iconBuilder!.call(ctx, selected);
                        }
                      : null,
                  iconTheme: selected ? selectedIconTheme : unselectedIconTheme,
                  label: destinations[i].label,
                  labelTextStyle:
                      selected ? selectedLabelStyle : unselectedLabelStyle,
                  backgroundColor:
                      selected ? indicatorColor : Colors.transparent,
                  shape: null,
                  onTap: () => onDestinationSelected?.call(destination.value),
                );
              },
            ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _RailDestination extends StatefulWidget {
  const _RailDestination({
    this.icon,
    this.iconBuilder,
    this.iconTheme,
    this.label,
    this.labelTextStyle,
    this.shape,
    this.backgroundColor,
    this.onTap,
  });

  final IconData? icon;
  final WidgetBuilder? iconBuilder;
  final IconThemeData? iconTheme;
  final String? label;
  final TextStyle? labelTextStyle;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final VoidCallback? onTap;

  @override
  State<_RailDestination> createState() => __RailDestinationState();
}

class __RailDestinationState extends State<_RailDestination> {
  @override
  Widget build(BuildContext context) {
    ShapeBorder? shapeBorder = RoundedRectangleBorder(
      side: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(6),
    );
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.onTap?.call();
        },
        child: Semantics(
          button: true,
          child: Container(
            constraints: const BoxConstraints(),
            margin: const EdgeInsets.only(
              top: 2,
              bottom: 2,
              left: 12,
              right: 12,
            ),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: shapeBorder,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: DefaultTextStyle(
                    style: widget.labelTextStyle ?? const TextStyle(),
                    child: GappedRow(
                      gap: 8,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.icon != null || widget.iconBuilder != null)
                          IconTheme(
                            data: widget.iconTheme ?? const IconThemeData(),
                            child: Builder(
                              builder: (_) {
                                if (widget.iconBuilder != null) {
                                  return widget.iconBuilder!(context);
                                }
                                return Icon(widget.icon);
                              },
                            ),
                          ),
                        Expanded(
                          child: Text(
                            widget.label!,
                            style: widget.labelTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
