import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://mahasiswa-sukses-backend.vercel.app';

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    debugPrint('LOGIN STATUS: ${response.statusCode}');
    debugPrint('LOGIN BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isEmpty || response.body == 'null') {
        return {"message": "Login berhasil"};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    final data = _safeDecode(response.body);

    if (data is Map<String, dynamic>) {
      final detail = data['detail']?.toString() ?? '';
      final error = data['error']?.toString() ?? '';
      final message = data['message']?.toString() ?? '';

      final allMessage = '$detail $error $message'.toLowerCase();

      if (allMessage.contains('invalid login credentials') ||
          allMessage.contains('invalid credentials')) {
        throw Exception('Email atau password salah');
      }

      if (allMessage.contains('user not found') ||
          allMessage.contains('not found')) {
        throw Exception('Akun tidak ditemukan');
      }

      if (allMessage.contains('email not confirmed')) {
        throw Exception('Email belum dikonfirmasi');
      }

      if (message.isNotEmpty) throw Exception(message);
      if (detail.isNotEmpty) throw Exception(detail);
      if (error.isNotEmpty) throw Exception(error);
    }

    throw Exception('Login gagal');
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String birthDate,
    required String phoneNumber,
    required String nim,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/register');

    final body = {
      "email": email,
      "password": password,
      "phone_number": phoneNumber,
      "nim": nim,
      "full_name": fullName,
      "birth_date": birthDate,
    };

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
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    final data = _safeDecode(response.body);

    if (data is Map<String, dynamic>) {
      final detail = data['detail']?.toString() ?? '';
      final error = data['error']?.toString() ?? '';
      final message = data['message']?.toString() ?? '';

      final allMessage = '$detail $error $message'.toLowerCase();

      if (allMessage.contains('already registered') ||
          allMessage.contains('already exists') ||
          allMessage.contains('email already')) {
        throw Exception('Email sudah terdaftar');
      }

      if (allMessage.contains('at least 8 characters') ||
          allMessage.contains('minimal 8')) {
        throw Exception('Password minimal 8 karakter');
      }

      if (message.isNotEmpty) throw Exception(message);
      if (detail.isNotEmpty) throw Exception(detail);
      if (error.isNotEmpty) throw Exception(error);
    }

    throw Exception('Register gagal');
  }

  dynamic _safeDecode(String body) {
    try {
      if (body.isEmpty || body == 'null') return null;
      return jsonDecode(body);
    } catch (e) {
      debugPrint('JSON DECODE ERROR: $e');
      return null;
    }
  }
}
