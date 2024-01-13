import 'package:easy_localization/easy_localization.dart';
import 'package:uni_translate_client/uni_translate_client.dart';

extension ExtWordPronunciation on WordPronunciation {
  String get localType {
    return 'word_pronunciation.$type'.tr();
  }
}
