import 'package:biyi_api_client/biyi_api_client.dart';
import 'package:uni_translate_client/uni_translate_client.dart';

class ProTranslationEngine extends TranslationEngine {
  ProTranslationEngine(
    this.config, {
    required this.apiClient,
  }) : super(identifier: config.id, option: config.option);

  TranslationEngineConfig config;
  final ApiClient apiClient;

  @override
  List<TranslationEngineScope> get supportedScopes => config.supportedScopes;

  @override
  Future<DetectLanguageResponse> detectLanguage(DetectLanguageRequest request) {
    throw UnsupportedError('detectLanguage');
  }

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) {
    throw UnsupportedError('lookUp');
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) {
    throw UnsupportedError('translate');
  }
}
