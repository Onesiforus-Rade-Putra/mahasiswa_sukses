import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/certificate_model.dart';

class CertificateService {
  static const String baseUrl = 'https://mahasiswa-sukses-backend.vercel.app';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token') ??
        prefs.getString('accessToken') ??
        prefs.getString('access_token');
  }

  Future<Map<String, String>> _headers({bool isJson = true}) async {
    final token = await _getToken();

    return {
      if (isJson) 'Content-Type': 'application/json',
      'Accept': isJson ? 'application/json' : 'application/pdf',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _decodeMap(String body) {
    final decoded = jsonDecode(body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw Exception('Format response sertifikat tidak valid');
  }

  Map<String, dynamic> _unwrapData(Map<String, dynamic> decoded) {
    if (decoded['data'] is Map<String, dynamic>) {
      return decoded['data'] as Map<String, dynamic>;
    }

    return decoded;
  }

  Future<String> generateCertificate(String quizId) async {
    final url = Uri.parse('$baseUrl/api/v1/quiz/$quizId/certificate');

    final response = await http.post(
      url,
      headers: await _headers(),
    );

    debugPrint('GENERATE CERTIFICATE URL: $url');
    debugPrint('GENERATE CERTIFICATE STATUS: ${response.statusCode}');
    debugPrint('GENERATE CERTIFICATE BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = _decodeMap(response.body);
      final data = _unwrapData(decoded);

      final certificateId = data['certificate_id']?.toString() ??
          data['certificateId']?.toString();

      if (certificateId == null || certificateId.isEmpty) {
        throw Exception('Certificate ID tidak ditemukan');
      }

      return certificateId;
    }

    if (response.statusCode == 401) {
      throw Exception('Sesi login habis. Silakan login ulang.');
    }

    throw Exception(
        'Gagal generate sertifikat. Status: ${response.statusCode}');
  }

  Future<List<CertificateModel>> getCertificates() async {
    final url = Uri.parse('$baseUrl/api/v1/certificate/list');

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('GET CERTIFICATE LIST URL: $url');
    debugPrint('GET CERTIFICATE LIST STATUS: ${response.statusCode}');
    debugPrint('GET CERTIFICATE LIST BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List data;

      if (decoded is List) {
        data = decoded;
      } else if (decoded is Map<String, dynamic>) {
        if (decoded['data'] is List) {
          data = decoded['data'];
        } else if (decoded['certificates'] is List) {
          data = decoded['certificates'];
        } else if (decoded['data'] is Map<String, dynamic> &&
            decoded['data']['certificates'] is List) {
          data = decoded['data']['certificates'];
        } else {
          throw Exception('Format data sertifikat tidak valid');
        }
      } else {
        throw Exception('Format response sertifikat tidak valid');
      }

      return data
          .map(
              (item) => CertificateModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 401) {
      throw Exception('Sesi login habis. Silakan login ulang.');
    }

    throw Exception(
        'Gagal mengambil daftar sertifikat. Status: ${response.statusCode}');
  }

  Future<File> downloadCertificate(
    String certificateId,
    String fileName,
  ) async {
    final url = Uri.parse('$baseUrl/api/v1/certificate/$certificateId');

    final response = await http.get(
      url,
      headers: await _headers(isJson: false),
    );

    debugPrint('DOWNLOAD CERTIFICATE URL: $url');
    debugPrint('DOWNLOAD CERTIFICATE STATUS: ${response.statusCode}');
    debugPrint(
        'DOWNLOAD CERTIFICATE CONTENT TYPE: ${response.headers['content-type']}');

    if (response.statusCode == 200) {
      final dir = await getApplicationDocumentsDirectory();
      final safeFileName = fileName.replaceAll(' ', '_');
      final file = File('${dir.path}/$safeFileName.pdf');

      await file.writeAsBytes(response.bodyBytes);
      return file;
    }

    if (response.statusCode == 401) {
      throw Exception('Sesi login habis. Silakan login ulang.');
    }

    throw Exception(
        'Gagal download sertifikat. Status: ${response.statusCode}');
  }
}
