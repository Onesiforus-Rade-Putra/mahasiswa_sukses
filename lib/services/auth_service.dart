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

    try {
      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        final detail = data['detail']?.toString().toLowerCase() ?? '';
        final error = data['error']?.toString() ?? '';
        final message = data['message']?.toString() ?? '';
        if (detail.contains('invalid login credentials') ||
            detail.contains('invalid credentials')) {
          throw Exception('Email atau password salah');
        }
        if (detail.contains('user not found') || detail.contains('not found')) {
          throw Exception('Akun tidak ditemukan');
        }
        if (detail.contains('email not confirmed')) {
          throw Exception('Email belum dikonfirmasi');
        }
        if (message.isNotEmpty) {
          throw Exception(message);
        }
        if (detail.isNotEmpty) {
          throw Exception(detail);
        }
        if (error.isNotEmpty) {
          throw Exception(error);
        }
      }
    } catch (_) {}
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

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
        "phone_number": phoneNumber,
        "nim": nim,
        "full_name": fullName,
        "birth_date": birthDate,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isEmpty || response.body == 'null') {
        return {"message": "Register berhasil"};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    try {
      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        final detail = data['detail']?.toString() ?? '';
        final error = data['error']?.toString() ?? '';

        if (detail.contains('User already registered')) {
          throw Exception('Email sudah terdaftar');
        }

        if (detail.contains('at least 8 characters')) {
          throw Exception('Password minimal 8 karakter');
        }

        if (error.isNotEmpty) {
          throw Exception(error);
        }

        if (detail.isNotEmpty) {
          throw Exception(detail);
        }
      }
    } catch (_) {}

    throw Exception('Register gagal');
  }
}
