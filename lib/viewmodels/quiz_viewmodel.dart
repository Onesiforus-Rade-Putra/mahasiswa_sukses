import 'package:flutter/material.dart';

import '../models/quiz_model.dart';
import '../models/quiz_attempt_model.dart';
import '../models/quiz_question_model.dart';
import '../models/quiz_result_model.dart';
import '../services/quiz_service.dart';
import '../models/gamification_summary_model.dart';
import '../services/home_service.dart';

class QuizViewModel extends ChangeNotifier {
  final QuizService _service = QuizService();

  bool isLoading = false;
  bool isQuestionLoading = false;
  bool isSummaryLoading = false;

  String? errorMessage;

  List<QuizModel> quizzes = [];

  QuizAttemptModel? currentAttempt;
  QuizQuestionModel? currentQuestion;
  QuizResultModel? result;

  int progress = 0;
  int totalQuestions = 0;

  final Map<String, String> answers = {};

  final HomeService _homeService = HomeService();

  GamificationSummaryModel summary = const GamificationSummaryModel.empty();

  int get completedQuizToday {
    return quizzes.where((quiz) => quiz.lastAttemptSuccessful).length;
  }

  int get totalQuizToday {
    return quizzes.isEmpty ? 4 : quizzes.length;
  }

  double get quizProgressValue {
    if (totalQuizToday == 0) return 0;
    return (completedQuizToday / totalQuizToday).clamp(0.0, 1.0);
  }

  int get currentStreak {
    return summary.currentStreak == 0 ? 7 : summary.currentStreak;
  }

  Future<void> fetchQuiz() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      quizzes = await _service.getAllQuizzes().timeout(
            const Duration(seconds: 10),
          );
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }

    await fetchGamificationSummary();
  }

  Future<void> fetchGamificationSummary() async {
    isSummaryLoading = true;
    notifyListeners();

    try {
      final token = await _homeService.getSavedToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      summary = await _homeService.getGamificationSummary(token).timeout(
            const Duration(seconds: 8),
          );
    } catch (e) {
      debugPrint('GAMIFICATION SUMMARY ERROR: $e');

      summary = const GamificationSummaryModel.empty();
    } finally {
      isSummaryLoading = false;
      notifyListeners();
    }
  }

  Future<bool> startQuiz(int quizId) async {
    isQuestionLoading = true;
    errorMessage = null;
    answers.clear();
    result = null;
    notifyListeners();

    try {
      currentAttempt = await _service.startQuiz(quizId);
      currentQuestion = currentAttempt!.firstQuestion;
      totalQuestions = currentAttempt!.totalQuestions;
      progress = currentQuestion!.currentNumber;

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isQuestionLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(String optionKey) {
    if (currentQuestion == null) return;

    answers[currentQuestion!.id.toString()] = optionKey;
    notifyListeners();
  }

  String? get selectedAnswer {
    if (currentQuestion == null) return null;
    return answers[currentQuestion!.id.toString()];
  }

  Future<bool> nextQuestion(int quizId) async {
    if (currentQuestion == null) return false;

    final nextNumber = currentQuestion!.currentNumber + 1;

    if (nextNumber > totalQuestions) {
      return await submitQuiz(quizId);
    }

    isQuestionLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentQuestion = await _service.getQuizQuestion(
        quizId: quizId,
        questionNumber: nextNumber,
      );

      progress = currentQuestion!.currentNumber;
      return false;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isQuestionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitQuiz(int quizId) async {
    isQuestionLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      result = await _service.submitQuiz(
        quizId: quizId,
        answers: answers,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isQuestionLoading = false;
      notifyListeners();
    }
  }

  Future<void> exitQuizEarly(int quizId) async {
    try {
      await _service.exitQuizEarly(quizId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String?> generateCertificate(int quizId) async {
    try {
      return await _service.generateCertificate(quizId);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    }
  }
}
