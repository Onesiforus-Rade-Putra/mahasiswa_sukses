import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mahasiswa_sukses/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;
  String? accessToken;
  String? refreshToken;

  Future<bool> login({
    required String emailOrUsername,
    required String password,
    required bool rememberMe,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final identifier = emailOrUsername.trim();

      if (identifier.isEmpty) {
        errorMessage = 'Email atau username wajib diisi';
        return false;
      }

      if (password.trim().isEmpty) {
        errorMessage = 'Password wajib diisi';
        return false;
      }

      final result = await _authService.login(
        emailOrUsername: identifier,
        password: password.trim(),
      );

      final token = result['access_token'];
      final refresh = result['refresh_token'];
      final tokenType = result['token_type'];

      if (token == null || token.toString().isEmpty) {
        errorMessage = 'Token login tidak ditemukan';
        return false;
      }

      accessToken = token.toString();
      refreshToken = refresh?.toString();

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', accessToken!);
      await prefs.setString('access_token', accessToken!);

      if (refreshToken != null && refreshToken!.isNotEmpty) {
        await prefs.setString('refresh_token', refreshToken!);
      }

      if (tokenType != null) {
        await prefs.setString('token_type', tokenType.toString());
      }

      if (rememberMe) {
        await prefs.setString('email_or_username', identifier);
      } else {
        await prefs.remove('email_or_username');
      }

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
