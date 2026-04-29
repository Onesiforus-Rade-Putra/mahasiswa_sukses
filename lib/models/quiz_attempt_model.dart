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
      attemptId: json['attempt_id'] ?? 0,
      text: json['text'] ?? '',
      totalQuestions: json['total_questions'] ?? 0,
      endDateTime: json['end_date_time'] ?? '',
      firstQuestion: QuizQuestionModel.fromJson(
        json['first_question'] ?? {},
      ),
    );
  }
}
