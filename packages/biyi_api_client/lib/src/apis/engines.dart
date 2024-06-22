import 'dart:async';
import 'package:biyi_api_client/src/models/translation_engine_config.dart';
import 'package:dio/dio.dart';

class EnginesApi {
  EnginesApi(this._dio, {this.engineId});

  final Dio _dio;
  final String? engineId;

  /// List all translation engines.
  Future<List<TranslationEngineConfig>> list() async {
    final response = await _dio.get('/api/engines');
    return (response.data as List)
        .map((e) => Map<String, dynamic>.from(e))
        .map((e) => TranslationEngineConfig.fromJson(e))
        .toList();
  }

  /// Get an engine.
  Future<TranslationEngineConfig> get() async {
    if (engineId == null) {
      throw UnsupportedError('Please provide an engine id.');
    }
    final response = await _dio.get('/api/engines/$engineId');
    return TranslationEngineConfig.fromJson(response.data);
  }
}
