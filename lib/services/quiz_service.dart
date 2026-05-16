import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quiz_model.dart';
import '../models/quiz_attempt_model.dart';
import '../models/quiz_question_model.dart';
import '../models/quiz_result_model.dart';

class QuizService {
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

  Map<String, dynamic> _decodeMap(String body) {
    final decoded = jsonDecode(body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw Exception('Format response tidak valid');
  }

  Map<String, dynamic> _unwrapData(Map<String, dynamic> decoded) {
    if (decoded['data'] is Map<String, dynamic>) {
      return decoded['data'] as Map<String, dynamic>;
    }

    return decoded;
  }

  Future<List<QuizModel>> getAllQuizzes() async {
    final url = Uri.parse('$baseUrl/api/v1/quiz/');

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('GET QUIZZES URL: $url');
    debugPrint('GET QUIZZES STATUS: ${response.statusCode}');
    debugPrint('GET QUIZZES BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List data;

      if (decoded is List) {
        data = decoded;
      } else if (decoded is Map<String, dynamic>) {
        if (decoded['data'] is List) {
          data = decoded['data'];
        } else if (decoded['quizzes'] is List) {
          data = decoded['quizzes'];
        } else if (decoded['data'] is Map<String, dynamic> &&
            decoded['data']['quizzes'] is List) {
          data = decoded['data']['quizzes'];
        } else {
          throw Exception('Format data quiz tidak valid');
        }
      } else {
        throw Exception('Format response quiz tidak valid');
      }

      return data
          .map((item) => QuizModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 401) {
      throw Exception('Sesi login habis. Silakan login ulang.');
    }

    throw Exception(
        'Gagal mengambil daftar quiz. Status: ${response.statusCode}');
  }

  Future<QuizAttemptModel> startQuiz(int quizId) async {
    final url = Uri.parse('$baseUrl/api/v1/quiz/$quizId/start');

    final response = await http.post(
      url,
      headers: await _headers(),
    );

    debugPrint('START QUIZ URL: $url');
    debugPrint('START QUIZ STATUS: ${response.statusCode}');
    debugPrint('START QUIZ BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = _decodeMap(response.body);
      final data = _unwrapData(decoded);

      return QuizAttemptModel.fromJson(data);
    }

    if (response.statusCode == 401) {
      throw Exception('Sesi login habis. Silakan login ulang.');
    }

    throw Exception('Gagal memulai quiz. Status: ${response.statusCode}');
  }

  Future<QuizQuestionModel> getQuizQuestion({
    required int quizId,
    required int questionNumber,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/v1/quiz/$quizId/questions/$questionNumber',
    );

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('GET QUESTION URL: $url');
    debugPrint('GET QUESTION STATUS: ${response.statusCode}');
    debugPrint('GET QUESTION BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = _decodeMap(response.body);
      final data = _unwrapData(decoded);

      return QuizQuestionModel.fromJson(data);
    }

    if (response.statusCode == 401) {
      throw Exception('Sesi login habis. Silakan login ulang.');
    }

    throw Exception(
        'Gagal mengambil soal quiz. Status: ${response.statusCode}');
  }

  Future<QuizResultModel> submitQuiz({
    required int quizId,
    required Map<String, String> answers,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/quiz/$quizId/submit');

    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({
        'answers': answers,
      }),
    );

    debugPrint('SUBMIT QUIZ URL: $url');
    debugPrint('SUBMIT QUIZ ANSWERS: $answers');
    debugPrint('SUBMIT QUIZ STATUS: ${response.statusCode}');
    debugPrint('SUBMIT QUIZ BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = _decodeMap(response.body);
      final data = _unwrapData(decoded);

      return QuizResultModel.fromJson(data);
    }

    if (response.statusCode == 401) {
      throw Exception('Sesi login habis. Silakan login ulang.');
    }

    throw Exception('Gagal submit quiz. Status: ${response.statusCode}');
  }

  Future<void> exitQuizEarly(int quizId) async {
    final url = Uri.parse('$baseUrl/api/v1/quiz/$quizId/exit');

    final response = await http.post(
      url,
      headers: await _headers(),
    );

    debugPrint('EXIT QUIZ STATUS: ${response.statusCode}');
    debugPrint('EXIT QUIZ BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    throw Exception('Gagal keluar dari quiz');
  }

  Future<String?> generateCertificate(int quizId) async {
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

      return data['certificate_id']?.toString() ??
          data['certificateId']?.toString();
    }

    if (response.statusCode == 401) {
      throw Exception('Sesi login habis. Silakan login ulang.');
    }

    throw Exception(
        'Gagal generate sertifikat. Status: ${response.statusCode}');
  }
}
