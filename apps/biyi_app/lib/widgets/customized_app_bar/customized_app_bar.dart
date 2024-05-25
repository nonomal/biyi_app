import 'package:influxui/influxui.dart';

class CustomizedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomizedAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  final Widget title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          DefaultTextStyle(
            style: TextStyle(
              color: ExtendedColors.gray.shade950,
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
  Size get preferredSize => const Size.fromHeight(48);
}
