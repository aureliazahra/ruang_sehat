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
  List<ArticleModels> _featuredArticles = [];

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  bool _hasNextPage = true;

  //getter
  List<ArticleModels> get articles => _articles;
  List<ArticleModels> get myArticles => _myArticles;
  List<ArticleModels> get featuredArticles => _featuredArticles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasNextPage => _hasNextPage;
  ArticleModels? get detailArticle => _detailArticle;

  Future<void> getArticles({bool isRefresh = true}) async {
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

  void _setFetchingMore(bool value) {
    _isFetchingMore = value;
    notifyListeners();
  }

  //get all articles
  Future<void> getMyArticles({bool isRefresh = true}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasNextPage = true;
    } else {
      if (!_hasNextPage || _isFetchingMore) return;

      _setFetchingMore(true);
    }

    _resetMessage();

    try {
      final result = await ArticleServices.getArticles(
        page: _currentPage,
        limit: 5,
      );

      final List<ArticleModels> data = result;
      final int totalPages = result.isEmpty ? _currentPage : _currentPage + 1;
      if (isRefresh) {
        _articles = data;

        if (totalPages > 3) {
          final lastPageData = await ArticleServices.getArticles(
            page: totalPages,
            limit: 5,
          );

          final List<ArticleModels> lastPageArticles = lastPageData;

          _featuredArticles = lastPageArticles;
        } else {
          // jika hanya ada 1 hlaman, ambil data terbawah dari halaman tersebut
          _featuredArticles = data.length > 5
              ? data.sublist(data.length - 5)
              : List.from(
                  data,
                ); // ambil 5 artikel terakhir atau semua jika kurang dari 5
        }
      } else {
        // Tambahkan data baru ke list recomended
        _articles.addAll(data);
      }

      if (data.isEmpty || data.length < 5) {
        _hasNextPage = false;
      } else {
        _currentPage++;
      }

      if (result.isEmpty && isRefresh) {
        _errorMessage = 'data artikel kosong';
      }
    } catch (err) {
      _errorMessage = _parseError(err);
      if (isRefresh) {
        _articles = [];
      }
    } finally {
      if (!isRefresh) {
        _setLoading(false);
      } else {
        _setFetchingMore(false);
      }
    }

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
