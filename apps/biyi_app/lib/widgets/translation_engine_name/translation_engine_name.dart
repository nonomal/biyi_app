import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/models/ext_translation_engine_config.dart';
import 'package:influxui/influxui.dart';

class TranslationEngineName extends StatelessWidget {
  const TranslationEngineName(
    this.translationEngineConfig, {
    super.key,
  });

  final TranslationEngineConfig translationEngineConfig;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: translationEngineConfig.typeName,
        children: [
          TextSpan(
            text: ' (${translationEngineConfig.identifier})',
            style: const TextStyle(
              fontSize: 12,
              color: ExtendedColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}
