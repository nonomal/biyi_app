import 'package:biyi_app/utils/extended_colors.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:reflect_ui/reflect_ui.dart';

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
    TextTheme textTheme = theme.textTheme;

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
          variant: IconButtonVariant.filled,
          color: ExtendedColors.neutral.shade900,
          // size: const Size.square(24),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      }
    }

    return SafeArea(
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.only(
          left: 12,
          right: 24,
        ),
        decoration: BoxDecoration(
          color: ExtendedColors.cyan.withOpacity(0.1),
        ),
        child: Row(
          children: [
            if (leadingWidget != null)
              Container(
                color: ExtendedColors.cyan.withOpacity(0.2),
                padding: const EdgeInsets.all(12),
                child: ColoredBox(
                  color: ExtendedColors.cyan.withOpacity(0.3),
                  child: leadingWidget,
                ),
              ),
            const SizedBox(width: 4),
            DefaultTextStyle(
              style: textTheme.titleMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              child: title,
            ),
            Expanded(child: Container()),
            if ((actions ?? []).isNotEmpty)
              GappedRow(
                gap: 4,
                children: actions!,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
