import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ruang_sehat/features/auth/data/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // provider register
  Future<bool> register(String name, String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.register(name, username, password);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        _successMessage = data['message'] ?? 'Registration successful';
        return true;
      } else {
        if (data['errors'] != null && data['errors'].length > 0) {
          final firstError = data['errors'][0];
          _errorMessage = firstError['message'];
        } else {
          _errorMessage = data['message'] ?? 'Something went wrong';
        }
        return false;
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // provider login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.login(username, password);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final token = data['data']['token'];

        //simpan token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        _successMessage = data['message'] ?? 'Login successful';
        return true;
      } else {
        if (data['errors'] != null && data['errors'].length > 0) {
          final firstError = data['errors'][0];
          _errorMessage = firstError['message'];
        } else {
          _errorMessage = data['message'] ?? 'Something went wrong';
        }
        return false;
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
