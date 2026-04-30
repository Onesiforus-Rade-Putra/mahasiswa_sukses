import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_filex/open_filex.dart';
import '../../viewmodels/quiz_viewmodel.dart';
import '../../viewmodels/certificate_viewmodel.dart';

class QuizResultPage extends StatelessWidget {
  final int quizId;

  const QuizResultPage({
    super.key,
    required this.quizId,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizViewModel>();
    final result = vm.result;

    if (result == null) {
      return const Scaffold(
        body: Center(
          child: Text('Hasil quiz tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.fromLTRB(18, 46, 18, 26),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFED1E28),
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: Color(0xFFED1E28),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_outlined,
                    color: Colors.white,
                    size: 58,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  result.passed ? 'Quiz Selesai!' : 'Quiz Belum Lulus',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Kerja bagus! Kamu menjawab '),
                      TextSpan(
                        text:
                            '${result.correctAnswers} dari ${result.totalQuestions}',
                        style: const TextStyle(
                          color: Color(0xFFED1E28),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const TextSpan(text: ' soal dengan benar'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 34),
                Row(
                  children: [
                    Expanded(
                      child: _ResultBox(
                        icon: Icons.emoji_events_outlined,
                        title: 'Poin',
                        value: '+${result.pointsGained} Poin',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ResultBox(
                        icon: Icons.bolt,
                        title: 'Streak',
                        value: '+${result.streakBonus} Streak',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 42),
                SizedBox(
                  width: double.infinity,
                  height: 37,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED1E28),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Kembali ke Quest',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 24),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 37,
                  child: ElevatedButton.icon(
                    onPressed: result.certificateId == null
                        ? null
                        : () async {
                            final certVm = context.read<CertificateViewModel>();

                            String? certificateId = result.certificateId;

                            certificateId ??= await certVm.generateCertificate(
                              quizId.toString(),
                            );

                            if (!context.mounted) return;

                            if (certificateId == null ||
                                certificateId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    certVm.errorMessage ??
                                        'Gagal generate sertifikat',
                                  ),
                                ),
                              );
                              return;
                            }

                            final File? file = await certVm.downloadCertificate(
                              certificateId: certificateId,
                              fileName: 'sertifikat_quiz_$quizId',
                            );

                            if (!context.mounted) return;

                            if (file == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    certVm.errorMessage ??
                                        'Gagal download sertifikat',
                                  ),
                                ),
                              );
                              return;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sertifikat berhasil diunduh'),
                              ),
                            );

                            await OpenFilex.open(file.path);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      disabledBackgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text(
                      'Download Sertifikat',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 37,
                  child: OutlinedButton(
                    onPressed: () async {
                      final success =
                          await context.read<QuizViewModel>().startQuiz(quizId);

                      if (!context.mounted) return;

                      if (success) {
                        Navigator.pop(context);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFED1E28),
                      ),
                      foregroundColor: const Color(0xFFED1E28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text(
                      'Coba Lagi',
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
      ),
    );
  }
}

class _ResultBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ResultBox({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFED1E28),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color(0xFFED1E28),
            size: 38,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
