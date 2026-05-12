import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/leaderboard_model.dart';

class LeaderboardService {
  static const String baseUrl = 'https://mahasiswa-sukses-backend.vercel.app';

  Future<LeaderboardResponse> getLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('accessToken') ??
        prefs.getString('access_token') ??
        prefs.getString('token');

    final url = Uri.parse('$baseUrl/api/v1/gamification/leaderboard');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    debugPrint('LEADERBOARD STATUS: ${response.statusCode}');
    debugPrint('LEADERBOARD BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return LeaderboardResponse.fromJson(decoded);
      }

      throw Exception('Format response leaderboard tidak valid');
    }

    throw Exception(
      'Gagal mengambil leaderboard. Status: ${response.statusCode}',
    );
  }
}
