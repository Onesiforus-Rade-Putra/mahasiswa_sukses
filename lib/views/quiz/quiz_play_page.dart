import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/quiz_viewmodel.dart';
import 'quiz_result_page.dart';

class QuizPlayPage extends StatelessWidget {
  final int quizId;

  const QuizPlayPage({
    super.key,
    required this.quizId,
  });

  Future<bool> _showExitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const _ExitDialog(),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizViewModel>();
    final q = vm.currentQuestion;

    if (vm.isQuestionLoading && q == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (q == null) {
      return Scaffold(
        body: Center(
          child: Text(vm.errorMessage ?? 'Soal tidak ditemukan'),
        ),
      );
    }

    final progressValue =
        vm.totalQuestions == 0 ? 0.0 : q.currentNumber / vm.totalQuestions;

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await _showExitDialog(context);

        if (shouldExit) {
          await context.read<QuizViewModel>().exitQuizEarly(quizId);
        }

        return shouldExit;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final shouldExit = await _showExitDialog(context);

                        if (!context.mounted) return;

                        if (shouldExit) {
                          await context
                              .read<QuizViewModel>()
                              .exitQuizEarly(quizId);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFED1E28),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFFED1E28),
                          size: 18,
                        ),
                      ),
                    ),
                    Container(
                      height: 18,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFED1E28),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            '10.00',
                            style: TextStyle(
                              color: Color(0xFFED1E28),
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.timer_outlined,
                            color: Color(0xFFED1E28),
                            size: 11,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 42),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Soal',
                      style: TextStyle(
                        color: Color(0xFFED1E28),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${q.currentNumber}/${vm.totalQuestions}',
                      style: const TextStyle(
                        color: Color(0xFFED1E28),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 8,
                    backgroundColor: const Color(0xFF9D0007),
                    valueColor: const AlwaysStoppedAnimation(
                      Color(0xFFED1E28),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFED1E28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Pilih Jawaban',
                          style: TextStyle(
                            color: Color(0xFF8B8B8B),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 26),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    q.text,
                                    style: const TextStyle(
                                      color: Color(0xFF111111),
                                      fontSize: 13,
                                      height: 1.35,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                ...List.generate(q.options.length, (index) {
                                  final optionText = q.options[index];
                                  final optionKey = q.optionKeys[index];
                                  final isSelected =
                                      vm.selectedAnswer == optionKey;

                                  return GestureDetector(
                                    onTap: () {
                                      context
                                          .read<QuizViewModel>()
                                          .selectAnswer(optionKey);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 14),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFFFFD5D8)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFFED1E28),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isSelected
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: const Color(0xFFED1E28),
                                            size: 17,
                                          ),
                                          const SizedBox(width: 9),
                                          Expanded(
                                            child: Text(
                                              optionText,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 9,
                                                height: 1.25,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 37,
                          child: ElevatedButton(
                            onPressed: vm.selectedAnswer == null ||
                                    vm.isQuestionLoading
                                ? null
                                : () async {
                                    final isFinished = await context
                                        .read<QuizViewModel>()
                                        .nextQuestion(quizId);

                                    if (!context.mounted) return;

                                    if (isFinished) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => QuizResultPage(
                                            quizId: quizId,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFED1E28),
                              disabledBackgroundColor: const Color(0xFFF5A0A5),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: vm.isQuestionLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Selanjutnya',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExitDialog extends StatelessWidget {
  const _ExitDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(
          color: Color(0xFFED1E28),
        ),
      ),
      child: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Anda yakin ingin keluar quiz?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 88,
                  height: 24,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFED1E28),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Ya',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 34),
                SizedBox(
                  width: 88,
                  height: 24,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFED1E28),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Tidak',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
