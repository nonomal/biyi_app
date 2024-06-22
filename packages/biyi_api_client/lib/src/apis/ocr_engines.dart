import 'dart:async';
import 'package:biyi_api_client/src/models/ocr_engine_config.dart';
import 'package:dio/dio.dart';

class OcrEnginesApi {
  OcrEnginesApi(this._dio, {this.engineId});

  final Dio _dio;
  final String? engineId;

  /// List all OCR engines.
  Future<List<OcrEngineConfig>> list() async {
    final response = await _dio.get('/api/ocr-engines');
    return (response.data as List)
        .map((e) => Map<String, dynamic>.from(e))
        .map((e) => OcrEngineConfig.fromJson(e))
        .toList();
  }

  /// Get an OCR engine.
  Future<OcrEngineConfig> get() async {
    if (engineId == null) {
      throw UnsupportedError('Please provide an engine id.');
    }
    final response = await _dio.get('/api/ocr-engines/$engineId');
    return OcrEngineConfig.fromJson(response.data);
  }
}
