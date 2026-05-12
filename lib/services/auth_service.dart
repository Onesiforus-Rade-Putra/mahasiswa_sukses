import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://mahasiswa-sukses-backend.vercel.app';

  Future<Map<String, dynamic>> login({
    required String emailOrUsername,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/login');

    final body = {
      "email_or_username": emailOrUsername,
      "password": password,
    };

    debugPrint('LOGIN URL: $url');
    debugPrint('LOGIN SEND BODY: $body');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    debugPrint('LOGIN STATUS: ${response.statusCode}');
    debugPrint('LOGIN BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isEmpty || response.body == 'null') {
        return {"message": "Login berhasil"};
      }

      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {"message": "Login berhasil"};
    }

    throw Exception(
        _extractErrorMessage(response.body, fallback: 'Login gagal'));
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String username,
    required String phoneNumber,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/register');

    final body = {
      "email": email,
      "username": username,
      "password": password,
      "phone_number": phoneNumber,
      "full_name": fullName,
    };

    debugPrint('REGISTER URL: $url');
    debugPrint('REGISTER SEND BODY: $body');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    debugPrint('REGISTER STATUS: ${response.statusCode}');
    debugPrint('REGISTER BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isEmpty || response.body == 'null') {
        return {"message": "Register berhasil"};
      }

      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {"message": "Register berhasil"};
    }

    throw Exception(
      _extractErrorMessage(response.body, fallback: 'Register gagal'),
    );
  }

  String _extractErrorMessage(String body, {required String fallback}) {
    try {
      if (body.isEmpty || body == 'null') return fallback;

      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        final message = decoded['message']?.toString();
        final error = decoded['error']?.toString();
        final detail = decoded['detail'];

        if (message != null && message.isNotEmpty) {
          return _translateError(message);
        }

        if (error != null && error.isNotEmpty) {
          return _translateError(error);
        }

        if (detail is String && detail.isNotEmpty) {
          return _translateError(detail);
        }

        if (detail is List && detail.isNotEmpty) {
          final first = detail.first;

          if (first is Map<String, dynamic>) {
            final msg = first['msg']?.toString();
            final loc = first['loc']?.toString();

            if (msg != null && msg.isNotEmpty) {
              if (loc != null && loc.isNotEmpty) {
                return '$msg pada $loc';
              }

              return msg;
            }
          }

          return detail.toString();
        }

        return decoded.toString();
      }

      return decoded.toString();
    } catch (e) {
      debugPrint('ERROR PARSE BODY: $e');
      return fallback;
    }
  }

  String _translateError(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('invalid login credentials') ||
        lower.contains('invalid credentials') ||
        lower.contains('incorrect password')) {
      return 'Email/username atau password salah';
    }

    if (lower.contains('user not found') || lower.contains('not found')) {
      return 'Akun tidak ditemukan';
    }

    if (lower.contains('email already') ||
        lower.contains('already registered') ||
        lower.contains('already exists')) {
      return 'Email sudah terdaftar';
    }

    if (lower.contains('username already') ||
        lower.contains('username exists') ||
        lower.contains('username is already')) {
      return 'Username sudah digunakan';
    }

    if (lower.contains('at least 8') ||
        lower.contains('minimal 8') ||
        lower.contains('8 characters')) {
      return 'Password minimal 8 karakter';
    }

    return message;
  }
}
