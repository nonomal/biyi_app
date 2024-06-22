import 'package:biyi_app/services/api_client.dart' show OcrEngineConfig;
import 'package:easy_localization/easy_localization.dart';

export 'package:biyi_app/services/api_client.dart' show OcrEngineConfig;

extension ExtOcrEngineConfig on OcrEngineConfig {
  String get typeName {
    String key = 'ocr_engine.$type';
    if (key.tr() == key) {
      return type;
    }
    return key.tr();
  }
}
