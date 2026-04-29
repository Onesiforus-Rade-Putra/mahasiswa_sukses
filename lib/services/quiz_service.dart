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

  Future<List<QuizModel>> getAllQuizzes() async {
    final url = Uri.parse('$baseUrl/api/v1/quiz/');

    final response = await http.get(
      url,
      headers: await _headers(),
    );

    debugPrint('GET QUIZZES STATUS: ${response.statusCode}');
    debugPrint('GET QUIZZES BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data
            .map((item) => QuizModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Format data quiz tidak valid');
    }

    throw Exception('Gagal mengambil daftar quiz');
  }

  Future<QuizAttemptModel> startQuiz(int quizId) async {
    final url = Uri.parse('$baseUrl/api/v1/quiz/$quizId/start');

    final response = await http.post(
      url,
      headers: await _headers(),
    );

    debugPrint('START QUIZ STATUS: ${response.statusCode}');
    debugPrint('START QUIZ BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return QuizAttemptModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception('Gagal memulai quiz');
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

    debugPrint('GET QUESTION STATUS: ${response.statusCode}');
    debugPrint('GET QUESTION BODY: ${response.body}');

    if (response.statusCode == 200) {
      return QuizQuestionModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception('Gagal mengambil soal quiz');
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

    debugPrint('SUBMIT QUIZ STATUS: ${response.statusCode}');
    debugPrint('SUBMIT QUIZ BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return QuizResultModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception('Gagal submit quiz');
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

    debugPrint('GENERATE CERTIFICATE STATUS: ${response.statusCode}');
    debugPrint('GENERATE CERTIFICATE BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['certificate_id'];
    }

    throw Exception('Gagal generate sertifikat');
  }
}
