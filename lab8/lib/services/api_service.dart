import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post_model.dart';

/// Service layer: tách logic gọi API ra khỏi UI.
class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<PostModel>> fetchPosts() async {
    final uri = Uri.parse('$_baseUrl/posts');

    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to load posts (${response.statusCode})');
    }

    final decoded = json.decode(response.body) as List<dynamic>;
    return decoded
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Đảm bảo client được đóng đúng cách (hỗ trợ test/đóng vòng đời app).
  void close() => _client.close();
}

