import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String baseUrl = dotenv.env['BASE_URL']!;
  static String authBaseUrl = '$baseUrl/auth';

  //fungsi service register
  static Future<http.Response> register(
    String name,
    String username,
    String password,
  ) async {
    final url = Uri.parse('$authBaseUrl/register');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'username': username,
        'password': password,
        'appSource': 'kesehatan',
      }),
    );
  }

  //fungsi service login
  static Future<http.Response> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'appSource': 'kesehatan',
      }),
    );
  }

  //fungsi service logout
  static Future<http.Response> logout() async {
    final uri = Uri.parse('$authBaseUrl/logout');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await http.post(
      uri,
      headers: {
        'Content-Type': 'application.json',
        'Authentication': 'Bearer $token',
      },
    );
  }
}
