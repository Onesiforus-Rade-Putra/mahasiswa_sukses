import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/quiz_model.dart';
import '../../viewmodels/quiz_viewmodel.dart';
import 'quiz_play_page.dart';

class QuizCard extends StatelessWidget {
  final QuizModel quiz;
  final bool showStatusBadge;

  const QuizCard({
    super.key,
    required this.quiz,
    this.showStatusBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFEDEDED),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quiz.category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF9E9E9E),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  quiz.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF222222),
                  ),
                ),
              ),
              if (showStatusBadge) ...[
                const SizedBox(width: 10),
                _StatusBadge(
                  completed: quiz.lastAttemptSuccessful,
                ),
              ],
            ],
          ),
          const SizedBox(height: 7),
          const Text(
            'Selesaikan Quiz untuk membuka sertifikat',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8,
              color: Color(0xFF9E9E9E),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Color(0xFF222222),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${quiz.durationMinutes} Menit',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Icon(
                      Icons.star,
                      size: 12,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${quiz.xpReward} XP',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
              _DifficultyBadge(
                difficulty: quiz.difficulty,
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              onPressed: () async {
                final vm = context.read<QuizViewModel>();

                final success = await vm.startQuiz(quiz.id);

                if (!context.mounted) return;

                if (success) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizPlayPage(
                        quizId: quiz.id,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        vm.errorMessage ?? 'Gagal memulai quiz',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED1E28),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text(
                'Mulai Quiz',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool completed;

  const _StatusBadge({
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    if (completed) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFCAFFD5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.circle,
              color: Color(0xFF00C853),
              size: 7,
            ),
            SizedBox(width: 5),
            Text(
              'Selesai',
              style: TextStyle(
                color: Color(0xFF00A844),
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0A8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Belum Dimulai',
        style: TextStyle(
          color: Color(0xFFFF9800),
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const _DifficultyBadge({
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 80,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD8A8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        difficulty,
        style: const TextStyle(
          color: Color(0xFFED1E28),
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
