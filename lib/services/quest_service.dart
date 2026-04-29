import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quest_model.dart';

class QuestService {
  static const String baseUrl = 'https://mahasiswa-sukses-backend.vercel.app';

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

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

  Future<List<QuestModel>> getQuests({
    String? frequency,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/gamification/quests').replace(
      queryParameters: frequency == null
          ? null
          : {
              'frequency': frequency,
            },
    );

    final response = await http.get(
      uri,
      headers: await _headers(),
    );

    debugPrint('GET QUESTS STATUS: ${response.statusCode}');
    debugPrint('GET QUESTS BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data
            .map((item) => QuestModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Format data quest tidak valid');
    }

    throw Exception('Gagal mengambil quest');
  }
}
