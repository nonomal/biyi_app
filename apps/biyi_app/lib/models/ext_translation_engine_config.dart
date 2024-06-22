import 'package:biyi_app/services/api_client.dart' show TranslationEngineConfig;
import 'package:easy_localization/easy_localization.dart';

export 'package:biyi_app/services/api_client.dart' show TranslationEngineConfig;

extension ExtTranslationEngineConfig on TranslationEngineConfig {
  String get typeName {
    String key = 'engine.$type';
    if (key.tr() == key) {
      return type;
    }
    return key.tr();
  }
}
