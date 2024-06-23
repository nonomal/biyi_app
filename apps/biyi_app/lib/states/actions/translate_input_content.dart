// TODO(lijy91): ModifierKey is deprecated, fix it later.
// ignore_for_file: deprecated_member_use

import 'package:biyi_app/services/translate_client/translate_client.dart';
import 'package:biyi_app/states/settings.dart';
import 'package:biyi_app/utils/language_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:keypress_simulator/keypress_simulator.dart';
import 'package:screen_text_extractor/screen_text_extractor.dart';
import 'package:uni_platform/uni_platform.dart';
import 'package:uni_translate_client/uni_translate_client.dart';

class TranslateInputContentIntent extends Intent {}

class TranslateInputContentAction extends Action<TranslateInputContentIntent> {
  Future<void> _simulateSelectAll() async {
    await keyPressSimulator.simulateKeyDown(
      PhysicalKeyboardKey.keyA,
      UniPlatform.select<List<ModifierKey>>(
        macos: [ModifierKey.metaModifier],
        otherwise: [ModifierKey.controlModifier],
      ),
    );
    await keyPressSimulator.simulateKeyUp(
      PhysicalKeyboardKey.keyA,
      UniPlatform.select<List<ModifierKey>>(
        macos: [ModifierKey.metaModifier],
        otherwise: [ModifierKey.controlModifier],
      ),
    );
  }

  Future<void> _simulateCopy() async {
    await keyPressSimulator.simulateKeyDown(
      PhysicalKeyboardKey.keyC,
      UniPlatform.select<List<ModifierKey>>(
        macos: [ModifierKey.metaModifier],
        otherwise: [ModifierKey.controlModifier],
      ),
    );
    await keyPressSimulator.simulateKeyUp(
      PhysicalKeyboardKey.keyC,
      UniPlatform.select<List<ModifierKey>>(
        macos: [ModifierKey.metaModifier],
        otherwise: [ModifierKey.controlModifier],
      ),
    );
  }

  Future<void> _simulatePaste() async {
    await keyPressSimulator.simulateKeyDown(
      PhysicalKeyboardKey.keyC,
      UniPlatform.select<List<ModifierKey>>(
        macos: [ModifierKey.metaModifier],
        otherwise: [ModifierKey.controlModifier],
      ),
    );
    await keyPressSimulator.simulateKeyUp(
      PhysicalKeyboardKey.keyC,
      UniPlatform.select<List<ModifierKey>>(
        macos: [ModifierKey.metaModifier],
        otherwise: [ModifierKey.controlModifier],
      ),
    );
  }

  @override
  Future<void> invoke(covariant TranslateInputContentIntent intent) async {
    await _simulateSelectAll();
    await _simulateCopy();

    try {
      ExtractedData? extractedData = await screenTextExtractor.extract(
        mode: ExtractMode.screenSelection,
      );

      if ((extractedData?.text ?? '').isEmpty) {
        throw Exception('Extracted text is empty');
      }

      TranslateResponse translateResponse = await translateClient
          .use(Settings.instance.defaultTranslationEngineId!)
          .translate(
            TranslateRequest(
              text: extractedData?.text ?? '',
              sourceLanguage: kLanguageZH,
              targetLanguage: kLanguageEN,
            ),
          );

      TextTranslation? textTranslation =
          (translateResponse.translations).firstOrNull;

      if (textTranslation != null) {
        Clipboard.setData(ClipboardData(text: textTranslation.text));
      }
    } catch (error) {
      return;
    }

    await _simulateSelectAll();
    await _simulatePaste();
  }
}
