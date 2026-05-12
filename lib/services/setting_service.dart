import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SettingUserModel {
  final String username;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final bool shareLeaderboardStats;

  const SettingUserModel({
    required this.username,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    required this.shareLeaderboardStats,
  });

  factory SettingUserModel.fromJson(Map<String, dynamic> json) {
    return SettingUserModel(
      username: json['username']?.toString() ??
          json['user_name']?.toString() ??
          'User',
      fullName: json['full_name']?.toString() ?? 'User',
      email: json['email']?.toString() ?? '-',
      avatarUrl: json['avatar_url']?.toString(),
      shareLeaderboardStats: json['share_leaderboard_stats'] == true,
    );
  }
}

class SettingService {
  static const String baseUrl = 'https://mahasiswa-sukses-backend.vercel.app';

  // Kalau path Get My Profile di Apidog beda, ubah bagian ini saja.
  static const String profilePath = '/api/v1/user/profile';

  // Kalau path Update Settings di Apidog beda, ubah bagian ini saja.
  static const String updateSettingsPath = '/api/v1/user/settings';

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token') ??
        prefs.getString('token') ??
        prefs.getString('accessToken') ??
        prefs.getString('authToken');

    if (token == null || token.trim().isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    return token.trim();
  }

  Map<String, String> _headers(String token) {
    final bearerToken =
        token.toLowerCase().startsWith('bearer ') ? token : 'Bearer $token';

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': bearerToken,
    };
  }

  Map<String, dynamic> _extractMap(String body) {
    if (body.trim().isEmpty || body == 'null') return {};

    final decoded = jsonDecode(body);

    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'] ?? decoded['user'] ?? decoded['result'];

      if (data is Map<String, dynamic>) {
        return data;
      }

      return decoded;
    }

    return {};
  }

  String _errorMessage(http.Response response, String fallback) {
    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        final message =
            decoded['message'] ?? decoded['error'] ?? decoded['detail'];

        if (message != null) {
          return '$fallback. Status: ${response.statusCode}, Body: $decoded';
        }
      }
    } catch (_) {}

    return '$fallback. Status: ${response.statusCode}, Body: ${response.body}';
  }

  Future<SettingUserModel> getMyProfile() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl$profilePath'),
      headers: _headers(token),
    );

    debugPrint('SETTING PROFILE STATUS: ${response.statusCode}');
    debugPrint('SETTING PROFILE BODY: ${response.body}');

    if (response.statusCode == 200) {
      return SettingUserModel.fromJson(_extractMap(response.body));
    }

    throw Exception(
      _errorMessage(response, 'Gagal mengambil profile'),
    );
  }

  Future<void> updateShareLeaderboardStats(bool value) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl$updateSettingsPath'),
      headers: _headers(token),
      body: jsonEncode({
        'share_leaderboard_stats': value,
      }),
    );

    debugPrint('UPDATE SETTINGS STATUS: ${response.statusCode}');
    debugPrint('UPDATE SETTINGS BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    throw Exception(
      _errorMessage(response, 'Gagal mengubah pengaturan'),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('token_type');

    await prefs.remove('accessToken');
    await prefs.remove('authToken');
    await prefs.remove('user');
    await prefs.remove('user_id');
    await prefs.remove('is_logged_in');
    await prefs.remove('isLogin');
  }
}
