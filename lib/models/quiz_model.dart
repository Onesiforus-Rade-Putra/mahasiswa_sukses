class QuizModel {
  final int id;
  final String title;
  final String category;
  final int durationMinutes;
  final int minimumScore;
  final int xpReward;
  final String difficulty;
  final bool lastAttemptSuccessful;
  final String? certificateId;
  final int completionCount;

  QuizModel({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.minimumScore,
    required this.xpReward,
    required this.difficulty,
    required this.lastAttemptSuccessful,
    required this.certificateId,
    required this.completionCount,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      minimumScore: json['minimum_score'] ?? 0,
      xpReward: json['xp_reward'] ?? 0,
      difficulty: json['difficulty'] ?? 'easy',
      lastAttemptSuccessful: json['last_attempt_successful'] ?? false,
      certificateId: json['certificate_id'],
      completionCount: json['completion_count'] ?? 0,
    );
  }
}
