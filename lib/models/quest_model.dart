class QuestModel {
  final String title;
  final String description;
  final String frequency;
  final int xpReward;
  final String difficulty;
  final int progressPercentage;
  final bool isCompleted;

  QuestModel({
    required this.title,
    required this.description,
    required this.frequency,
    required this.xpReward,
    required this.difficulty,
    required this.progressPercentage,
    required this.isCompleted,
  });

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      frequency: json['frequency']?.toString() ??
          json['type']?.toString() ??
          json['quest_type']?.toString() ??
          '',
      xpReward: _toInt(
        json['xp_reward'] ?? json['xpReward'] ?? json['xp'] ?? 0,
      ),
      difficulty: json['difficulty']?.toString() ?? 'easy',
      progressPercentage: _toInt(
        json['progress_percentage'] ??
            json['progressPercentage'] ??
            json['progress'] ??
            0,
      ),
      isCompleted: json['is_completed'] ??
          json['isCompleted'] ??
          json['completed'] ??
          false,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
