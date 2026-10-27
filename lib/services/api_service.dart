import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_config.dart';
import '../utils/app_logger.dart';

/// Exception seragam untuk semua kegagalan API.
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors; // detail error validasi (422), jika ada

  ApiException(this.message, {this.statusCode = 0, this.errors});

  @override
  String toString() => message;
}

class ApiService {
  static const String _tokenKey = 'auth_token';

  String get _baseUrl => AppConfig.apiBaseUrl;

  // ---------------- Token (shared_preferences) ----------------

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ---------------- Header ----------------

  Future<Map<String, String>> _headers() async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token'; // ← token disuntik otomatis
    }
    return headers;
  }

  // ---------------- HTTP methods ----------------

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? query}) async {
    final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: query);
    logger.d('GET $uri');
    final response = await http.get(uri, headers: await _headers());
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    logger.d('POST $uri');
    final response = await http.post(uri, headers: await _headers(), body: jsonEncode(body ?? {}));
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    logger.d('PUT $uri');
    final response = await http.put(uri, headers: await _headers(), body: jsonEncode(body ?? {}));
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    logger.d('DELETE $uri');
    final response = await http.delete(uri, headers: await _headers());
    return _processResponse(response);
  }

  // ---------------- Response processing ----------------

  Map<String, dynamic> _processResponse(http.Response response) {
    // Decode manual sebagai UTF-8 agar karakter non-ASCII tidak rusak
    // (paket http default-nya latin1 bila charset tidak disebut di header).
    final decoded = utf8.decode(response.bodyBytes);

    Map<String, dynamic> body;
    try {
      body = jsonDecode(decoded) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Respons server tidak dapat dibaca.', statusCode: response.statusCode);
    }

    final isSuccess = body['success'] == true;

    if (response.statusCode >= 200 && response.statusCode < 300 && isSuccess) {
      return body;
    }

    // Gagal → lempar ApiException dengan pesan & detail dari format baku backend
    logger.e('API error (${response.statusCode}): ${body['message']}');
    throw ApiException(
      body['message']?.toString() ?? 'Terjadi kesalahan.',
      statusCode: response.statusCode,
      errors: body['errors'] is Map ? Map<String, dynamic>.from(body['errors']) : null,
    );
  }
}