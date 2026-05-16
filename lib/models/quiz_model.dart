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
      id: _toInt(json['id'] ?? json['quiz_id']),
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      category: json['category']?.toString() ??
          json['subject']?.toString() ??
          json['type']?.toString() ??
          '',
      durationMinutes: _toInt(
        json['duration_minutes'] ??
            json['durationMinutes'] ??
            json['duration'] ??
            0,
      ),
      minimumScore: _toInt(
        json['minimum_score'] ??
            json['minimumScore'] ??
            json['passing_score'] ??
            0,
      ),
      xpReward: _toInt(
        json['xp_reward'] ?? json['xpReward'] ?? json['xp'] ?? 0,
      ),
      difficulty: json['difficulty']?.toString() ?? 'easy',
      lastAttemptSuccessful: _toBool(
        json['last_attempt_successful'] ??
            json['lastAttemptSuccessful'] ??
            json['is_completed'] ??
            json['isCompleted'] ??
            false,
      ),
      certificateId: json['certificate_id']?.toString() ??
          json['certificateId']?.toString(),
      completionCount: _toInt(
        json['completion_count'] ?? json['completionCount'] ?? 0,
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'true' || lower == '1' || lower == 'yes';
    }
    return false;
  }
}
