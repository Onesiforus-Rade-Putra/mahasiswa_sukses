import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StudyRoomJoinResult {
  final int id;
  final String title;
  final String description;
  final int maxParticipants;
  final int currentParticipants;
  final bool isJoined;
  final bool isActive;

  StudyRoomJoinResult({
    required this.id,
    required this.title,
    required this.description,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.isJoined,
    required this.isActive,
  });

  factory StudyRoomJoinResult.fromJson(Map<String, dynamic> json) {
    return StudyRoomJoinResult(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      maxParticipants:
          json['max_participants'] is int ? json['max_participants'] : 20,
      currentParticipants: json['current_participants'] is int
          ? json['current_participants']
          : 0,
      isJoined: json['is_joined'] == true,
      isActive: json['is_active'] != false,
    );
  }
}

class ForumService {
  static const String baseUrl = 'https://mahasiswa-sukses-backend.vercel.app';

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token') ??
        prefs.getString('accessToken') ??
        prefs.getString('token');

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getCommunityStats() async {
    final url = Uri.parse('$baseUrl/api/v1/community/stats');

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('COMMUNITY STATS STATUS: ${response.statusCode}');
    debugPrint('COMMUNITY STATS BODY: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Gagal mengambil community stats');
  }

  Future<List<dynamic>> getForumFeed({
    String? category,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
    };

    if (category != null && category != 'Semua') {
      queryParams['category'] = _mapCategoryToApi(category);
    }

    final url = Uri.parse('$baseUrl/api/v1/community/feed/forum').replace(
      queryParameters: queryParams,
    );

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('FORUM FEED STATUS: ${response.statusCode}');
    debugPrint('FORUM FEED BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded;
      }

      if (decoded is Map && decoded['data'] is List) {
        return decoded['data'];
      }

      return [];
    }

    throw Exception('Gagal mengambil forum feed');
  }

  Future<List<dynamic>> getRoomFeed({
    String? query,
  }) async {
    final queryParams = <String, String>{};

    if (query != null && query.trim().isNotEmpty) {
      queryParams['query'] = query.trim();
    }

    final url = Uri.parse('$baseUrl/api/v1/community/feed/room').replace(
      queryParameters: queryParams,
    );

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('ROOM FEED STATUS: ${response.statusCode}');
    debugPrint('ROOM FEED BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded;
      }

      if (decoded is Map && decoded['data'] is List) {
        return decoded['data'];
      }

      return [];
    }

    throw Exception('Gagal mengambil room feed');
  }

  String _mapCategoryToApi(String category) {
    switch (category) {
      case 'Umum':
        return 'umum';
      case 'Tips & Trik':
        return 'tips_trik';
      case 'Bantuan':
        return 'bantuan';
      default:
        return 'umum';
    }
  }

  Future<StudyRoomJoinResult> joinStudyRoom(int roomId) async {
    final url = Uri.parse(
      '$baseUrl/api/v1/community/rooms/$roomId/join',
    );

    final response = await http.post(
      url,
      headers: await _headers(),
    );

    debugPrint('JOIN ROOM STATUS: ${response.statusCode}');
    debugPrint('JOIN ROOM BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return StudyRoomJoinResult.fromJson(decoded);
      }

      throw Exception('Format response join room tidak valid');
    }

    if (response.statusCode == 401) {
      throw Exception('Token login tidak valid. Silakan login ulang.');
    }

    if (response.statusCode == 422) {
      throw Exception('Data join room tidak valid.');
    }

    throw Exception('Gagal join study room');
  }

  Future<List<dynamic>> getChatHistory(int roomId) async {
    final url = Uri.parse(
      '$baseUrl/api/v1/community/rooms/$roomId/messages',
    ).replace(
      queryParameters: {
        'limit': '50',
      },
    );

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('CHAT HISTORY STATUS: ${response.statusCode}');
    debugPrint('CHAT HISTORY BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded;
      }

      if (decoded is Map && decoded['data'] is List) {
        return decoded['data'];
      }

      if (decoded is Map && decoded['messages'] is List) {
        return decoded['messages'];
      }

      return [];
    }

    if (response.statusCode == 401) {
      throw Exception('Token login tidak valid. Silakan login ulang.');
    }

    throw Exception('Gagal mengambil chat history');
  }

  Future<Map<String, dynamic>> sendChatMessage({
    required int roomId,
    required String content,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/v1/community/rooms/$roomId/messages',
    );

    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({
        'content': content,
      }),
    );

    debugPrint('SEND CHAT STATUS: ${response.statusCode}');
    debugPrint('SEND CHAT BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      throw Exception('Token login tidak valid. Silakan login ulang.');
    }

    if (response.statusCode == 422) {
      throw Exception('Pesan tidak valid.');
    }

    throw Exception('Gagal mengirim pesan');
  }

  Future<Map<String, dynamic>> createPost({
    required String title,
    required String content,
    required String category,
    required List<String> tags,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/community/posts');

    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({
        'title': title,
        'content': content,
        'category': category,
        'tags': tags,
      }),
    );

    debugPrint('CREATE POST STATUS: ${response.statusCode}');
    debugPrint('CREATE POST BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      throw Exception('Token login tidak valid. Silakan login ulang.');
    }

    if (response.statusCode == 422) {
      throw Exception('Data postingan tidak valid.');
    }

    throw Exception('Gagal membuat postingan forum');
  }

  Future<Map<String, dynamic>> createRoom({
    required String title,
    required String description,
    required int maxParticipants,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/community/room');

    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({
        'title': title,
        'description': description,
        'max_participants': maxParticipants,
      }),
    );

    debugPrint('CREATE ROOM STATUS: ${response.statusCode}');
    debugPrint('CREATE ROOM BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      throw Exception('Token login tidak valid. Silakan login ulang.');
    }

    if (response.statusCode == 422) {
      throw Exception('Data ruang belajar tidak valid.');
    }

    throw Exception('Gagal membuat ruang belajar');
  }

  Future<Map<String, dynamic>> toggleRoomLike({
    required int roomId,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/v1/community/room/$roomId/like',
    ).replace(
      queryParameters: {
        'room_id': roomId.toString(),
      },
    );

    final response = await http.post(
      url,
      headers: await _headers(),
    );

    debugPrint('TOGGLE ROOM LIKE STATUS: ${response.statusCode}');
    debugPrint('TOGGLE ROOM LIKE BODY: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      throw Exception('Token login tidak valid. Silakan login ulang.');
    }

    throw Exception('Gagal like ruang belajar');
  }

  Future<void> leaveStudyRoom(int roomId) async {
    final url = Uri.parse(
      '$baseUrl/api/v1/community/rooms/$roomId/leave',
    );

    final response = await http.delete(
      url,
      headers: await _headers(),
    );

    debugPrint('LEAVE ROOM STATUS: ${response.statusCode}');
    debugPrint('LEAVE ROOM BODY: ${response.body}');

    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 401) {
      throw Exception('Token login tidak valid. Silakan login ulang.');
    }

    throw Exception('Gagal keluar dari ruang belajar');
  }
}
