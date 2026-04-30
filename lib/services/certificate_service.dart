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
    return prefs.getString('token');
  }

  Future<Map<String, String>> _headers({bool isJson = true}) async {
    final token = await _getToken();

    return {
      if (isJson) 'Content-Type': 'application/json',
      'Accept': isJson ? 'application/json' : 'application/pdf',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// 1. Generate certificate dari quiz yang lulus
  Future<String> generateCertificate(String quizId) async {
    final url = Uri.parse('$baseUrl/api/v1/quiz/$quizId/certificate');

    final response = await http.post(
      url,
      headers: await _headers(),
    );

    debugPrint('GENERATE CERTIFICATE STATUS: ${response.statusCode}');
    debugPrint('GENERATE CERTIFICATE BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['certificate_id'] ?? '';
    }

    throw Exception('Gagal generate sertifikat');
  }

  /// 2. Ambil list sertifikat user
  Future<List<CertificateModel>> getCertificates() async {
    final url = Uri.parse('$baseUrl/api/v1/certificate/list');

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('GET CERTIFICATE LIST STATUS: ${response.statusCode}');
    debugPrint('GET CERTIFICATE LIST BODY: ${response.body}');

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CertificateModel.fromJson(e)).toList();
    }

    throw Exception('Gagal mengambil daftar sertifikat');
  }

  /// 3. Download PDF sertifikat
  Future<File> downloadCertificate(
      String certificateId, String fileName) async {
    final url = Uri.parse('$baseUrl/api/v1/certificate/$certificateId');

    final response = await http.get(
      url,
      headers: await _headers(isJson: false),
    );

    debugPrint('DOWNLOAD CERTIFICATE STATUS: ${response.statusCode}');

    if (response.statusCode == 200) {
      final dir = await getApplicationDocumentsDirectory();
      final safeFileName = fileName.replaceAll(' ', '_');
      final file = File('${dir.path}/$safeFileName.pdf');

      await file.writeAsBytes(response.bodyBytes);
      return file;
    }

    throw Exception('Gagal download sertifikat');
  }
}
