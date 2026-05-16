import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quest_model.dart';

class QuestService {
  static const String baseUrl = 'https://mahasiswa-sukses-backend.vercel.app';

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token') ??
        prefs.getString('accessToken') ??
        prefs.getString('access_token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    return token;
  }

  Future<Map<String, String>> _headers() async {
    final token = await _getToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<QuestModel>> getQuests() async {
    final uri = Uri.parse('$baseUrl/api/v1/gamification/quests');

    final response = await http.get(
      uri,
      headers: await _headers(),
    );

    debugPrint('GET QUESTS URL: $uri');
    debugPrint('GET QUESTS STATUS: ${response.statusCode}');
    debugPrint('GET QUESTS BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List data;

      if (decoded is List) {
        data = decoded;
      } else if (decoded is Map<String, dynamic>) {
        if (decoded['data'] is List) {
          data = decoded['data'];
        } else if (decoded['quests'] is List) {
          data = decoded['quests'];
        } else if (decoded['data'] is Map<String, dynamic> &&
            decoded['data']['quests'] is List) {
          data = decoded['data']['quests'];
        } else {
          throw Exception('Format data quest tidak valid');
        }
      } else {
        throw Exception('Format response quest tidak valid');
      }

      return data
          .map((item) => QuestModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 401) {
      throw Exception('Sesi login habis. Silakan login ulang.');
    }

    throw Exception('Gagal mengambil quest. Status: ${response.statusCode}');
  }
}
