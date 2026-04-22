import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ruang_sehat/features/articles/data/article_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticleServices {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  static final String articleBaseUrl = '$baseUrl/article';

  //helper private
  static Future<dynamic> _getRequest(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token == null) throw Exception('Token not found');

    final url = Uri.parse('$articleBaseUrl$endpoint');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Server Error: ${response.statusCode}');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception('Format response tidak valid');
    }

    if (decoded['success'] != true) {
      if (decoded['errors'] != null &&
          decoded['errors'] is List &&
          decoded['errors'].isNotEmpty) {
        throw Exception(decoded['errors'][0]['message']);
      } else {
        throw Exception(decoded['messages'] ?? 'Terjadi kesalahan');
      }
    }

    return decoded['data'];
  }

  //get all articles
  static Future<List<ArticleModels>> getArticles() async {
    final data = await _getRequest('');
    final List articles = data['articles'] ?? [];
    return articles.map((e) => ArticleModels.fromJson(e)).toList();
  }

  // get my articless
  static Future<List<ArticleModels>> getMyArticles() async {
    final data = await _getRequest('/user');
    final List articles = data['articles'] ?? [];
    return articles.map((e) => ArticleModels.fromJson(e)).toList();
  }
}
