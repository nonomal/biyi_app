import 'package:biyi_app/models/ext_ocr_engine_config.dart';
import 'package:reflect_ui/reflect_ui.dart';

class OcrEngineName extends StatelessWidget {
  const OcrEngineName(
    this.ocrEngineConfig, {
    super.key,
  });

  final OcrEngineConfig ocrEngineConfig;

  @override
  Widget build(BuildContext context) {
    final DesignThemeData theme = DesignTheme.of(context);
    return Text.rich(
      TextSpan(
        text: ocrEngineConfig.typeName,
        children: [
          TextSpan(
            text: ' (${ocrEngineConfig.id})',
            style: theme.typography.bodySmall.copyWith(
              color: Colors.neutral.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
