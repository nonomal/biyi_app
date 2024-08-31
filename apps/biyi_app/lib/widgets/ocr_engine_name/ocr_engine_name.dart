import 'package:biyi_app/models/ext_ocr_engine_config.dart';
import 'package:reflect_colors/reflect_colors.dart';
import 'package:reflect_ui/reflect_ui.dart';

class OcrEngineName extends StatelessWidget {
  const OcrEngineName(
    this.ocrEngineConfig, {
    super.key,
  });

  final OcrEngineConfig ocrEngineConfig;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text.rich(
      TextSpan(
        text: ocrEngineConfig.typeName,
        children: [
          TextSpan(
            text: ' (${ocrEngineConfig.id})',
            style: textTheme.bodySmall?.copyWith(
              color: ReflectColors.neutral.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
