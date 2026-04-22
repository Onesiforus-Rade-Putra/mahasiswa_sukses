class QuestModel {
  final String title;
  final String description;
  final String frequency;
  final int xpReward;
  final String difficulty;
  final int progressPercentage;
  final bool isCompleted;

  const QuestModel({
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
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      frequency: json['frequency'] ?? '',
      xpReward: json['xp_reward'] ?? 0,
      difficulty: json['difficulty'] ?? '',
      progressPercentage: json['progress_percentage'] ?? 0,
      isCompleted: json['is_completed'] ?? false,
    );
  }
}
