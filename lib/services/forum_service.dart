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
      id: _toInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      maxParticipants: _toInt(json['max_participants'], defaultValue: 20),
      currentParticipants: _toInt(json['current_participants']),
      isJoined: json['is_joined'] == true,
      isActive: json['is_active'] != false,
    );
  }

  static int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? defaultValue;
  }
}

class ForumService {
  static const String baseUrl = 'https://mahasiswa-sukses-backend.vercel.app';
  static const String _communityPath = '/api/v1/community';

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

  dynamic _decodeBody(http.Response response) {
    if (response.body.trim().isEmpty || response.body.trim() == 'null') {
      return null;
    }

    return jsonDecode(response.body);
  }

  String _readErrorMessage(http.Response response, String fallback) {
    try {
      final decoded = _decodeBody(response);

      if (decoded is Map) {
        final message = decoded['message'] ??
            decoded['error'] ??
            decoded['detail'] ??
            decoded['errors'];

        if (message != null) {
          return message.toString();
        }
      }
    } catch (_) {}

    return fallback;
  }

  List<dynamic> _extractList(dynamic decoded) {
    if (decoded is List) return decoded;

    if (decoded is Map && decoded['data'] is List) {
      return decoded['data'] as List;
    }

    if (decoded is Map && decoded['items'] is List) {
      return decoded['items'] as List;
    }

    if (decoded is Map && decoded['messages'] is List) {
      return decoded['messages'] as List;
    }

    if (decoded is Map && decoded['comments'] is List) {
      return decoded['comments'] as List;
    }

    return [];
  }

  Map<String, dynamic> _extractMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) return decoded;

    if (decoded is Map && decoded['data'] is Map<String, dynamic>) {
      return decoded['data'] as Map<String, dynamic>;
    }

    return {};
  }

  String? _mapCategoryToApi(String? category) {
    final value = category?.trim();

    switch (value) {
      case null:
      case '':
      case 'Semua':
        return null;
      case 'Umum':
      case 'umum':
        return 'umum';
      case 'Tips & Trik':
      case 'Tips & trik':
      case 'tips_trik':
        return 'tips_trik';
      case 'Bantuan':
      case 'bantuan':
        return 'bantuan';
      default:
        return null;
    }
  }

  Future<Map<String, dynamic>> getCommunityStats() async {
    final url = Uri.parse('$baseUrl$_communityPath/stats');

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('COMMUNITY STATS STATUS: ${response.statusCode}');
    debugPrint('COMMUNITY STATS BODY: ${response.body}');

    if (response.statusCode == 200) {
      return _extractMap(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal mengambil community stats'),
    );
  }

  Future<List<dynamic>> getForumFeed({
    String? category,
    String? tag,
  }) async {
    final queryParams = <String, String>{};

    final apiCategory = _mapCategoryToApi(category);
    if (apiCategory != null) {
      queryParams['category'] = apiCategory;
    }

    if (tag != null && tag.trim().isNotEmpty) {
      queryParams['tag'] = tag.trim();
    }

    final url = Uri.parse('$baseUrl$_communityPath/feed/forum').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('FORUM FEED STATUS: ${response.statusCode}');
    debugPrint('FORUM FEED BODY: ${response.body}');

    if (response.statusCode == 200) {
      return _extractList(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal mengambil forum feed'),
    );
  }

  Future<Map<String, dynamic>> createPost({
    required String title,
    required String content,
    required String category,
    required List<String> tags,
  }) async {
    final url = Uri.parse('$baseUrl$_communityPath/posts');

    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({
        'title': title,
        'content': content,
        'category': _mapCategoryToApi(category) ?? 'umum',
        'tags': tags,
      }),
    );

    debugPrint('CREATE POST STATUS: ${response.statusCode}');
    debugPrint('CREATE POST BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return _extractMap(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal membuat postingan forum'),
    );
  }

  Future<Map<String, dynamic>> getPostDetail(int postId) async {
    final url = Uri.parse('$baseUrl$_communityPath/posts/$postId');

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('POST DETAIL STATUS: ${response.statusCode}');
    debugPrint('POST DETAIL BODY: ${response.body}');

    if (response.statusCode == 200) {
      return _extractMap(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal mengambil detail postingan'),
    );
  }

  Future<Map<String, dynamic>> commentOnPost({
    required int postId,
    required String comment,
  }) async {
    final url = Uri.parse('$baseUrl$_communityPath/posts/$postId/comment');

    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({
        'comment': comment,
      }),
    );

    debugPrint('COMMENT POST STATUS: ${response.statusCode}');
    debugPrint('COMMENT POST BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return _extractMap(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal mengirim komentar'),
    );
  }

  Future<List<dynamic>> getPostComments(int postId) async {
    final url = Uri.parse('$baseUrl$_communityPath/posts/$postId/comments');

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('POST COMMENTS STATUS: ${response.statusCode}');
    debugPrint('POST COMMENTS BODY: ${response.body}');

    if (response.statusCode == 200) {
      return _extractList(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal mengambil komentar postingan'),
    );
  }

  Future<Map<String, dynamic>> togglePostLike(int postId) async {
    final url = Uri.parse('$baseUrl$_communityPath/posts/$postId/like');

    final response = await http.post(
      url,
      headers: await _headers(),
    );

    debugPrint('TOGGLE POST LIKE STATUS: ${response.statusCode}');
    debugPrint('TOGGLE POST LIKE BODY: ${response.body}');

    if (response.statusCode == 200) {
      return _extractMap(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal like postingan'),
    );
  }

  Future<List<dynamic>> getRoomFeed({
    String? query,
  }) async {
    final queryParams = <String, String>{};

    if (query != null && query.trim().isNotEmpty) {
      queryParams['query'] = query.trim();
    }

    final url = Uri.parse('$baseUrl$_communityPath/feed/room').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('ROOM FEED STATUS: ${response.statusCode}');
    debugPrint('ROOM FEED BODY: ${response.body}');

    if (response.statusCode == 200) {
      return _extractList(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal mengambil room feed'),
    );
  }

  Future<Map<String, dynamic>> createRoom({
    required String title,
    required String description,
    required int maxParticipants,
  }) async {
    final url = Uri.parse('$baseUrl$_communityPath/room');

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
      return _extractMap(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal membuat ruang belajar'),
    );
  }

  Future<StudyRoomJoinResult> joinStudyRoom(int roomId) async {
    final url = Uri.parse('$baseUrl$_communityPath/rooms/$roomId/join');

    final response = await http.post(
      url,
      headers: await _headers(),
    );

    debugPrint('JOIN ROOM STATUS: ${response.statusCode}');
    debugPrint('JOIN ROOM BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return StudyRoomJoinResult.fromJson(_extractMap(_decodeBody(response)));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal join study room'),
    );
  }

  Future<void> leaveStudyRoom(int roomId) async {
    final url = Uri.parse('$baseUrl$_communityPath/rooms/$roomId/leave');

    final response = await http.delete(
      url,
      headers: await _headers(),
    );

    debugPrint('LEAVE ROOM STATUS: ${response.statusCode}');
    debugPrint('LEAVE ROOM BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal keluar dari ruang belajar'),
    );
  }

  Future<Map<String, dynamic>> toggleRoomLike({
    required int roomId,
  }) async {
    final url = Uri.parse('$baseUrl$_communityPath/room/$roomId/like');

    final response = await http.post(
      url,
      headers: await _headers(),
    );

    debugPrint('TOGGLE ROOM LIKE STATUS: ${response.statusCode}');
    debugPrint('TOGGLE ROOM LIKE BODY: ${response.body}');

    if (response.statusCode == 200) {
      return _extractMap(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal like ruang belajar'),
    );
  }

  Future<List<dynamic>> getChatHistory({
    required int roomId,
    int limit = 50,
  }) async {
    final url =
        Uri.parse('$baseUrl$_communityPath/rooms/$roomId/messages').replace(
      queryParameters: {
        'limit': limit.toString(),
      },
    );

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('CHAT HISTORY STATUS: ${response.statusCode}');
    debugPrint('CHAT HISTORY BODY: ${response.body}');

    if (response.statusCode == 200) {
      return _extractList(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal mengambil chat history'),
    );
  }

  Future<Map<String, dynamic>> sendChatMessage({
    required int roomId,
    required String content,
    int? replyingTo,
  }) async {
    final body = <String, dynamic>{
      'content': content,
      if (replyingTo != null) 'replying_to': replyingTo,
    };

    final url = Uri.parse('$baseUrl$_communityPath/rooms/$roomId/messages');

    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode(body),
    );

    debugPrint('SEND CHAT STATUS: ${response.statusCode}');
    debugPrint('SEND CHAT BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return _extractMap(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal mengirim pesan'),
    );
  }

  Future<Map<String, dynamic>> toggleRoomChatLike({
    required int roomMessageId,
  }) async {
    final url = Uri.parse(
      '$baseUrl$_communityPath/room/message/$roomMessageId/like',
    );

    final response = await http.post(
      url,
      headers: await _headers(),
    );

    debugPrint('TOGGLE ROOM CHAT LIKE STATUS: ${response.statusCode}');
    debugPrint('TOGGLE ROOM CHAT LIKE BODY: ${response.body}');

    if (response.statusCode == 200) {
      return _extractMap(_decodeBody(response));
    }

    throw Exception(
      _readErrorMessage(response, 'Gagal like pesan chat'),
    );
  }
}
