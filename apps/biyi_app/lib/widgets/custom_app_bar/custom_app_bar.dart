import 'package:biyi_app/widgets/custom_app_bar/custom_app_bar_back_button.dart';
import 'package:biyi_app/widgets/custom_app_bar/custom_app_bar_close_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_platform/uni_platform.dart';

export './custom_app_bar_action_item.dart';
export './custom_app_bar_back_button.dart';
export './custom_app_bar_close_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
  });

  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);

    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    Widget? leading = this.leading;
    if (leading == null && automaticallyImplyLeading) {
      if (canPop) {
        leading = useCloseButton
            ? const CustomAppBarCloseButton()
            : const CustomAppBarBackButton();
      }
    }

    AppBar appBar = AppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: 1,
          ),
        ),
      ),
      child: appBar,
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(
      UniPlatform.isAndroid
          ? kToolbarHeight
          : kMinInteractiveDimensionCupertino,
    );
  }
}
