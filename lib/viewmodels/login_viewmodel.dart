import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;
  String? accessToken;

  Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (email.trim().isEmpty) {
        errorMessage = "Email wajib diisi";
        return false;
      }
      if (!email.contains('@')) {
        errorMessage = "Format email tidak valid";
        return false;
      }
      if (password.isEmpty) {
        errorMessage = "Password wajib diisi";
        return false;
      }
      final result = await _authService.login(
        email: email,
        password: password,
      );
      if (result['access_token'] != null) {
        accessToken = result['access_token'];

        final prefs = await SharedPreferences.getInstance();

        // token harus selalu disimpan untuk session login
        await prefs.setString('token', accessToken!);

        // remember me cukup untuk email saja
        if (rememberMe) {
          await prefs.setString('email', email);
        } else {
          await prefs.remove('email');
        }

        return true;
      } else {
        errorMessage = "Email atau password salah";
        return false;
      }
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
