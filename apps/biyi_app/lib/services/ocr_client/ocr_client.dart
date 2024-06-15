import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:ocr_engine_builtin/ocr_engine_builtin.dart';
import 'package:ocr_engine_youdao/ocr_engine_youdao.dart';
import 'package:uni_ocr_client/uni_ocr_client.dart';

final kDefaultBuiltInOcrEngine = BuiltInOcrEngine(
  identifier: 'builtin',
  option: Map<String, dynamic>.from({}),
);

bool kDefaultBuiltInOcrEngineIsSupportedOnCurrentPlatform = false;

const kSupportedOcrEngineTypes = [
  kOcrEngineTypeYoudao,
];

OcrEngine? createOcrEngine(
  OcrEngineConfig ocrEngineConfig,
) {
  OcrEngine? ocrEngine;
  if (ocrEngineConfig.isProGroup &&
      Settings.instance.getOcrEngine(ocrEngineConfig.id) != null) {
    ocrEngine = ProOcrEngine(ocrEngineConfig);
    if (ocrEngineConfig.id == kDefaultBuiltInOcrEngine.identifier) {
      ocrEngine = kDefaultBuiltInOcrEngine;
    }
  } else {
    switch (ocrEngineConfig.type) {
      case kOcrEngineTypeYoudao:
        ocrEngine = YoudaoOcrEngine(
          identifier: ocrEngineConfig.id,
          option: ocrEngineConfig.option,
        );
        break;
    }
  }
  return ocrEngine;
}

class AutoloadOcrClientAdapter extends UniOcrClientAdapter {
  final Map<String, OcrEngine> _ocrEngineMap = {};

  @override
  OcrEngine get first {
    OcrEngineConfig engineConfig = Settings.instance.ocrEngines.first;
    return use(engineConfig.id);
  }

  @override
  OcrEngine use(String identifier) {
    String id = identifier;
    OcrEngineConfig? engineConfig = Settings.instance.getOcrEngine(id);

    OcrEngine? ocrEngine;
    if (_ocrEngineMap.containsKey(engineConfig?.id)) {
      ocrEngine = _ocrEngineMap[engineConfig?.id];
    }

    if (ocrEngine == null) {
      ocrEngine = createOcrEngine(engineConfig!);
      if (ocrEngine != null) {
        _ocrEngineMap.update(
          engineConfig.id,
          (_) => ocrEngine!,
          ifAbsent: () => ocrEngine!,
        );
      }
    }

    return ocrEngine!;
  }

  void renew(String id) {
    _ocrEngineMap.remove(id);
  }
}

UniOcrClient sharedOcrClient = UniOcrClient(AutoloadOcrClientAdapter());
