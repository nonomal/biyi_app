import 'package:biyi_app/widgets/customized_app_bar/customized_app_bar.dart';
import 'package:influxui/influxui.dart';

class TabVocabularyScene extends StatelessWidget {
  const TabVocabularyScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomizedAppBar(
        title: Text('Vocabulary'),
      ),
      body: Container(),
    );
  }
}
