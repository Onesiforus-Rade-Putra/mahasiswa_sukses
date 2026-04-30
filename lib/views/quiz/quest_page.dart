import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/quest_viewmodel.dart';
import '../widgets/header_background.dart';
import 'quest_card.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({super.key});

  @override
  State<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  int selectedQuestTab = 0; // 0 = Harian, 1 = Mingguan

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<QuestViewModel>().fetchQuests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuestViewModel>();

    final quests = selectedQuestTab == 0 ? vm.dailyQuests : vm.weeklyQuests;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          HeaderBackground(
            height: 305,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 60, 28, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Quiz dan Quest',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Selesaikan tantangan untuk mendapatkan XP\ndan hadiah!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
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
                              '${_completedCount(vm.dailyQuests)}/${vm.dailyQuests.length} Quest',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _SmallProgress(
                              value: vm.dailyQuests.isNotEmpty &&
                                      vm.dailyQuests[0].isCompleted
                                  ? 1
                                  : 0,
                            ),
                            const SizedBox(width: 7),
                            _SmallProgress(
                              value: vm.dailyQuests.length > 1 &&
                                      vm.dailyQuests[1].isCompleted
                                  ? 1
                                  : 0,
                            ),
                            const SizedBox(width: 7),
                            _SmallProgress(
                              value: vm.dailyQuests.length > 2 &&
                                      vm.dailyQuests[2].isCompleted
                                  ? 1
                                  : 0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _MainQuestTab(
                    selectedIndex: selectedQuestTab,
                    onChanged: (index) {
                      setState(() {
                        selectedQuestTab = index;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            vm.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFED1E28),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          const _StreakSection(),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: quests.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 40),
                                    child: Center(
                                      child: Text(
                                        'Belum ada quest',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: quests
                                        .map((quest) => QuestCard(
                                              quest: quest,
                                            ))
                                        .toList(),
                                  ),
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  int _completedCount(List quests) {
    return quests.where((q) => q.isCompleted == true).length;
  }
}

class _SmallProgress extends StatelessWidget {
  final double value;

  const _SmallProgress({
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 9,
          backgroundColor: Colors.white.withOpacity(0.85),
          valueColor: const AlwaysStoppedAnimation(
            Color(0xFFED1E28),
          ),
        ),
      ),
    );
  }
}

class _MainQuestTab extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _MainQuestTab({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Expanded(
            child: _HeaderQuestTabButton(
              text: 'Quest harian',
              active: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _HeaderQuestTabButton(
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

class _HeaderQuestTabButton extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _HeaderQuestTabButton({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              maxLines: 1,
              style: TextStyle(
                color: active ? const Color(0xFFED1E28) : Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
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
