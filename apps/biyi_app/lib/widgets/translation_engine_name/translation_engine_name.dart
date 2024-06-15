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
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text.rich(
      TextSpan(
        text: translationEngineConfig.typeName,
        children: [
          TextSpan(
            text: ' (${translationEngineConfig.id})',
            style: textTheme.bodySmall?.copyWith(
              color: ExtendedColors.gray.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
