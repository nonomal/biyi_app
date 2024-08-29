import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:reflect_ui/reflect_ui.dart';
import 'package:window_manager/window_manager.dart';

class ToolbarItemAlwaysOnTop extends StatefulWidget {
  const ToolbarItemAlwaysOnTop({super.key});

  @override
  State<ToolbarItemAlwaysOnTop> createState() => _ToolbarItemAlwaysOnTopState();
}

class _ToolbarItemAlwaysOnTopState extends State<ToolbarItemAlwaysOnTop> {
  bool _isAlwaysOnTop = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _isAlwaysOnTop = await windowManager.isAlwaysOnTop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final iconThemeData = Theme.of(context).iconTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      transformAlignment: Alignment.center,
      transform: Matrix4.rotationZ(
        _isAlwaysOnTop ? 0 : -0.8,
      ),
      child: IconButton(
        _isAlwaysOnTop ? FluentIcons.pin_20_filled : FluentIcons.pin_20_regular,
        variant: IconButtonVariant.transparent,
        padding: EdgeInsets.zero,
        color: _isAlwaysOnTop ? null : iconThemeData.color,
        onPressed: () {
          setState(() {
            _isAlwaysOnTop = !_isAlwaysOnTop;
          });
          windowManager.setAlwaysOnTop(_isAlwaysOnTop);
        },
      ),
    );
  }
}
