class QuizResultModel {
  final int correctAnswers;
  final int totalQuestions;
  final int minimumScore;
  final bool passed;
  final int pointsGained;
  final int streakBonus;
  final int streakCount;
  final String? certificateId;

  QuizResultModel({
    required this.correctAnswers,
    required this.totalQuestions,
    required this.minimumScore,
    required this.passed,
    required this.pointsGained,
    required this.streakBonus,
    required this.streakCount,
    this.certificateId,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return QuizResultModel(
      correctAnswers: _toInt(
        data['correct_answers'] ??
            data['correctAnswers'] ??
            data['correct'] ??
            0,
      ),
      totalQuestions: _toInt(
        data['total_questions'] ?? data['totalQuestions'] ?? data['total'] ?? 0,
      ),
      minimumScore: _toInt(
        data['minimum_score'] ??
            data['minimumScore'] ??
            data['passing_score'] ??
            0,
      ),
      passed: _toBool(
        data['passed'] ?? data['is_passed'] ?? data['isPassed'] ?? false,
      ),
      pointsGained: _toInt(
        data['points_gained'] ??
            data['pointsGained'] ??
            data['xp_gained'] ??
            data['xpGained'] ??
            data['points'] ??
            0,
      ),
      streakBonus: _toInt(
        data['streak_bonus'] ??
            data['streakBonus'] ??
            data['bonus_streak'] ??
            0,
      ),
      streakCount: _toInt(
        data['streak_count'] ??
            data['streakCount'] ??
            data['current_streak'] ??
            0,
      ),
      certificateId: data['certificate_id']?.toString() ??
          data['certificateId']?.toString(),
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
