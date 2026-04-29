import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mahasiswa_sukses/viewmodels/quiz_viewmodel.dart';
import 'package:mahasiswa_sukses/views/widgets/header_background.dart';
import 'package:mahasiswa_sukses/views/quiz/quiz_card.dart';
import 'package:mahasiswa_sukses/views/quiz/quest_card.dart';
import 'quest_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int selectedMainTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<QuizViewModel>().fetchQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          HeaderBackground(
            height: 292,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 58, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quiz dan Quest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Selesaikan tantangan untuk mendapatkan XP\ndan Sertifikat!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.24),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Progress Hari Ini',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${vm.progress} / 4 Quiz',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: vm.progress / 4,
                            minHeight: 5,
                            backgroundColor: Colors.white.withOpacity(0.85),
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFFFFB32C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMainTab = 0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedMainTab == 0
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Quiz',
                                  style: TextStyle(
                                    color: selectedMainTab == 0
                                        ? const Color(0xFFED1E28)
                                        : Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const QuestPage(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedMainTab == 1
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Quest',
                                  style: TextStyle(
                                    color: selectedMainTab == 1
                                        ? const Color(0xFFED1E28)
                                        : Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _QuizContent(vm: vm),
          ),
        ],
      ),
    );
  }
}

class _StreakSection extends StatelessWidget {
  const _StreakSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 42),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6813),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.local_fire_department_outlined,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak Kamu',
                  style: TextStyle(
                    color: Color(0xFFED1E28),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '7 hari berturut-turut',
                  style: TextStyle(
                    color: Color(0xFFED1E28),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Teruskan!',
            style: TextStyle(
              color: Color(0xFFED1E28),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestSwitchTab extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _QuestSwitchTab({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF9D3238).withOpacity(0.85),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFED1E28),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _QuestTabButton(
              text: 'Quest harian',
              active: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _QuestTabButton(
              text: 'Quest Mingguan',
              active: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestTabButton extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _QuestTabButton({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: active ? const Color(0xFFED1E28) : Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizContent extends StatelessWidget {
  final QuizViewModel vm;

  const _QuizContent({
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const _StreakSection(),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: Color(0xFFED1E28),
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                'Rekomendasi Untuk Kamu',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: vm.quizzes.isNotEmpty
              ? QuizCard(quiz: vm.quizzes.first)
              : const SizedBox(),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            'Semua Quiz',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: vm.quizzes.map((q) => QuizCard(quiz: q)).toList(),
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }
}
