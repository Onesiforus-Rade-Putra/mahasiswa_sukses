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

      topGlobal = _normalizeLeaderboard(result.topGlobal).take(50).toList();
      topFriends = _normalizeLeaderboard(result.topFriends);

      debugPrint('TOP GLOBAL COUNT: ${topGlobal.length}');
      debugPrint('TOP FRIENDS COUNT: ${topFriends.length}');
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    isLoading = false;
    notifyListeners();
  }

  void changeTab(LeaderboardTab tab) {
    selectedTab = tab;
    notifyListeners();
  }

  List<LeaderboardModel> get currentLeaderboardList {
    return selectedTab == LeaderboardTab.teman ? topFriends : topGlobal;
  }

  List<LeaderboardModel> get currentTopPerformers {
    return currentLeaderboardList.take(3).toList();
  }

  bool get hasLeaderboardData {
    return currentLeaderboardList.isNotEmpty;
  }

  bool get hasEnoughTopPerformers {
    return currentTopPerformers.length >= 3;
  }

  List<LeaderboardModel> _normalizeLeaderboard(
    List<LeaderboardModel> source,
  ) {
    final sorted = [...source];

    sorted.sort((a, b) {
      final pointCompare = b.point.compareTo(a.point);

      if (pointCompare != 0) {
        return pointCompare;
      }

      return a.name.compareTo(b.name);
    });

    return List.generate(sorted.length, (index) {
      final item = sorted[index];

      return LeaderboardModel(
        rank: index + 1,
        name: item.name,
        initials: item.initials,
        point: item.point,
        level: item.level,
      );
    });
  }
}
