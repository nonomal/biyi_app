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
      color: Colors.neutral,
      child: Text(wordTag.name),
    );
  }
}
