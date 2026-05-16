import 'quiz_question_model.dart';

class QuizAttemptModel {
  final int attemptId;
  final String text;
  final int totalQuestions;
  final String endDateTime;
  final QuizQuestionModel firstQuestion;

  QuizAttemptModel({
    required this.attemptId,
    required this.text,
    required this.totalQuestions,
    required this.endDateTime,
    required this.firstQuestion,
  });

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptModel(
      attemptId: _toInt(json['attempt_id'] ?? json['attemptId'] ?? json['id']),
      text: json['text']?.toString() ?? '',
      totalQuestions: _toInt(
        json['total_questions'] ?? json['totalQuestions'] ?? 0,
      ),
      endDateTime: json['end_date_time']?.toString() ??
          json['endDateTime']?.toString() ??
          '',
      firstQuestion: QuizQuestionModel.fromJson(
        (json['first_question'] ?? json['firstQuestion'] ?? {})
            as Map<String, dynamic>,
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
