import 'package:biyi_app/models/ext_translation_engine_config.dart';
import 'package:reflect_ui/reflect_ui.dart';

class TranslationEngineName extends StatelessWidget {
  const TranslationEngineName(
    this.translationEngineConfig, {
    super.key,
  });

  final TranslationEngineConfig translationEngineConfig;

  @override
  Widget build(BuildContext context) {
    final DesignThemeData theme = DesignTheme.of(context);
    return Text.rich(
      TextSpan(
        text: translationEngineConfig.typeName,
        children: [
          TextSpan(
            text: ' (${translationEngineConfig.id})',
            style: theme.typography.bodySmall.copyWith(
              color: Colors.neutral.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
