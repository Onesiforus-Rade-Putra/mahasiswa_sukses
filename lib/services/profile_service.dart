import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:mahasiswa_sukses/models/friend_model.dart';
import 'package:mahasiswa_sukses/models/user_profile_model.dart';

class ProfileService {
  static const String baseUrl = 'https://mahasiswa-sukses-backend.vercel.app';

  // Kalau path Get My Profile di Apidog kamu beda, ubah bagian ini saja.
  static const String profilePath = '/api/v1/user/profile';
  static const String avatarPath = '/api/v1/user/avatar';

  static const String friendListPath = '/api/v1/friends/';
  static const String friendSummaryPath = '/api/v1/friends/summary';
  static const String friendRequestPath = '/api/v1/friends/request';
  static const String friendRequestListPath = '/api/v1/friends/request_list';

  static const String acceptFriendPath = '/api/v1/friends/accept';
  static const String denyFriendPath = '/api/v1/friends/deny';
  static const String removeFriendPath = '/api/v1/friends';
  static const String updateProfilePath = '/api/v1/user/profile';
  static const String updatePasswordPath = '/api/v1/auth/update-password';

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
    final authValue =
        token.toLowerCase().startsWith('bearer ') ? token : 'Bearer $token';

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authValue,
    };
  }

  Map<String, dynamic> _extractMap(String body) {
    if (body.trim().isEmpty || body == 'null') return {};

    final decoded = jsonDecode(body);

    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'] ?? decoded['result'] ?? decoded['user'];

      if (data is Map<String, dynamic>) {
        return data;
      }

      return decoded;
    }

    return {};
  }

  List<dynamic> _extractList(String body) {
    if (body.trim().isEmpty || body == 'null') return [];

    final decoded = jsonDecode(body);

    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'] ??
          decoded['result'] ??
          decoded['friends'] ??
          decoded['items'];

      if (data is List) {
        return data;
      }
    }

    return [];
  }

  String _errorMessage(http.Response response, String fallback) {
    try {
      if (response.body.trim().isEmpty || response.body == 'null') {
        if (response.statusCode == 404) {
          return 'User tidak ditemukan';
        }

        if (response.statusCode == 422) {
          return 'Username tidak valid atau tidak ditemukan';
        }

        return '$fallback. Status: ${response.statusCode}';
      }

      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        final message =
            decoded['message'] ?? decoded['error'] ?? decoded['detail'];

        if (message is String && message.isNotEmpty) {
          return message;
        }

        if (message is List && message.isNotEmpty) {
          final first = message.first;

          if (first is Map<String, dynamic>) {
            return first['msg']?.toString() ?? first.toString();
          }

          return first.toString();
        }

        if (message != null) {
          return message.toString();
        }
      }
    } catch (_) {}

    if (response.statusCode == 401) {
      return 'Sesi login habis. Silakan login ulang.';
    }

    if (response.statusCode == 404) {
      return 'User tidak ditemukan';
    }

    if (response.statusCode == 422) {
      return 'Username tidak valid atau tidak ditemukan';
    }

    return '$fallback. Status: ${response.statusCode}';
  }

  Future<UserProfileModel> getMyProfile() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl$profilePath'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return UserProfileModel.fromJson(_extractMap(response.body));
    }

    throw Exception(_errorMessage(response, 'Gagal mengambil profile'));
  }

  String buildAvatarUrl(String userId, {Object? cacheKey}) {
    final url = '$baseUrl$avatarPath/$userId';

    if (cacheKey == null) {
      return url;
    }

    return '$url?v=$cacheKey';
  }

  MediaType? _getImageMediaType(String path) {
    final lowerPath = path.toLowerCase();

    if (lowerPath.endsWith('.jpg') || lowerPath.endsWith('.jpeg')) {
      return MediaType('image', 'jpeg');
    }

    if (lowerPath.endsWith('.png')) {
      return MediaType('image', 'png');
    }

    return null;
  }

  Future<void> uploadAvatar(File file) async {
    final token = await _getToken();

    final mediaType = _getImageMediaType(file.path);

    if (mediaType == null) {
      throw Exception('Format foto harus JPG, JPEG, atau PNG');
    }

    final authValue =
        token.toLowerCase().startsWith('bearer ') ? token : 'Bearer $token';

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/v1/user/profile/avatar'),
    );

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': authValue,
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: mediaType,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint('UPLOAD AVATAR STATUS: ${response.statusCode}');
    debugPrint('UPLOAD AVATAR BODY: ${response.body}');
    debugPrint('UPLOAD AVATAR CONTENT TYPE: $mediaType');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    throw Exception(
      _errorMessage(response, 'Gagal upload foto profile'),
    );
  }

  Future<FriendSummaryModel> getFriendSummary() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl$friendSummaryPath'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return FriendSummaryModel.fromJson(_extractMap(response.body));
    }

    throw Exception(_errorMessage(response, 'Gagal mengambil summary teman'));
  }

  Future<List<FriendModel>> getFriends() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl$friendListPath'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final list = _extractList(response.body);

      return list
          .whereType<Map>()
          .map((item) => FriendModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    throw Exception(_errorMessage(response, 'Gagal mengambil list teman'));
  }

  Future<List<FriendModel>> getFriendRequests() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl$friendRequestListPath'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final list = _extractList(response.body);

      return list
          .whereType<Map>()
          .map((item) => FriendModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    throw Exception(
      _errorMessage(response, 'Gagal mengambil friend request'),
    );
  }

  Future<void> sendFriendRequest(String emailOrUsername) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl$friendRequestPath'),
      headers: _headers(token),
      body: jsonEncode({
        'email_or_username': emailOrUsername,
      }),
    );

    debugPrint('ADD FRIEND STATUS: ${response.statusCode}');
    debugPrint('ADD FRIEND BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    throw Exception(
      _errorMessage(response, 'Gagal mengirim request teman'),
    );
  }

  Future<void> acceptFriend(String requesterId) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl$acceptFriendPath/$requesterId'),
      headers: _headers(token),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    throw Exception(_errorMessage(response, 'Gagal menerima teman'));
  }

  Future<void> denyFriend(String requesterId) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl$denyFriendPath/$requesterId'),
      headers: _headers(token),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    throw Exception(_errorMessage(response, 'Gagal menolak teman'));
  }

  Future<void> removeFriend(String friendId) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl$removeFriendPath/$friendId'),
      headers: _headers(token),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return;
    }

    throw Exception(_errorMessage(response, 'Gagal menghapus teman'));
  }

  Future<void> updateProfile({
    required String username,
    required String email,
    required String description,
  }) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl$updateProfilePath'),
      headers: _headers(token),
      body: jsonEncode({
        'username': username,
        'email': email,
        'description': description,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    throw Exception(
      _errorMessage(response, 'Gagal memperbarui profile'),
    );
  }

  Future<void> updatePassword({
    required String password,
  }) async {
    final token = await _getToken();

    final cleanToken = token.replaceFirst(
      RegExp(r'^Bearer\s+', caseSensitive: false),
      '',
    );

    final response = await http.post(
      Uri.parse('$baseUrl$updatePasswordPath'),
      headers: _headers(token),
      body: jsonEncode({
        'access_token': cleanToken,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    throw Exception(
      _errorMessage(response, 'Gagal memperbarui password'),
    );
  }
}
