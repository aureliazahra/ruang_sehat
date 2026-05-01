import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ruang_sehat/features/articles/data/article_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ArticleServices {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  static final String articleBaseUrl = '$baseUrl/article';

  // Helper GET Request
  static Future<dynamic> _getRequest(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }

    var uriString = '$articleBaseUrl$endpoint';

    if (queryParameters != null && queryParameters.isNotEmpty) {
      final queryString = Uri(queryParameters: queryParameters).query;
      uriString += '?$queryString';
    }

    final url = Uri.parse(uriString);

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
        throw Exception(decoded['message'] ?? 'Terjadi kesalahan');
      }
    }

    return decoded['data'];
  }

  // Get All Articles (With Pagination Params)
  static Future<List<ArticleModels>> getArticles({
    int page = 1,
    int limit = 10,
  }) async {
    final data = await _getRequest(
      '',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );

    final List articles = data['articles'] ?? [];

    return articles
        .map((e) => ArticleModels.fromJson(e))
        .toList();
  }

  // Get My Articles
  static Future<List<ArticleModels>> getMyArticles() async {
    final data = await _getRequest('/user');
    final List articles = data['articles'] ?? [];

    return articles
        .map((e) => ArticleModels.fromJson(e))
        .toList();
  }

  // Get Detail Article
  static Future<ArticleModels> getDetailArticle(String id) async {
    final data = await _getRequest('/$id');
    return ArticleModels.fromJson(data);
  }

  // Create Article
  static Future<http.StreamedResponse> createArtikel(
    File image,
    String title,
    String description,
    String category,
  ) async {
    final uri = Uri.parse('$articleBaseUrl/create');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['date'] = DateTime.now().toIso8601String(); // ✅ fixed
    request.fields['category'] = category;

    request.files.add(
      await http.MultipartFile.fromPath('image', image.path),
    );

    return await request.send();
  }

  // Update Article
  static Future<http.StreamedResponse> updateArtikel(
    String id, {
    File? image,
    String? title,
    String? description,
    String? category,
  }) async {
    final uri = Uri.parse('$articleBaseUrl/update/$id');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    if (title != null && title.isNotEmpty) {
      request.fields['title'] = title;
    }

    if (description != null && description.isNotEmpty) {
      request.fields['description'] = description;
    }

    if (category != null && category.isNotEmpty) {
      request.fields['category'] = category;
    }

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );
    }

    return await request.send();
  }

  // Delete Article
  static Future<http.Response> deleteArticle(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('$articleBaseUrl/$id');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }
}
