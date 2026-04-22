import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mahasiswa_sukses/models/profile_model.dart';
import 'package:mahasiswa_sukses/models/gamification_summary_model.dart';
import 'package:mahasiswa_sukses/models/quest_model.dart';
import 'package:mahasiswa_sukses/models/task_model.dart';
import 'package:mahasiswa_sukses/models/history_model.dart';

class HomeService {
  static const String baseUrl = 'https://mahasiswa-sukses-backend.vercel.app';

  static const String profilePath = '/api/v1/user/profile';
  static const String gamificationSummaryPath = '/api/v1/gamification/summary';
  static const String questsPath = '/api/v1/gamification/quests';
  static const String historyPath = '/api/v1/gamification/history';
  static const String tasksPath = '/api/v1/progress-tracking/tasks';
  static const String avatarPath = '/api/v1/user/avatar';

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, String> _headers(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<ProfileModel> getMyProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl$profilePath'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Gagal mengambil profile: ${response.statusCode}');
  }

  String buildAvatarUrl(String userId) {
    return '$baseUrl$avatarPath/$userId';
  }

  Future<GamificationSummaryModel> getGamificationSummary(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl$gamificationSummaryPath'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return GamificationSummaryModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(
        'Gagal mengambil gamification summary: ${response.statusCode}');
  }

  Future<List<QuestModel>> getQuests(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl$questsPath'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => QuestModel.fromJson(e)).toList();
    }

    throw Exception('Gagal mengambil quests: ${response.statusCode}');
  }

  Future<List<TaskModel>> getTasks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl$tasksPath'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => TaskModel.fromJson(e)).toList();
    }

    throw Exception('Gagal mengambil tasks: ${response.statusCode}');
  }

  Future<List<HistoryModel>> getHistory(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl$historyPath'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => HistoryModel.fromJson(e)).toList();
    }

    throw Exception('Gagal mengambil history: ${response.statusCode}');
  }

  Future<TaskModel> createTask({
    required String token,
    required TaskModel task,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$tasksPath'),
      headers: _headers(token),
      body: jsonEncode({
        'title': task.title,
        'category': task.category.toLowerCase(),
        'priority': task.priority.toLowerCase(),
        'deadline': task.deadline,
        'description': task.description,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return TaskModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Gagal menambah task: ${response.statusCode}');
  }

  Future<void> updateTaskProgress({
    required String token,
    required int taskId,
    required bool isCompleted,
  }) async {
    final progress = isCompleted ? 'selesai' : 'todo';

    final url = '$baseUrl$tasksPath/$taskId/update_progress/$progress';

    print('UPDATE TASK URL: $url');

    final response = await http.post(
      Uri.parse(url),
      headers: _headers(token),
    );

    print('UPDATE TASK STATUS: ${response.statusCode}');
    print('UPDATE TASK BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal update task progress: ${response.statusCode}');
    }
  }

  Future<void> deleteTask({
    required String token,
    required int taskId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$tasksPath/$taskId'),
      headers: _headers(token),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal hapus task: ${response.statusCode}');
    }
  }
}
