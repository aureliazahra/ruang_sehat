import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ruang_sehat/features/articles/data/article_models.dart';
import 'package:ruang_sehat/features/articles/data/article_services.dart';

class ArticleProviders with ChangeNotifier {
  List<ArticleModels> _articles = [];
  List<ArticleModels> _myArticles = [];
  ArticleModels? _detailArticle;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  //getter
  List<ArticleModels> get articles => _articles;
  List<ArticleModels> get myArticles => _myArticles;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  ArticleModels? get detailArticle => _detailArticle;

  Future<void> getArticles() async {
    _setLoading(true);
    _resetMessage();

    try {
      final result = await ArticleServices.getArticles();

      _articles = result;

      if (result.isEmpty) {
        _errorMessage = 'Data artikel kosong';
      }
    } catch (err) {
      _errorMessage = _parseError(err);
      _articles = [];
    } finally {
      _setLoading(false);
    }
  }

  //Helper
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _resetMessage() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  String _parseError(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }

  //get all articles
  Future<void> getMyArticles() async {
    _setLoading(true);
    _resetMessage();

    try {
      final result = await ArticleServices.getMyArticles();
      _myArticles = result;
    } catch (err) {
      _errorMessage = _parseError(err);
      _myArticles = [];
    } finally {
      _setLoading(false);
    }
  }

  //get detail article
  Future<void> getDetailArticle(String id) async {
    _setLoading(true);
    _resetMessage();

    try {
      final result = await ArticleServices.getDetailArticle(id);
      _detailArticle = result;
    } catch (e) {
      _errorMessage = _parseError(e);
      _detailArticle = null;
    } finally {
      _setLoading(false);
    }
  }

  // craate article
  Future<void> createArtikel(
    String title,
    String description,
    String category,
    String imagePath,
  ) async {
    _setLoading(true);
    _resetMessage();

    try {
      final streamedResponse = await ArticleServices.createArtikel(
        File(imagePath),
        title,
        description,
        category,
      );

      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        await getMyArticles();
        await getArticles();
        _successMessage = data['message'] ?? 'Artikel berhasil dibuat';
      } else if (response.statusCode == 400) {
        final firstError = data['errors'][0];
        _errorMessage = firstError['0'];
      } else {
        _errorMessage = data['message'] ?? 'Terjadi kesalahan';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // update article
  Future<void> updateArticle(
    String id, {
    String? title,
    String? description,
    String? category,
    String? imagePath,
  }) async {
    _setLoading(true);
    _resetMessage();

    try {
      final streamedResponse = await ArticleServices.updateArtikel(
        id,
        title: title,
        description: description,
        category: category,
        image: imagePath != null ? File(imagePath) : null,
      );

      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        await getMyArticles();
        await getArticles();
        await getDetailArticle(id);
      } else if (response.statusCode == 400) {
        final firstError = data['errors'][0];
        _errorMessage = firstError['message'] ?? "Terjadi kesalahan";
      } else {
        _errorMessage = data["messages"] ?? 'Terjadi Kesalahan';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  //delete article
  Future<void> deleteArticle(String id) async {
    _setLoading(true);
    _resetMessage();

    try {
      final result = await ArticleServices.deleteArticle(id);

      final data = jsonDecode(result.body);

      if (result.statusCode == 200) {
        await getMyArticles();
        await getArticles();
        _successMessage = data['message'] ?? 'Artikel berhasil dihapus';
      } else if (result.statusCode == 400) {
        final firstError = data['errors'][0];
        _errorMessage = firstError['message'] ?? 'Terjadi kesalahan';
      } else {
        _errorMessage = data['message'] ?? 'Terjadi kesalahan';
      }
    } catch (e) {
      _errorMessage = _parseError(e);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }
}
