// ============================================================
// [Software Eng] API Service Layer
// ============================================================
// Connects Flutter app to the MisinfoGuard FastAPI backend.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prediction.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  Future<HealthResponse> health() async {
    final response = await _client.get(Uri.parse('$baseUrl/health'));
    if (response.statusCode == 200) {
      return HealthResponse.fromJson(json.decode(response.body));
    }
    throw ApiException('Health check failed: ${response.statusCode}');
  }

  Future<PredictionResponse> predict(PredictionRequest request) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );
    if (response.statusCode == 200) {
      return PredictionResponse.fromJson(json.decode(response.body));
    }
    throw ApiException('Prediction failed: ${response.statusCode}');
  }

  Future<ModelInfo> modelInfo() async {
    final response = await _client.get(Uri.parse('$baseUrl/model/info'));
    if (response.statusCode == 200) {
      return ModelInfo.fromJson(json.decode(response.body));
    }
    throw ApiException('Model info failed: ${response.statusCode}');
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
