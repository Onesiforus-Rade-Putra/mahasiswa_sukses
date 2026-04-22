import 'package:flutter/material.dart';
import 'package:mahasiswa_sukses/models/gamification_summary_model.dart';
import 'package:mahasiswa_sukses/models/history_model.dart';
import 'package:mahasiswa_sukses/models/profile_model.dart';
import 'package:mahasiswa_sukses/models/quest_model.dart';
import 'package:mahasiswa_sukses/models/task_model.dart';
import 'package:mahasiswa_sukses/services/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  bool isLoading = false;
  String? errorMessage;

  ProfileModel profile = const ProfileModel.empty();
  GamificationSummaryModel summary = const GamificationSummaryModel.empty();
  List<QuestModel> quests = [];
  List<TaskModel> tasks = [];
  List<HistoryModel> histories = [];

  String avatarUrl = '';
  String token = '';

  Future<void> loadHomeData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final savedToken = await _homeService.getSavedToken();

      if (savedToken == null || savedToken.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      token = savedToken;

      final loadedProfile = await _homeService.getMyProfile(token);
      final loadedSummary = await _homeService.getGamificationSummary(token);
      final loadedQuests = await _homeService.getQuests(token);
      final loadedTasks = await _homeService.getTasks(token);
      final loadedHistories = await _homeService.getHistory(token);

      profile = loadedProfile;
      summary = loadedSummary;
      quests = loadedQuests;
      tasks = loadedTasks;
      histories = loadedHistories;

      if (profile.id.isNotEmpty) {
        avatarUrl = _homeService.buildAvatarUrl(profile.id);
      }
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadHomeData();
  }

  String get greetingName => profile.displayName;

  int get totalPoints => summary.totalXpEarned;
  int get ranking => summary.currentRanking;
  int get streak => summary.currentStreak;

  int get totalQuest => summary.totalQuest;
  int get completedQuest => summary.totalQuestCompleted;
  double get progressValue => summary.progress;

  List<TaskModel> get activeTasks =>
      tasks.where((task) => !task.isCompleted).toList();

  List<HistoryModel> get latestHistories => histories.take(5).toList();

  List<QuestModel> get dailyQuests => quests
      .where((quest) => quest.frequency.toLowerCase() == 'harian')
      .toList();

  // alias untuk home_page.dart lama
  int get totalQuestCount => totalQuest;
  int get completedQuestCount => completedQuest;
  double get questProgress => progressValue;
}
