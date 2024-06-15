import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/models/ext_ocr_engine_config.dart';
import 'package:influxui/influxui.dart';

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
              color: ExtendedColors.gray.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
