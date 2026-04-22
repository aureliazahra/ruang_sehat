import 'package:flutter/material.dart';
import 'package:ruang_sehat/features/articles/data/article_models.dart';
import 'package:ruang_sehat/features/articles/data/article_services.dart';

class ArticleProviders with ChangeNotifier {
  List<ArticleModels> _articles = [];
  List<ArticleModels> _myArticles = [];

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  //getter
  List<ArticleModels> get articles => _articles;
  List<ArticleModels> get myArticles => _myArticles;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> getArticles() async {
    _setLoading(true);
    _resetMessage();

    try {
      final result = await ArticleServices.getArticles();

      _articles = result;

      if (result.isNotEmpty) {
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
}
