import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:influxui/influxui.dart';

class CustomizedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomizedAppBar({
    super.key,
    this.leading,
    required this.title,
    this.actions,
  });

  final Widget? leading;
  final Widget title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);

    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    Widget? leadingWidget = leading;
    if (leadingWidget == null) {
      if (canPop) {
        leadingWidget = IconButton(
          useCloseButton
              ? FluentIcons.dismiss_20_regular
              : FluentIcons.chevron_left_20_regular,
          variant: IconButtonVariant.transparent,
          color: ExtendedColors.neutral.shade900,
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      }
    }

    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(
        left: leadingWidget == null ? 16 : 4,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (leadingWidget != null)
            Container(
              margin: const EdgeInsets.only(right: 4),
              child: leadingWidget,
            ),
          DefaultTextStyle(
            style: theme.textTheme.titleMedium!.copyWith(
              fontSize: 16,
            ),
            child: title,
          ),
          Expanded(child: Container()),
          if (actions != null)
            GappedRow(
              gap: 4,
              children: actions!,
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44);
}
