import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:reflect_colors/reflect_colors.dart';
import 'package:reflect_ui/reflect_ui.dart';

class FeatureStatusIcon extends StatelessWidget {
  const FeatureStatusIcon({
    super.key,
    this.supported = false,
  });

  final bool supported;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: supported ? ReflectColors.green : ReflectColors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      child: Center(
        child: Icon(
          supported
              ? FluentIcons.checkmark_12_filled
              : FluentIcons.dismiss_12_filled,
          color: ReflectColors.white,
          size: supported ? 12 : 10,
        ),
      ),
    );
  }
}
