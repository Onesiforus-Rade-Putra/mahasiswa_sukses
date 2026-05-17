class AchievementSummaryModel {
  final int achieved;
  final int totalAchievement;
  final int currentPoint;
  final int targetPoint;
  final int currentLevelXp;
  final int nextLevelRequiredXpDiff;
  final double progressPercent;

  final int totalQuest;
  final int totalQuestCompleted;
  final int currentLevel;
  final int currentRanking;
  final int currentStreak;

  AchievementSummaryModel({
    required this.achieved,
    required this.totalAchievement,
    required this.currentPoint,
    required this.targetPoint,
    required this.currentLevelXp,
    required this.nextLevelRequiredXpDiff,
    required this.progressPercent,
    required this.totalQuest,
    required this.totalQuestCompleted,
    required this.currentLevel,
    required this.currentRanking,
    required this.currentStreak,
  });

  factory AchievementSummaryModel.fromApi(
    Map<String, dynamic> json, {
    required int achieved,
    required int totalAchievement,
  }) {
    final safeTotalAchievement = totalAchievement <= 0 ? 5 : totalAchievement;
    final safeAchieved = achieved < 0
        ? 0
        : achieved > safeTotalAchievement
            ? safeTotalAchievement
            : achieved;

    final currentLevelXp = _intValue(json['current_level_xp']);
    final nextLevelRequiredXpDiff =
        _intValue(json['next_level_required_xp_diff']);

    final targetPoint = currentLevelXp + nextLevelRequiredXpDiff;

    return AchievementSummaryModel(
      achieved: safeAchieved,
      totalAchievement: safeTotalAchievement,
      currentPoint: _intValue(json['total_xp_earned']),
      targetPoint: targetPoint > 0 ? targetPoint : 1000,
      currentLevelXp: currentLevelXp,
      nextLevelRequiredXpDiff: nextLevelRequiredXpDiff,
      progressPercent:
          safeTotalAchievement == 0 ? 0 : safeAchieved / safeTotalAchievement,
      totalQuest: _intValue(json['total_quest']),
      totalQuestCompleted: _intValue(json['total_quest_completed']),
      currentLevel: _intValue(json['current_level']),
      currentRanking: _intValue(json['current_ranking']),
      currentStreak: _intValue(json['current_streak']),
    );
  }
}

class AchievementBadgeModel {
  final String title;
  final String description;
  final String achievedDate;
  final double progress;
  final String iconType;
  final bool isCompleted;

  AchievementBadgeModel({
    required this.title,
    required this.description,
    required this.achievedDate,
    required this.progress,
    required this.iconType,
    required this.isCompleted,
  });

  factory AchievementBadgeModel.fromJson(Map<String, dynamic> json) {
    final isCompleted = json['is_completed'] == true;
    final completionDate = _formatDate(json['completion_date']);

    return AchievementBadgeModel(
      title: _stringValue(json['title'], 'Achievement'),
      description: _stringValue(json['description'], '-'),
      achievedDate: isCompleted ? 'Diraih: $completionDate' : 'Belum diraih',
      progress: _progressValue(json['progress_percentage']),
      iconType: _mapIconType(json['type']),
      isCompleted: isCompleted,
    );
  }
}

class AchievementTrackModel {
  final String title;
  final String subtitle;
  final String iconType;

  AchievementTrackModel({
    required this.title,
    required this.subtitle,
    required this.iconType,
  });
}

class AchievementModel {
  final AchievementSummaryModel summary;
  final List<AchievementBadgeModel> badges;
  final List<AchievementTrackModel> tracks;

  AchievementModel({
    required this.summary,
    required this.badges,
    required this.tracks,
  });
}

String _stringValue(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final text = value.toString();
  return text.trim().isEmpty ? fallback : text;
}

int _intValue(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString()) ?? fallback;
}

double _doubleValue(dynamic value, [double fallback = 0]) {
  if (value == null) return fallback;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? fallback;
}

double _progressValue(dynamic value) {
  final number = _doubleValue(value);

  if (number > 1) {
    return (number / 100).clamp(0.0, 1.0).toDouble();
  }

  return number.clamp(0.0, 1.0).toDouble();
}

String _mapIconType(dynamic value) {
  final type = value?.toString().toLowerCase();

  switch (type) {
    case 'streak':
      return 'flash';
    case 'forum':
      return 'forum';
    case 'quest':
    default:
      return 'badge';
  }
}

String _formatDate(dynamic value) {
  if (value == null) return '-';

  final date = DateTime.tryParse(value.toString());
  if (date == null) return value.toString();

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
