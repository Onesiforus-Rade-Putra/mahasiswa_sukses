class QuizResultModel {
  final int correctAnswers;
  final int totalQuestions;
  final int minimumScore;
  final bool passed;
  final int pointsGained;
  final int streakBonus;
  final String? certificateId;

  QuizResultModel({
    required this.correctAnswers,
    required this.totalQuestions,
    required this.minimumScore,
    required this.passed,
    required this.pointsGained,
    required this.streakBonus,
    this.certificateId,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      correctAnswers: json['correct_answers'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
      minimumScore: json['minimum_score'] ?? 0,
      passed: json['passed'] ?? false,
      pointsGained: json['points_gained'] ?? 0,
      streakBonus: json['streak_bonus'] ?? 0,
      certificateId: json['certificate_id'],
    );
  }
}
