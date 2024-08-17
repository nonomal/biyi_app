import 'package:biyi_app/utils/extended_colors.dart';
import 'package:reflect_ui/reflect_ui.dart';
import 'package:uni_translate_client/uni_translate_client.dart';

class WordTagView extends StatelessWidget {
  const WordTagView(
    this.wordTag, {
    super.key,
  });

  final WordTag wordTag;

  @override
  Widget build(BuildContext context) {
    return Badge(
      variant: BadgeVariant.outlined,
      color: ExtendedColors.gray,
      child: Text(wordTag.name),
    );
  }
}
