import 'package:biyi_app/models/ext_translation_engine_config.dart';
import 'package:reflect_colors/reflect_colors.dart';
import 'package:reflect_ui/reflect_ui.dart';

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
              color: ReflectColors.neutral.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
