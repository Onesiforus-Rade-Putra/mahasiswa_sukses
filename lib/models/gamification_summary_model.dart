class GamificationSummaryModel {
  final int totalQuest;
  final int totalQuestCompleted;
  final int totalXpEarned;
  final int currentRanking;
  final int currentStreak;

  const GamificationSummaryModel({
    required this.totalQuest,
    required this.totalQuestCompleted,
    required this.totalXpEarned,
    required this.currentRanking,
    required this.currentStreak,
  });

  const GamificationSummaryModel.empty()
      : totalQuest = 0,
        totalQuestCompleted = 0,
        totalXpEarned = 0,
        currentRanking = 0,
        currentStreak = 0;

  double get progress {
    if (totalQuest == 0) return 0;
    return totalQuestCompleted / totalQuest;
  }

  factory GamificationSummaryModel.fromJson(Map<String, dynamic> json) {
    return GamificationSummaryModel(
      totalQuest: json['total_quest'] ?? 0,
      totalQuestCompleted: json['total_quest_completed'] ?? 0,
      totalXpEarned: json['total_xp_earned'] ?? 0,
      currentRanking: json['current_ranking'] ?? 0,
      currentStreak: json['current_streak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_quest': totalQuest,
      'total_quest_completed': totalQuestCompleted,
      'total_xp_earned': totalXpEarned,
      'current_ranking': currentRanking,
      'current_streak': currentStreak,
    };
  }
}
