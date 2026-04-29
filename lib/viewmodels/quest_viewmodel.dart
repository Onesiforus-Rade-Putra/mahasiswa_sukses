import 'package:flutter/material.dart';

import '../models/quest_model.dart';
import '../services/quest_service.dart';

class QuestViewModel extends ChangeNotifier {
  final QuestService _service = QuestService();

  bool isLoading = false;
  String? errorMessage;

  List<QuestModel> dailyQuests = [];
  List<QuestModel> weeklyQuests = [];

  Future<void> fetchQuests() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dailyQuests = await _service.getQuests(frequency: 'harian');
      weeklyQuests = await _service.getQuests(frequency: 'mingguan');
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
