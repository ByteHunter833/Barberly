import 'dart:convert';

import 'package:barberly/core/storage/localstorage_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.barberly.uz/api';
  String? _token;
  Future<void> loadToken() async {
    final token = await LocalStorage.getToken();
    if (token != null) {
      _token = token;
      print('➡️ Token loaded from LocalStorage');
    } else {
      _token = null;
      print('⚠️ No token in storage');
    }
  }

  // Или обычный сеттер

  void setToken(String token) => _token = token;
  void clearToken() => _token = null;

  Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
      print('➡️ Authorization added: Bearer $_token');
    } else {
      print('⚠️ No token! Request will go without Authorization');
    }
    return headers;
  }

  // GET
  Future<dynamic> getData(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url, headers: _headers());
    return _processResponse(response);
  }

  // POST
  Future<dynamic> postData(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // PUT
  Future<dynamic> putData(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(
      url,
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // PATCH
  Future<dynamic> patchData(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.patch(
      url,
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // DELETE
  Future<dynamic> deleteData(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.delete(url, headers: _headers());
    return _processResponse(response);
  }

  // Общая обработка ответа
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Status: ${response.statusCode}');
      print('Content-Type: ${response.headers['content-type']}');
      print('Body: ${response.body}');

      return jsonDecode(response.body);
    } else {
      throw Exception('Ошибка ${response.statusCode}: ${response.body}');
    }
  }
}
