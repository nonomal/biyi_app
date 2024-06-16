import 'package:biyi_app/utils/r.dart';
import 'package:influxui/influxui.dart';

class OcrEngineIcon extends StatelessWidget {
  const OcrEngineIcon(
    this.type, {
    super.key,
    this.size = 22,
  });

  final String type;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(R.image('ocr_engine_icons/$type.png')),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        border: Border.all(
          color: ExtendedColors.black.withOpacity(0.2),
          width: 0.5,
        ),
      ),
    );
  }
}
