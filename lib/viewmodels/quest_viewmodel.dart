import 'package:flutter/material.dart';
import '../models/gamification_summary_model.dart';
import '../services/home_service.dart';
import '../models/quest_model.dart';
import '../services/quest_service.dart';

class QuestViewModel extends ChangeNotifier {
  final QuestService _service = QuestService();

  bool isLoading = false;
  String? errorMessage;

  List<QuestModel> dailyQuests = [];
  List<QuestModel> weeklyQuests = [];

  final HomeService _homeService = HomeService();

  bool isSummaryLoading = false;

  GamificationSummaryModel summary = const GamificationSummaryModel.empty();

  int get currentStreak {
    return summary.currentStreak == 0 ? 7 : summary.currentStreak;
  }

  Future<void> fetchQuests() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final quests = await _service.getQuests().timeout(
            const Duration(seconds: 10),
          );

      dailyQuests = quests.where((quest) {
        final frequency = quest.frequency.toLowerCase();
        return frequency == 'harian' || frequency == 'daily';
      }).toList();

      weeklyQuests = quests.where((quest) {
        final frequency = quest.frequency.toLowerCase();
        return frequency == 'mingguan' || frequency == 'weekly';
      }).toList();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');

      dailyQuests = [];
      weeklyQuests = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }

    await fetchGamificationSummary();
  }

  Future<void> fetchGamificationSummary() async {
    isSummaryLoading = true;
    notifyListeners();

    try {
      final token = await _homeService.getSavedToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      summary = await _homeService.getGamificationSummary(token).timeout(
            const Duration(seconds: 8),
          );
    } catch (e) {
      debugPrint('QUEST SUMMARY ERROR: $e');

      summary = const GamificationSummaryModel.empty();
    } finally {
      isSummaryLoading = false;
      notifyListeners();
    }
  }
}
