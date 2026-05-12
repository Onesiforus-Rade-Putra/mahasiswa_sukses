import 'package:flutter/material.dart';

import '../models/leaderboard_model.dart';
import '../services/leaderboard_service.dart';

enum LeaderboardTab {
  top50,
  teman,
}

class LeaderboardViewModel extends ChangeNotifier {
  final LeaderboardService _leaderboardService = LeaderboardService();

  LeaderboardTab selectedTab = LeaderboardTab.top50;

  bool isLoading = false;
  String? errorMessage;

  int userRank = 0;
  int userTotalXp = 0;

  List<LeaderboardModel> topGlobal = [];
  List<LeaderboardModel> topFriends = [];

  Future<void> loadLeaderboard() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _leaderboardService.getLeaderboard();

      userRank = result.userRank;
      userTotalXp = result.userTotalXp;
      topGlobal = result.topGlobal;
      topFriends = result.topFriends;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void changeTab(LeaderboardTab tab) {
    selectedTab = tab;
    notifyListeners();
  }

  List<LeaderboardModel> get currentLeaderboardList {
    if (selectedTab == LeaderboardTab.teman) {
      return topFriends;
    }

    return topGlobal;
  }

  List<LeaderboardModel> get currentTopPerformers {
    final source = currentLeaderboardList;

    if (source.length >= 3) {
      return source.take(3).toList();
    }

    return _fallbackTopPerformers;
  }

  List<LeaderboardModel> get _fallbackTopPerformers {
    return [
      LeaderboardModel(
        rank: 2,
        name: 'Budi Santoso',
        initials: 'BS',
        point: 2450,
        level: 12,
      ),
      LeaderboardModel(
        rank: 1,
        name: 'Andi Pratama',
        initials: 'AP',
        point: 3000,
        level: 12,
      ),
      LeaderboardModel(
        rank: 3,
        name: 'Muhammad Arifin',
        initials: 'MA',
        point: 2300,
        level: 9,
      ),
    ];
  }

  List<LeaderboardModel> get fallbackLeaderboardList {
    return [
      LeaderboardModel(
        rank: 1,
        name: 'Budi Santoso',
        initials: 'BS',
        point: 2450,
        level: 12,
      ),
      LeaderboardModel(
        rank: 2,
        name: 'Zabrina Virgie',
        initials: 'AP',
        point: 3000,
        level: 12,
      ),
      LeaderboardModel(
        rank: 3,
        name: 'Muhammad Arifin Ilham',
        initials: 'MA',
        point: 2300,
        level: 9,
      ),
    ];
  }
}
