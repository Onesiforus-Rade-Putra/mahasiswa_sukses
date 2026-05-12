import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/achievement_model.dart';

class AchievementService {
  static const String baseUrl = 'https://mahasiswa-sukses-backend.vercel.app';

  Future<AchievementModel> getAchievementData() async {
    final token = await _getToken();

    final achievementUrl = Uri.parse(
      '$baseUrl/api/v1/gamification/achievement',
    );

    final summaryUrl = Uri.parse(
      '$baseUrl/api/v1/gamification/summary',
    );

    final responses = await Future.wait([
      http.get(achievementUrl, headers: _headers(token)),
      http.get(summaryUrl, headers: _headers(token)),
    ]);

    final achievementResponse = responses[0];
    final summaryResponse = responses[1];

    _validateResponse(achievementResponse, 'achievement');
    _validateResponse(summaryResponse, 'summary');

    final achievementList = _extractList(achievementResponse.body);
    final summaryJson = _extractMap(summaryResponse.body);

    final badges = achievementList
        .where((item) => item is Map)
        .map(
          (item) => AchievementBadgeModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();

    final achievedCount = badges.where((badge) => badge.isCompleted).length;
    final totalAchievement = badges.length < 5 ? 5 : badges.length;

    final summary = AchievementSummaryModel.fromApi(
      summaryJson,
      achieved: achievedCount,
      totalAchievement: totalAchievement,
    );

    final tracks = [
      AchievementTrackModel(
        title: 'Total Quest Selesai',
        subtitle: '${summary.totalQuestCompleted} Quest',
        iconType: 'trophy',
      ),
      AchievementTrackModel(
        title: 'Forum Post',
        subtitle: '8 Postingan',
        iconType: 'forum',
      ),
      AchievementTrackModel(
        title: 'Streak Terpanjang',
        subtitle: '${summary.currentStreak} Hari',
        iconType: 'flash',
      ),
    ];

    return AchievementModel(
      summary: summary,
      badges: badges,
      tracks: tracks,
    );
  }

  Map<String, String> _headers(String token) {
    final authorizationValue =
        token.toLowerCase().startsWith('bearer ') ? token : 'Bearer $token';

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authorizationValue,
    };
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();

    const possibleKeys = [
      'accessToken',
      'access_token',
      'token',
      'authToken',
    ];

    for (final key in possibleKeys) {
      final value = prefs.getString(key);
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    throw Exception('Token login tidak ditemukan. Silakan login ulang.');
  }

  void _validateResponse(http.Response response, String source) {
    if (response.statusCode == 401) {
      throw Exception('Sesi login berakhir. Silakan login ulang.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal mengambil data $source: ${response.statusCode}',
      );
    }
  }

  List<dynamic> _extractList(String body) {
    if (body.trim().isEmpty) return [];

    final decoded = jsonDecode(body);

    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map) {
      final possibleData = decoded['data'] ??
          decoded['result'] ??
          decoded['achievements'] ??
          decoded['items'];

      if (possibleData is List) {
        return possibleData;
      }
    }

    return [];
  }

  Map<String, dynamic> _extractMap(String body) {
    if (body.trim().isEmpty) return {};

    final decoded = jsonDecode(body);

    if (decoded is Map) {
      final possibleData = decoded['data'] ?? decoded['result'];

      if (possibleData is Map) {
        return Map<String, dynamic>.from(possibleData);
      }

      return Map<String, dynamic>.from(decoded);
    }

    return {};
  }
}
