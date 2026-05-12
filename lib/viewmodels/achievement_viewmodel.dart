import 'package:flutter/material.dart';

import '../models/achievement_model.dart';
import '../services/achievement_service.dart';

class AchievementViewModel extends ChangeNotifier {
  final AchievementService _achievementService = AchievementService();

  bool isLoading = false;
  String? errorMessage;

  int selectedTab = 0;

  AchievementModel? achievementData;

  Future<void> loadAchievementData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      achievementData = await _achievementService.getAchievementData();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void changeTab(int index) {
    selectedTab = index;
    notifyListeners();
  }
}
